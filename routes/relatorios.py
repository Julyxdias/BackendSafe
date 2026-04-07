"""
Geração de relatório de rateio em PDF via ReportLab.

GET /relatorios/rateio/{fatura_id} → retorna PDF para download.
"""

from fastapi import APIRouter, Depends, HTTPException
from fastapi.responses import StreamingResponse
from sqlalchemy.orm import Session
from io import BytesIO
from datetime import datetime

import models
from database import get_db

try:
    from reportlab.lib.pagesizes import A4
    from reportlab.lib import colors
    from reportlab.lib.units import cm
    from reportlab.platypus import (
        SimpleDocTemplate, Table, TableStyle, Paragraph,
        Spacer, HRFlowable
    )
    from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
    from reportlab.lib.enums import TA_CENTER, TA_LEFT

    VERDE_ESCURO = colors.HexColor("#00c47a")
    AZUL_ESCURO  = colors.HexColor("#0a0c0f")
    CINZA_CLARO  = colors.HexColor("#f4f6f9")
    CINZA_BORDA  = colors.HexColor("#d0d5dd")
    TEXTO_ESCURO = colors.HexColor("#1a1f2e")
    REPORTLAB_OK = True
except ImportError:
    REPORTLAB_OK = False
    VERDE_ESCURO = AZUL_ESCURO = CINZA_CLARO = CINZA_BORDA = TEXTO_ESCURO = None

router = APIRouter(prefix="/relatorios", tags=["Relatórios"])


