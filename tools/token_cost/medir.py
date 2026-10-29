"""MC.0: custo em tokens de consultar um componente SeedGrid pela KB ou pelo MCP.

Le as saidas reais do MCP (saidas.<plataforma>.json, geradas por collect.mjs) e monta o que a rotina da KB poe no
contexto (skill sg-componente: Indice.md, Grep + faixa do API.md/Exemplos.md, validate-props.mjs). Conta tokens com o
tokenizador o200k_base da OpenAI (tiktoken). Os numeros sao uma APROXIMACAO dos tokens do Claude (o valor absoluto muda
de tokenizador para tokenizador; a razao KB/MCP quase nao).

Uso: python tools/token_cost/medir.py [--kb <pasta SeedGrid/SeedGrid-components>] [--skill <pasta sg-componente>]
     [--flutter-src <pasta packages/seedgrid_components/lib/src/generated>] [--saida <arquivo .md>]
"""
import argparse
import json
import re
import statistics
import subprocess
import sys
from pathlib import Path

import tiktoken

ENC = tiktoken.get_encoding("o200k_base")
HERE = Path(__file__).resolve().parent
COMPONENTES = ["SgButton", "SgInputText", "SgInputCPF", "SgInputCurrency", "SgCombobox", "SgDatatable", "SgDialog", "SgCalendar", "SgMenu", "SgToggleSwitch", "SgGrid", "SgToolBar"]
BUSCAS = [
    "campo para digitar CPF",
    "tabela com paginacao e ordenacao",
    "dialogo de confirmacao ao excluir",
    "escolher uma data",
    "lista dupla para mover itens entre duas colunas",
    "campo de valor em moeda",
]

p = argparse.ArgumentParser()
p.add_argument("--kb", default="D:/empreendedorismo/seedgrid/seedgrid-ia/seedgridKB/SeedGrid/SeedGrid-components")
p.add_argument("--skill", default="D:/empreendedorismo/seedgrid/develop/.claude/skills/sg-componente")
p.add_argument("--flutter-src", default=str(HERE.parents[1] / "packages/seedgrid_components/lib/src/generated"))
p.add_argument("--saida", default=str(HERE / "relatorio.md"))
a = p.parse_args()
KB, SKILL, GEN = Path(a.kb), Path(a.skill), Path(a.flutter_src)


def tok(s: str) -> int:
    return len(ENC.encode(s, disallowed_special=()))


