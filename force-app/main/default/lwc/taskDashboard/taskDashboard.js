import { LightningElement, wire } from 'lwc';
import getTasks from '@salesforce/apex/TaskDashboardController.getTasks';

const COLUNAS = [
    { label: 'Assunto', fieldName: 'Subject' },
    { label: 'Status', fieldName: 'Status' },
    { label: 'Prioridade', fieldName: 'Priority' },
    { label: 'Prazo', fieldName: 'ActivityDate', type: 'date' }
];

export default class TaskDashboard extends LightningElement {
    colunas = COLUNAS;
    statusFiltro = 'Todos';
    prioridadeFiltro = 'Todos';
    prazoFiltro = 'Todos';
    tarefas = [];
    erro;

    opcoesStatus = [
        { label: 'Todos', value: 'Todos' },
        { label: 'Não Iniciada', value: 'Not Started' },
        { label: 'Em Andamento', value: 'In Progress' },
        { label: 'Concluída', value: 'Completed' }
    ];

    opcoesPrioridade = [
        { label: 'Todas', value: 'Todos' },
        { label: 'Alta', value: 'High' },
        { label: 'Normal', value: 'Normal' },
        { label: 'Baixa', value: 'Low' }
    ];

    opcoesPrazo = [
        { label: 'Todos', value: 'Todos' },
        { label: 'Atrasadas', value: 'Atrasadas' },
        { label: 'Hoje', value: 'Hoje' },
        { label: 'Futuras', value: 'Futuras' }
    ];

    @wire(getTasks, {
        statusFiltro: '$statusFiltro',
        prioridadeFiltro: '$prioridadeFiltro',
        prazoFiltro: '$prazoFiltro'
    })
    wiredTasks({ data, error }) {
        if (data) {
            // data vem do Apex em formato ISO (yyyy-MM-dd), comparável como string
            const hoje = new Date().toISOString().slice(0, 10);
            this.tarefas = data.map((tarefa) => ({
                ...tarefa,
                atrasada: tarefa.ActivityDate && tarefa.ActivityDate < hoje && !tarefa.IsClosed
            }));
            this.erro = undefined;
        } else if (error) {
            this.erro = error.body ? error.body.message : error.message;
            this.tarefas = [];
        }
    }

    get temTarefas() {
        return this.tarefas && this.tarefas.length > 0;
    }

    get totalAtrasadas() {
        return this.tarefas.filter((t) => t.atrasada).length;
    }

    get totalEmDia() {
        return this.tarefas.length - this.totalAtrasadas;
    }

    handleStatusChange(event) {
        this.statusFiltro = event.detail.value;
    }

    handlePrioridadeChange(event) {
        this.prioridadeFiltro = event.detail.value;
    }

    handlePrazoChange(event) {
        this.prazoFiltro = event.detail.value;
    }
}