def _gerar_pdf_rateio(fatura, rateios, areas_map: dict) -> BytesIO:
    buf = BytesIO()
    doc = SimpleDocTemplate(
        buf,
        pagesize=A4,
        leftMargin=2*cm, rightMargin=2*cm,
        topMargin=2*cm,  bottomMargin=2*cm,
    )

    styles  = getSampleStyleSheet()
    estilo_titulo = ParagraphStyle(
        "titulo", parent=styles["Normal"],
        fontSize=20, fontName="Helvetica-Bold",
        textColor=TEXTO_ESCURO, alignment=TA_LEFT,
    )
    estilo_sub = ParagraphStyle(
        "sub", parent=styles["Normal"],
        fontSize=11, fontName="Helvetica",
        textColor=colors.HexColor("#5a6070"), alignment=TA_LEFT,
    )
    estilo_label = ParagraphStyle(
        "label", parent=styles["Normal"],
        fontSize=9, fontName="Helvetica",
        textColor=colors.HexColor("#5a6070"),
    )
    estilo_valor = ParagraphStyle(
        "valor", parent=styles["Normal"],
        fontSize=13, fontName="Helvetica-Bold",
        textColor=TEXTO_ESCURO,
    )

    conteudo = []

    # ── Cabeçalho ────────────────────────────────────────────────
    conteudo.append(Paragraph("⚡ EnergySafe", estilo_titulo))
    conteudo.append(Paragraph("Relatório de Rateio de Fatura", estilo_sub))
    conteudo.append(Spacer(1, 0.3*cm))
    conteudo.append(HRFlowable(width="100%", thickness=2, color=VERDE_ESCURO))
    conteudo.append(Spacer(1, 0.5*cm))

    # ── KPIs da fatura ───────────────────────────────────────────
    mes_str = fatura.mes.strftime("%B/%Y").capitalize() if fatura.mes else "—"
    kpi_data = [
        ["Mês de referência", "Valor total da fatura", "kWh total medido", "Gerado em"],
        [
            mes_str,
            f"R$ {fatura.valor_total:,.2f}".replace(",", "X").replace(".", ",").replace("X", "."),
            f"{fatura.kwh_total:,.1f} kWh".replace(",", ".") if fatura.kwh_total else "—",
            datetime.now().strftime("%d/%m/%Y %H:%M"),
        ],
    ]
    kpi_table = Table(kpi_data, colWidths=[4.2*cm, 4.2*cm, 4.2*cm, 4.2*cm])
    kpi_table.setStyle(TableStyle([
        ("BACKGROUND",  (0,0), (-1,0), CINZA_CLARO),
        ("TEXTCOLOR",   (0,0), (-1,0), colors.HexColor("#5a6070")),
        ("FONTNAME",    (0,0), (-1,0), "Helvetica"),
        ("FONTSIZE",    (0,0), (-1,0), 8),
        ("FONTNAME",    (0,1), (-1,1), "Helvetica-Bold"),
        ("FONTSIZE",    (0,1), (-1,1), 12),
        ("TEXTCOLOR",   (0,1), (-1,1), TEXTO_ESCURO),
        ("ALIGN",       (0,0), (-1,-1), "CENTER"),
        ("VALIGN",      (0,0), (-1,-1), "MIDDLE"),
        ("ROWBACKGROUNDS", (0,1), (-1,1), [colors.white]),
        ("BOX",         (0,0), (-1,-1), 1, CINZA_BORDA),
        ("INNERGRID",   (0,0), (-1,-1), 0.5, CINZA_BORDA),
        ("TOPPADDING",  (0,0), (-1,-1), 8),
        ("BOTTOMPADDING",(0,0),(-1,-1), 8),
    ]))
    conteudo.append(kpi_table)
    conteudo.append(Spacer(1, 0.8*cm))

    # ── Tabela de rateio ─────────────────────────────────────────
    conteudo.append(Paragraph("Distribuição por área", ParagraphStyle(
        "sec", parent=styles["Normal"],
        fontSize=13, fontName="Helvetica-Bold", textColor=TEXTO_ESCURO,
    )))
    conteudo.append(Spacer(1, 0.3*cm))

    tabela_dados = [["Área", "kWh consumido", "% do total", "R$ a pagar"]]

    total_kwh = sum(r.kwh for r in rateios)
    total_rs  = sum(r.valor_rs for r in rateios)

    def fmt_rs(v):
        return f"R$ {v:,.2f}".replace(",", "X").replace(".", ",").replace("X", ".")

    for r in sorted(rateios, key=lambda x: x.valor_rs, reverse=True):
        area_nome = areas_map.get(r.area_id, f"Área {r.area_id}")
        tabela_dados.append([
            area_nome,
            f"{r.kwh:,.1f}".replace(",", "."),
            f"{r.percentual:.1f}%",
            fmt_rs(r.valor_rs),
        ])

    # Linha de total
    tabela_dados.append([
        "TOTAL",
        f"{total_kwh:,.1f}".replace(",", "."),
        "100%",
        fmt_rs(total_rs),
    ])

    n_linhas = len(tabela_dados)
    rat_table = Table(tabela_dados, colWidths=[6.5*cm, 3.5*cm, 3*cm, 3.8*cm])
    rat_table.setStyle(TableStyle([
        # Cabeçalho
        ("BACKGROUND",   (0,0), (-1,0), AZUL_ESCURO),
        ("TEXTCOLOR",    (0,0), (-1,0), colors.white),
        ("FONTNAME",     (0,0), (-1,0), "Helvetica-Bold"),
        ("FONTSIZE",     (0,0), (-1,0), 9),
        ("ALIGN",        (0,0), (-1,0), "CENTER"),
        # Dados
        ("FONTNAME",     (0,1), (-1,n_linhas-2), "Helvetica"),
        ("FONTSIZE",     (0,1), (-1,n_linhas-2), 10),
        ("TEXTCOLOR",    (0,1), (-1,n_linhas-2), TEXTO_ESCURO),
        ("ROWBACKGROUNDS",(0,1),(-1,n_linhas-2), [colors.white, CINZA_CLARO]),
        # Coluna numérica alinhada à direita
        ("ALIGN",        (1,1), (-1,-1), "RIGHT"),
        ("ALIGN",        (0,1), (0,-1),  "LEFT"),
        # Linha de total
        ("BACKGROUND",   (0,n_linhas-1), (-1,n_linhas-1), CINZA_CLARO),
        ("FONTNAME",     (0,n_linhas-1), (-1,n_linhas-1), "Helvetica-Bold"),
        ("FONTSIZE",     (0,n_linhas-1), (-1,n_linhas-1), 10),
        ("TEXTCOLOR",    (0,n_linhas-1), (-1,n_linhas-1), TEXTO_ESCURO),
        # Bordas
        ("BOX",          (0,0), (-1,-1), 1, CINZA_BORDA),
        ("INNERGRID",    (0,0), (-1,-1), 0.5, CINZA_BORDA),
        ("TOPPADDING",   (0,0), (-1,-1), 7),
        ("BOTTOMPADDING",(0,0), (-1,-1), 7),
        ("LEFTPADDING",  (0,0), (-1,-1), 10),
        ("RIGHTPADDING", (0,0), (-1,-1), 10),
    ]))
    conteudo.append(rat_table)
    conteudo.append(Spacer(1, 1*cm))

    # ── Rodapé ───────────────────────────────────────────────────
    conteudo.append(HRFlowable(width="100%", thickness=0.5, color=CINZA_BORDA))
    conteudo.append(Spacer(1, 0.2*cm))
    conteudo.append(Paragraph(
        f"EnergySafe • Relatório gerado em {datetime.now().strftime('%d/%m/%Y às %H:%M')} • Protótipo acadêmico",
        ParagraphStyle("rodape", parent=styles["Normal"],
                       fontSize=8, textColor=colors.HexColor("#9aa0b0"), alignment=TA_CENTER),
    ))

    doc.build(conteudo)
    buf.seek(0)
    return buf


# ── endpoint ─────────────────────────────────────────────────────────────────

@router.get("/rateio/{fatura_id}", summary="Gera PDF do rateio de uma fatura")
def gerar_relatorio_rateio(fatura_id: int, db: Session = Depends(get_db)):
    if not REPORTLAB_OK:
        raise HTTPException(
            status_code=500,
            detail="ReportLab não instalado. Adicione 'reportlab' ao requirements.txt.",
        )

    fatura = db.query(models.Fatura).filter(models.Fatura.id == fatura_id).first()
    if not fatura:
        raise HTTPException(status_code=404, detail="Fatura não encontrada.")

    rateios = db.query(models.Rateio).filter(models.Rateio.fatura_id == fatura_id).all()
    if not rateios:
        raise HTTPException(status_code=404, detail="Nenhum rateio encontrado para esta fatura.")

    areas = db.query(models.Area).all()
    areas_map = {a.id: a.nome for a in areas}

    pdf_buf  = _gerar_pdf_rateio(fatura, rateios, areas_map)
    mes_str  = fatura.mes.strftime("%Y-%m") if fatura.mes else "rateio"
    filename = f"rateio_{mes_str}_fatura{fatura_id}.pdf"

    return StreamingResponse(
        pdf_buf,
        media_type="application/pdf",
        headers={"Content-Disposition": f'attachment; filename="{filename}"'},
    )