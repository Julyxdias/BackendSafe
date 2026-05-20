#!/usr/bin/env bash
# =============================================================
# run_migration.sh — executa migration Enel SP de forma segura
#
# Uso:
#   chmod +x run_migration.sh
#   ./run_migration.sh
#
# A URL do banco pode vir de variável de ambiente ou ser
# digitada interativamente. Nunca escreva a senha aqui.
# =============================================================

set -euo pipefail   # aborta em qualquer erro, variável undefined ou pipe falho

# ── 1. Localiza o arquivo SQL ao lado deste script ───────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SQL_FILE="$SCRIPT_DIR/migration_enel_sp_safe.sql"

if [[ ! -f "$SQL_FILE" ]]; then
  echo "✗ Arquivo não encontrado: $SQL_FILE"
  exit 1
fi

# ── 2. URL de conexão ─────────────────────────────────────────
# Prioridade: variável DATABASE_URL → pergunta interativamente
if [[ -z "${DATABASE_URL:-}" ]]; then
  echo ""
  echo "Variável DATABASE_URL não definida."
  echo "Exemplo: postgresql://usuario:senha@host:5432/banco"
  read -rsp "Cole a connection string (a senha não aparece): " DATABASE_URL
  echo ""
fi

# ── 3. Confirmação ───────────────────────────────────────────
echo ""
echo "Migration a executar : $SQL_FILE"
# Oculta a senha da URL no log (substitui :senha@ por :***@)
URL_LOG=$(echo "$DATABASE_URL" | sed 's|:[^:@]*@|:***@|')
echo "Banco de destino     : $URL_LOG"
echo ""
read -rp "Confirmar? (s/N) " CONFIRMA
if [[ "$CONFIRMA" != "s" && "$CONFIRMA" != "S" ]]; then
  echo "Cancelado."
  exit 0
fi

# ── 4. Backup automático antes de qualquer alteração ─────────
BACKUP_FILE="$SCRIPT_DIR/backup_pre_migration_$(date +%Y%m%d_%H%M%S).sql"
echo ""
echo "→ Gerando backup em: $BACKUP_FILE"
pg_dump "$DATABASE_URL" -f "$BACKUP_FILE"
echo "✓ Backup concluído."

# ── 5. Executa a migration dentro de uma transação explícita ──
#
# -v ON_ERROR_STOP=1  → aborta no primeiro erro (psql padrão ignora erros)
# --single-transaction → envolve TODO o arquivo em BEGIN/COMMIT automaticamente
#                        (sobrescreve o BEGIN/COMMIT interno do SQL de forma segura)
# -f                  → lê do arquivo (nunca cole SQL na linha de comando)
#
echo ""
echo "→ Executando migration..."
psql \
  --single-transaction \
  -v ON_ERROR_STOP=1 \
  -f "$SQL_FILE" \
  "$DATABASE_URL"

echo ""
echo "✓ Migration concluída com sucesso."

# ── 6. Verificação rápida ─────────────────────────────────────
echo ""
echo "→ Verificando tabelas criadas/alteradas:"
psql "$DATABASE_URL" -c "
SELECT table_name, 
       (SELECT COUNT(*) FROM information_schema.columns c
        WHERE c.table_name = t.table_name AND c.table_schema = 'public') AS colunas
FROM information_schema.tables t
WHERE table_schema = 'public'
  AND table_name IN ('faturas','enel_instalacoes','faturas_ocr','fatura_itens')
ORDER BY table_name;
"

echo ""
echo "→ rateio continua intacta (FK preservada):"
psql "$DATABASE_URL" -c "SELECT COUNT(*) AS linhas_rateio FROM rateio;"
