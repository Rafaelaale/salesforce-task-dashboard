public with sharing class TaskDashboardController {
    @AuraEnabled(cacheable=true)
    public static List<Task> getTasks(String statusFiltro, String prioridadeFiltro, String prazoFiltro) {
        try {
            String query = 'SELECT Id, Subject, Status, Priority, ActivityDate, IsClosed FROM Task';
            List<String> condicoes = new List<String>();

            if (String.isNotBlank(statusFiltro) && statusFiltro != 'Todos') {
                condicoes.add('Status = :statusFiltro');
            }
            if (String.isNotBlank(prioridadeFiltro) && prioridadeFiltro != 'Todos') {
                condicoes.add('Priority = :prioridadeFiltro');
            }
            if (prazoFiltro == 'Atrasadas') {
                condicoes.add('ActivityDate < TODAY AND IsClosed = false');
            } else if (prazoFiltro == 'Hoje') {
                condicoes.add('ActivityDate = TODAY');
            } else if (prazoFiltro == 'Futuras') {
                condicoes.add('ActivityDate > TODAY');
            }

            if (!condicoes.isEmpty()) {
                query += ' WHERE ' + String.join(condicoes, ' AND ');
            }
            query += ' ORDER BY ActivityDate ASC NULLS LAST LIMIT 200';

            List<Task> tarefas = Database.query(query);

            // remove campos que o usuário não tem permissão de ler, em vez de vazar o dado
            SObjectAccessDecision decisao = Security.stripInaccessible(AccessType.READABLE, tarefas);
            return (List<Task>) decisao.getRecords();
        } catch (Exception e) {
            throw new AuraHandledException('Erro ao buscar tarefas: ' + e.getMessage());
        }
    }
}
