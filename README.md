# DataPulse — SaaS de relatórios assíncronos

DataPulse é um projeto Full Stack de portfólio que transforma três perguntas clássicas de entrevista em um **SaaS funcional**: processamento CPU-bound sem bloquear o Event Loop, contratos externos validados em runtime e deploy com Docker multi-stage.

A versão **v1.1.0** aplica ao produto o dashboard branco/azul da referência fornecida: navegação lateral enxuta, cards operacionais coloridos, gráfico de volume, fila de jobs, validação de contratos e painel de infraestrutura.

![Referência visual do dashboard](docs/design-reference.jpeg)

## O produto

O usuário cria um relatório, recebe `202 Accepted`, acompanha o job na fila e vê o progresso enviado pelo Worker Thread. O dashboard também possui uma ação para simular uma quebra de contrato e comprovar o bloqueio feito pelo Zod em runtime.

### Os três casos técnicos

1. **Node.js / Event Loop** — tarefas CPU-bound rodam em Worker Threads.
2. **TypeScript / runtime contracts** — payloads externos entram como `unknown` e são validados com Zod.
3. **Docker** — build multi-stage separa compilação e runtime e leva apenas o necessário para produção.

## Stack

- Node.js 24
- TypeScript
- Express 5
- Zod 4
- Worker Threads
- HTML + CSS + JavaScript sem framework no dashboard
- Vitest + Supertest
- Docker multi-stage

## Rodar localmente

```bash
npm install
npm run dev
```

Abra `http://localhost:3000`.

## Fluxo da fila

```text
Dashboard
   │
   │ POST /api/reports
   ▼
Express API
   │
   ├── 202 Accepted
   ▼
Job Manager
   │
   ▼
Worker Thread
   │
   ├── progress events
   ▼
Dashboard atualiza ~900 ms
```

Clique em **+ Novo relatório** para criar um job real. Ele passa por `queued → processing → completed/failed`.

### API de relatórios

```bash
curl http://localhost:3000/api/reports
```

```bash
curl -X POST http://localhost:3000/api/reports \
  -H 'content-type: application/json' \
  -d '{"title":"Análise de Vendas","sourceFile":"vendas.csv","limit":6000000}'
```

## Validação de contratos em runtime

No card **Validação de contratos**, clique em **Simular quebra**. O frontend chama:

```bash
curl 'http://localhost:3000/api/customers/customer-123?broken=true'
```

A aplicação responde com `502 UPSTREAM_CONTRACT_VIOLATION` em vez de permitir que um objeto incompatível com o schema circule pelo sistema.

## Docker otimizado

```bash
docker build -t datapulse-processing-saas .
docker run --rm -p 3000:3000 datapulse-processing-saas
```

Para investigar as layers:

```bash
docker image ls datapulse-processing-saas
docker history datapulse-processing-saas
```

## Estrutura

```text
datapulse-processing-saas/
├── public/
│   ├── index.html
│   ├── styles.css
│   └── app.js
├── docs/
│   └── design-reference.jpeg
├── src/
│   ├── contracts/
│   ├── jobs/
│   ├── routes/
│   ├── services/
│   └── workers/
├── tests/
├── Dockerfile
├── DESIGN.md
├── CHANGELOG.md
└── package.json
```

## Testes

```bash
npm test
npm run typecheck
npm run build
```

## Como explicar em entrevista

**Event Loop:** a request só cria o job e responde com `202`; o cálculo pesado é deslocado para Worker Threads para manter a thread principal disponível para I/O.

**Contrato runtime:** TypeScript não valida JSON recebido pela rede. As fronteiras externas são tratadas como não confiáveis e passam por schemas Zod antes de entrar no domínio.

**Docker:** o build multi-stage impede que compiladores, source, testes e `devDependencies` cheguem à imagem final.

## Persistência

A fila está em memória por escolha didática. Em produção, jobs e resultados deveriam ser persistidos e a fila poderia evoluir para Redis/BullMQ, SQS, RabbitMQ ou outro broker.
