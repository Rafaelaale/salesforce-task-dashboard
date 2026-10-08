# Salesforce Task Dashboard

## Objetivo
Dashboard em Lightning Web Component para visualizar tarefas (`Task`) com filtros por status, prioridade e prazo, destacando tarefas atrasadas.

## Problema que resolve
Listar e filtrar tarefas manualmente nas views padrão do Salesforce é lento. Este componente centraliza a visualização com filtros diretos e um resumo visual de atraso.

## Funcionalidades
- Filtros por status, prioridade e prazo (atrasadas, hoje, futuras)
- Contagem de tarefas atrasadas e em dia
- Tabela dinâmica (`lightning-datatable`) com os resultados
- Tratamento de estado vazio e de erro

## Tecnologias
Lightning Web Components · Apex · SOQL · Apex Test Classes

## Arquitetura
```
taskDashboard (LWC)
   -> @wire TaskDashboardController.getTasks
   -> SOQL dinâmico com bind variables (filtros)
   -> retorno renderizado na tabela
```
`TaskDashboardController.getTasks` monta o SOQL dinamicamente a partir dos filtros recebidos, usando variáveis bind do Apex (sem concatenar valores no texto da query) para evitar SOQL Injection.

## Testes
`TaskDashboardControllerTest` cobre:
- Filtro por status
- Filtro por prioridade
- Filtro por tarefas atrasadas
- Busca sem filtros

## Prints / demonstração
> Adicionar aqui print do componente com tarefas filtradas e do resultado dos testes Apex.

## Como executar / reproduzir
```powershell
sf project deploy start -o seuOrg
```
Depois, adicione o componente `taskDashboard` em uma App Page ou Home Page pelo App Builder (o projeto já inclui `Task_Dashboard_Preview`, uma App Page pronta para visualizar o componente em Setup → Lightning App Builder → Edit).

## Decisões técnicas
- Uso do objeto padrão `Task` para não depender de schema customizado.
- Filtros tratados como bind variables no Apex, evitando SOQL Injection.
- `cacheable=true` no método Apex para aproveitar o cache do Lightning Data Service.

## Próximas melhorias
- Paginação para grandes volumes de tarefas
- Filtro por responsável (Owner)
- Exportação dos resultados