def ler(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def secao(arquivos, nome):
    """Faixa lida pela rotina da KB, na ordem em que um agente a acharia com `Grep` + offset/limit:
    1) `## <nome>`; 2) titulo de secao que cita o nome; 3) primeira secao cujo corpo cita o nome;
    4) arquivo sem secoes `## ` (grupo de um componente so): le o arquivo inteiro. Devolve (texto, nota do grep)."""
    word = re.compile(r"\b" + re.escape(nome) + r"\b")
    for modo in (1, 2, 3, 4):
        for f in arquivos:
            linhas = ler(f).split("\n")
            heads = [i for i, l in enumerate(linhas) if re.match(r"^## ", l)]
            if modo == 4:
                if not heads and word.search("\n".join(linhas)):
                    return "\n".join(linhas), f"{f.name}: arquivo inteiro (sem secoes)"
                continue
            for k, i in enumerate(heads):
                fim = heads[k + 1] if k + 1 < len(heads) else len(linhas)
                titulo = linhas[i]
                corpo = "\n".join(linhas[i:fim])
                hit = (
                    re.match(r"^## " + re.escape(nome) + r"\b", titulo) if modo == 1
                    else word.search(titulo) if modo == 2
                    else word.search(corpo)
                )
                if hit:
                    return corpo, f"{f.name}:{i + 1}:{titulo}"
    return None, None


def snake(n: str) -> str:
    return re.sub(r"(?<!^)(?=[A-Z])", "_", n).lower().replace("s_g_", "sg_").replace("_c_p_f", "_cpf")


# ---- KB (React): rotina da skill sg-componente ---------------------------------------------------------------
api_react = sorted(KB.glob("*/API.md"))
exe_react = sorted(KB.glob("*/Exemplos.md"))
exe_flutter = sorted((KB / "flutter").glob("Exemplos-*.md"))
indice = ler(KB / "Indice.md")
skill_md = ler(SKILL / "SKILL.md")
preciso = ler(KB / "Preciso-de.md")
map_flutter = ler(KB / "flutter" / "API-por-grupo.md")
onde = re.search(r"## Onde fica cada grupo\?.*?(?=\n## )", map_flutter, re.S).group(0)


def rodar_validador(*args):
    cmd = ["node", str(SKILL / "scripts/validate-props.mjs"), *args]
    r = subprocess.run(cmd, capture_output=True, text=True, encoding="utf-8", cwd=str(SKILL.parent.parent.parent))
    return " ".join(["node", ".ai/skills/sg-componente/scripts/validate-props.mjs", *args]), (r.stdout + r.stderr)


def kb_react(nome, props_nomes):
    api, g1 = secao(api_react, nome)
    exe, g2 = secao(exe_react, nome)
    cmd1, lista = rodar_validador(nome, "--list")
    cmd2, val = rodar_validador(nome, "--props", ",".join(props_nomes + ["propInexistenteXyz"]))
    conhecer = [g1 or "", api or "", g2 or "", exe or "", cmd1, lista]
    return {"conhecer": "\n".join(conhecer), "validar": cmd2 + "\n" + val, "achou_api": api is not None, "achou_exe": exe is not None}


def kb_flutter(nome):
    g = GEN / f"{snake(nome)}.g.dart"
    contrato = ler(g) if g.exists() else ""
    exe, g2 = secao(exe_flutter, nome)
    return {"conhecer": "\n".join([onde, g2 or "", exe or "", contrato]), "achou_contrato": g.exists(), "achou_exe": exe is not None}


def tamanho_tools(d):
    return tok(json.dumps(d["tools"], ensure_ascii=False))


saidas = {pl: json.loads(ler(HERE / f"saidas.{pl}.json")) for pl in ("react", "flutter")}
linhas = {}  # (plataforma, tipo) -> lista de (rotulo, kb, mcp, mcp_leve)

for pl in ("react", "flutter"):
    d = saidas[pl]
    for nome in COMPONENTES:
        c = d["componentes"][nome]
        names = list(c["validate_props"]["args"]["props"].keys())[:-1]
        mcp_full = tok(json.dumps(c["get_component_full"]["args"]) + c["get_component_full"]["text"])
        mcp_props = tok(json.dumps(c["get_component_props"]["args"]) + c["get_component_props"]["text"])
        mcp_val = tok(json.dumps(c["validate_props"]["args"]) + c["validate_props"]["text"])
        if pl == "react":
            k = kb_react(nome, names)
            kb_con, kb_val = tok(k["conhecer"]), tok(k["validar"])
            ok = k["achou_api"] and k["achou_exe"]
        else:
            k = kb_flutter(nome)
            kb_con, kb_val = tok(k["conhecer"]), None  # a KB Flutter nao tem validador: o contrato ja esta no "conhecer"
            ok = k["achou_contrato"]
        linhas.setdefault((pl, "conhecer"), []).append((nome, kb_con, mcp_full, mcp_props, ok))
        linhas.setdefault((pl, "validar"), []).append((nome, kb_val, mcp_val, None, ok))
    for q in BUSCAS:
        b = d["buscas"][q]["search_components_semantic"]
        mcp = tok(json.dumps(b["args"], ensure_ascii=False) + b["text"])
        vazio = pl == "flutter" and json.loads(b["text"]).get("source") == "fallback"
        linhas.setdefault((pl, "achar"), []).append((q, tok(preciso), None if vazio else mcp, None, not vazio))

# ---- relatorio -------------------------------------------------------------------------------------------------
fixo = {
    "react": {"kb": tok(skill_md) + tok(indice), "mcp": tamanho_tools(saidas["react"])},
    "flutter": {"kb": tok(skill_md) + tok(indice), "mcp": tamanho_tools(saidas["flutter"])},
}
md = []
md.append("# Custo em tokens: KB x MCP de componentes (MC.0)\n")
md.append("Tokenizador: **o200k_base (OpenAI/tiktoken)**, aproximacao dos tokens do Claude. O valor absoluto muda de tokenizador para tokenizador; a razao KB/MCP e o que sustenta a decisao.\n")
md.append(f"Origem dos dados: saidas reais do MCP por stdio (`--platform=react|flutter`, `collect.mjs`) e os arquivos reais da KB. {len(COMPONENTES)} componentes e {len(BUSCAS)} buscas por plataforma.\n")


def media(v):
    return statistics.mean(v) if v else 0


md.append("## Resumo por tipo de consulta (tokens por consulta, media)\n")
md.append("| Plataforma | Tipo | KB | MCP | MCP leve | KB / MCP | KB / MCP leve |\n|---|---|---:|---:|---:|---:|---:|")
resumo = {}
for (pl, tipo), rows in linhas.items():
    rows_ok = [r for r in rows if r[1] is not None and r[2] is not None]
    if not rows_ok:
        motivo = "a KB Flutter nao tem validador" if tipo == "validar" else "busca vetorial do MCP Flutter sem colecao indexada (fallback vazio)"
        md.append(f"| {pl} | {tipo} | n/c ({motivo}) | - | - | - | - |")
        continue
    kb = [r[1] for r in rows_ok]
    mcp = [r[2] for r in rows_ok]
    leve = [r[3] for r in rows_ok if r[3] is not None]
    mk, mm = media(kb), media(mcp)
    ml = media(leve) if leve else None
    resumo[(pl, tipo)] = (mk, mm, ml)
    md.append(f"| {pl} | {tipo} | {mk:.0f} | {mm:.0f} | {('%.0f' % ml) if ml else '-'} | {mk / mm:.1f}x | {('%.1f' % (mk / ml) + 'x') if ml else '-'} |")
md.append("\n`conhecer` = conhecer um componente; `achar` = achar o componente por necessidade; `validar` = validar props. MCP = `get_component` completo (padrao); MCP leve = `get_component` com `fields: \"props\"`. Em `achar`, a KB le o `Preciso-de.md` inteiro e o MCP faz uma busca vetorial.\n")
md.append("## Custo fixo por conversa\n")
md.append("| Plataforma | KB (SKILL.md + Indice.md, lidos sempre) | MCP (definicoes das tools) |\n|---|---:|---:|")
for pl in ("react", "flutter"):
    md.append(f"| {pl} | {fixo[pl]['kb']} | {fixo[pl]['mcp']} |")
md.append("\nNa pratica, uma conversa paga o custo fixo uma vez e depois cada consulta. Custo total para N consultas `conhecer`:\n")
md.append("| Plataforma | N | KB | MCP | KB / MCP |\n|---|---:|---:|---:|---:|")
for pl in ("react", "flutter"):
    mk, mm, _ = resumo[(pl, "conhecer")]
    for n in (1, 3, 5, 10):
        tk, tm = fixo[pl]["kb"] + n * mk, fixo[pl]["mcp"] + n * mm
        md.append(f"| {pl} | {n} | {tk:.0f} | {tm:.0f} | {tk / tm:.1f}x |")
md.append("\n## Detalhe por consulta\n")
for (pl, tipo), rows in linhas.items():
    md.append(f"### {pl} / {tipo}\n\n| Consulta | KB | MCP | MCP leve | Observacao |\n|---|---:|---:|---:|---|")
    for rot, kb, mcp, leve, ok in rows:
        obs = "" if ok else ("busca do MCP em fallback, saida vazia" if mcp is None else "secao ou contrato nao encontrado na KB")
        md.append(f"| {rot} | {kb if kb is not None else 'n/a'} | {mcp if mcp is not None else 'n/c'} | {leve if leve is not None else '-'} | {obs} |")
    md.append("")
md.append("## Limites\n")
md.append("- Tokenizador da OpenAI como aproximacao do Claude (decisao do dono em 2026-10-29); para numeros exatos do Claude, trocar `tok()` pela API `count_tokens` da Anthropic.")
md.append("- Conta o que entra no contexto (argumentos e saidas das tools, trechos lidos da KB); nao conta o raciocinio do modelo nem o codigo que ele escreve depois.")
md.append("- A KB Flutter nao tem busca por necessidade propria nem validador: usa o `Preciso-de.md` compartilhado e o contrato `.g.dart`.")
Path(a.saida).write_text("\n".join(md) + "\n", encoding="utf-8")
print("\n".join(md[:30]))
