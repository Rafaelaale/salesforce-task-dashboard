@isTest
private class TaskDashboardControllerTest {
    // Orgs com automação própria em Task (ex.: outro projeto de priorização) podem
    // disparar callouts no insert; o mock genérico evita falha nesses cenários.
    private class MockCalloutGenerico implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"task_ids":[]}');
            return res;
        }
    }

    private static void criarTarefas() {
        insert new List<Task>{
            new Task(Subject = 'Atrasada', Status = 'Not Started', Priority = 'High', ActivityDate = Date.today().addDays(-2)),
            new Task(Subject = 'Hoje', Status = 'In Progress', Priority = 'Normal', ActivityDate = Date.today()),
            new Task(Subject = 'Futura', Status = 'Not Started', Priority = 'Low', ActivityDate = Date.today().addDays(5)),
            new Task(Subject = 'Concluida', Status = 'Completed', Priority = 'Normal', ActivityDate = Date.today().addDays(-10))
        };
    }

    @isTest
    static void testFiltroPorStatus() {
        Test.setMock(HttpCalloutMock.class, new MockCalloutGenerico());
        Test.startTest();
        criarTarefas();
        Test.stopTest();

        List<Task> resultado = TaskDashboardController.getTasks('Not Started', 'Todos', 'Todos');
        System.assertEquals(2, resultado.size());
    }

    @isTest
    static void testFiltroAtrasadas() {
        Test.setMock(HttpCalloutMock.class, new MockCalloutGenerico());
        Test.startTest();
        criarTarefas();
        Test.stopTest();

        List<Task> resultado = TaskDashboardController.getTasks('Todos', 'Todos', 'Atrasadas');
        System.assertEquals(1, resultado.size());
    }

    @isTest
    static void testFiltroPrioridade() {
        Test.setMock(HttpCalloutMock.class, new MockCalloutGenerico());
        Test.startTest();
        criarTarefas();
        Test.stopTest();

        List<Task> resultado = TaskDashboardController.getTasks('Todos', 'High', 'Todos');
        System.assertEquals(1, resultado.size());
    }

    @isTest
    static void testSemFiltros() {
        Test.setMock(HttpCalloutMock.class, new MockCalloutGenerico());
        Test.startTest();
        criarTarefas();
        Test.stopTest();

        List<Task> resultado = TaskDashboardController.getTasks('Todos', 'Todos', 'Todos');
        System.assertEquals(4, resultado.size());
    }
}
