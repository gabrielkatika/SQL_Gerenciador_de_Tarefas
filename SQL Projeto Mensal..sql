create database gerenciadortarefa;
use gerenciadortarefa;


-- tabelas do sistema.
create table if not exists usuarios (
    id int auto_increment primary key,
    nome varchar(100) not null,
    email varchar(100) not null,
    senha varchar(100) not null
);

create table if not exists quadros (
    id int auto_increment primary key,
    nome varchar(255) not null,
    descricao text
);

create table if not exists listas (
    id int auto_increment primary key,
    nome varchar(255) not null,
    id_quadro int not null,
    foreign key (id_quadro) references quadros(id) 
);

create table if not exists tarefas (
    id int auto_increment primary key,
    titulo varchar(255) not null,
    descricao text,
    prioridade varchar(20) not null,
    status varchar(20) not null,
    data_criacao date,
    data_conclusao date,
    id_lista int,
    responsavel_id int,
    foreign key (id_lista) references listas(id),
    foreign key (responsavel_id) references usuarios(id)
);

create table if not exists comentarios (
    id int auto_increment primary key,
    texto text,
    data_postagem date,
    id_tarefa int,
    id_usuario int,
    foreign key (id_tarefa) references tarefas(id),
    foreign key (id_usuario) references usuarios(id)
);


-- insert das tabelas, preenchimento de dados.
insert into usuarios (nome, email, senha) values
    ('kaiky', 'kaikyRJ@gmail.com', '0157'),
    ('wlinton', 'pac420@gmail.com', '0420'),
    ('lucas', 'lucas69@gmail.com', '6969'),
    ('gabriel', 'katika@gmail.com', '7777'),
    ('gustavo', 'gu@gmail.com', '0001');

insert into quadros (nome, descricao) values
    ('quadro de tarefas 1', 'quadro principal de gerenciamento de tarefas'),
    ('quadro de tarefas 2', 'quadro secundário de gerenciamento de tarefas');

insert into listas (nome, id_quadro) values
    ('lista de pendentes', 1),
    ('lista de em Andamento', 1),
    ('lista de concluidas', 1),
    ('lista de pendentes', 2),
    ('lista de em andamento', 2);

insert into tarefas (titulo, descricao, prioridade, status, data_criacao, id_lista, responsavel_id) values
    ('tarefa 1', 'descrição da tarefa 1', 'alta', 'concluido', '2024-04-10', 1, 1),
    ('tarefa 2', 'descrição da tarefa 2', 'media', 'concluido', '2024-03-25', 2, 2),
    ('tarefa 3', 'descrição da tarefa 3', 'baixa', 'a fazer ', '2024-02-22', 3, 3),
    ('tarefa 4', 'descrição da tarefa 4', 'media', 'a fazer', '2024-04-17', 4, 4),
    ('tarefa 5', 'descrição da tarefa 5', 'alta', 'em andamento', '2024-04-18', 5, 5);

insert into comentarios (texto, data_postagem, id_tarefa, id_usuario) values
    ('comentario 1', '2024-04-20', 1, 1),
    ('comentario 2', '2024-04-21', 2, 2),
    ('comentario 3', '2024-04-22', 3, 3),
    ('comentario 4', '2024-04-23', 4, 4),
    ('comentario 5', '2024-04-24', 5, 5);
    
    
    
-- select para relaciona as 3 tabelas usuarios, tarefas e comentarios.
SELECT 
    Usuarios.nome AS nome_usuario,
    Tarefas.titulo AS titulo_tarefa,
    Comentarios.texto AS texto_comentario,
    Comentarios.data_postagem AS data_postagem
FROM 
    Comentarios
INNER JOIN 
    Usuarios ON Comentarios.id_usuario = Usuarios.id
INNER JOIN 
    Tarefas ON Comentarios.id_tarefa = Tarefas.id
    
    
-- trigger para que todas as novas tarefas tenham uma data de criação definida.
delimiter //
create trigger before_insert_tarefa before insert on tarefas for each row begin

    if new.data_criacao is null then set new.data_criacao = curdate();
    end if;
end;
//
delimiter ;


-- automação com os 3 select pedidos.
delimiter //
create procedure executar_selecoe()
begin
    select * from tarefas where prioridade = 'alta';
   select * from tarefas where status = 'em andamento';
   select * from tarefas where data_criacao >= date_sub(curdate(), interval 7 day);
end;
//
delimiter ;