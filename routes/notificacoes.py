import os
import logging
import httpx
from datetime import datetime

logger = logging.getLogger(__name__)

RESEND_API_KEY   = os.getenv("RESEND_API_KEY", "")
EMAIL_REMETENTE  = os.getenv("EMAIL_REMETENTE",  "EnergySafe <alertas@resend.dev>")
EMAIL_DESTINO    = os.getenv("EMAIL_DESTINO",    "")
NOTIFICAR_AVISOS = os.getenv("NOTIFICAR_AVISOS", "false").lower() == "true"


def _cor_nivel(nivel: str) -> str:
    return {"critico": "#ff3b5c", "aviso": "#ffcc00", "info": "#00e5a0"}.get(nivel, "#888")


def _html_alerta(canal_id, tipo, nivel, mensagem, valor, limite, timestamp) -> str:
    cor  = _cor_nivel(nivel)
    hora = timestamp.strftime("%d/%m/%Y %H:%M") if isinstance(timestamp, datetime) else str(timestamp)
    return f"""
    <div style="font-family:sans-serif;max-width:560px;margin:0 auto;background:#0a0c0f;color:#e8eaf0;border-radius:10px;overflow:hidden;">
      <div style="background:{cor};padding:16px 24px;">
        <h2 style="margin:0;color:#000;font-size:18px;">⚡ EnergySafe — Alerta {nivel.upper()}</h2>
      </div>
      <div style="padding:24px;">
        <table style="width:100%;border-collapse:collapse;font-size:14px;">
          <tr><td style="padding:8px 0;color:#888;">Tipo</td>
              <td style="padding:8px 0;font-weight:bold;">{tipo.replace("_"," ").title()}</td></tr>
          <tr><td style="padding:8px 0;color:#888;">Canal ID</td>
              <td style="padding:8px 0;">{canal_id}</td></tr>
          <tr><td style="padding:8px 0;color:#888;">Valor medido</td>
              <td style="padding:8px 0;">{valor} A</td></tr>
          <tr><td style="padding:8px 0;color:#888;">Limite</td>
              <td style="padding:8px 0;">{limite} A</td></tr>
          <tr><td style="padding:8px 0;color:#888;">Data/hora</td>
              <td style="padding:8px 0;">{hora}</td></tr>
          <tr><td style="padding:8px 0;color:#888;">Mensagem</td>
              <td style="padding:8px 0;">{mensagem}</td></tr>
        </table>
        <div style="margin-top:20px;padding:12px;background:#111318;border-radius:6px;font-size:13px;color:#888;">
          Acesse o painel de manutenção para resolver este alerta.
        </div>
      </div>
    </div>
    """


def enviar_alerta_email(
    canal_id:  int,
    tipo:      str,
    nivel:     str,
    mensagem:  str,
    valor:     float,
    limite:    float,
    timestamp: datetime,
) -> bool:
    """
    Envia e-mail de alerta via Resend.
    Retorna True se enviado, False se pulado ou com erro.
    """
    if not RESEND_API_KEY:
        logger.warning("RESEND_API_KEY não configurada — e-mail não enviado.")
        return False

    if not EMAIL_DESTINO:
        logger.warning("EMAIL_DESTINO não configurado — e-mail não enviado.")
        return False

    if nivel == "aviso" and not NOTIFICAR_AVISOS:
        logger.info(f"Alerta 'aviso' suprimido (NOTIFICAR_AVISOS=false).")
        return False

    assunto = f"[EnergySafe] Alerta {nivel.upper()} — {tipo.replace('_', ' ').title()}"
    html    = _html_alerta(canal_id, tipo, nivel, mensagem, valor, limite, timestamp)

    try:
        resp = httpx.post(
            "https://api.resend.com/emails",
            headers={
                "Authorization": f"Bearer {RESEND_API_KEY}",
                "Content-Type":  "application/json",
            },
            json={
                "from":    EMAIL_REMETENTE,
                "to":      [EMAIL_DESTINO],
                "subject": assunto,
                "html":    html,
            },
            timeout=10,
        )
        if resp.status_code == 200:
            logger.info(f"E-mail enviado: {assunto}")
            return True
        else:
            logger.error(f"Resend retornou {resp.status_code}: {resp.text}")
            return False
    except Exception as e:
        logger.error(f"Erro ao enviar e-mail: {e}")
        return False