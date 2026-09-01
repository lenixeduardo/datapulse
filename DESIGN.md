# DataPulse — Design System v1.1

## Direção

Dashboard SaaS **minimalista, branco, técnico e delicado**, inspirado na referência DataPulse fornecida pelo usuário. O layout evita grandes áreas decorativas e usa cor principalmente para comunicar estado.

## Tokens principais

| Token | Valor | Uso |
|---|---|---|
| Background | `#f7f9fc` | Fundo global |
| Surface | `#ffffff` | Cards e painéis |
| Ink | `#101828` | Texto principal |
| Muted | `#667085` | Texto secundário |
| Border | `#e7ebf2` | Bordas e divisores |
| Blue | `#1769ff` | Marca, links, processamento |
| Green | `#16a76a` | Sucesso / saúde |
| Purple | `#7b61e8` | Contratos / proteção |
| Orange | `#ff8a1f` | Infra / atenção |
| Red | `#ef5b67` | Falhas |

## Componentes

- Sidebar fixa e compacta no desktop.
- Topbar fina com busca, notificações e perfil.
- KPIs com ícones circulares coloridos e fundo pastel.
- Gráfico principal com linha azul fina e fill translúcido.
- Card de contratos com Zod, Runtime Validation e simulação interativa de quebra.
- Tabela de jobs com status e progresso real do Worker Thread.
- Card Deploy & Infraestrutura para evidenciar Docker multi-stage.
- Modal enxuto para criação de um novo relatório.

## Responsividade

### Desktop

Dashboard completo com sidebar, quatro KPIs, gráfico, contratos, fila e infraestrutura.

### Tablet

Sidebar vira apenas ícones e os painéis secundários são empilhados.

### Mobile

- Sidebar removida.
- Saudação e notificação no topo.
- KPIs essenciais.
- Fila simplificada como lista.
- Bottom navigation com Dashboard, Relatórios, Jobs e Mais.

## Princípios

1. Cor indica estado, não decoração.
2. Bordas claras substituem sombras fortes.
3. Tipografia compacta para alta densidade informacional.
4. O dashboard deve tornar os três casos técnicos legíveis como partes de um único produto.
