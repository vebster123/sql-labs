create table clients (name char(20) not NULL, address char(20) not NULL, id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL);

create table accounts_history (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, _from INTEGER, _where INTEGER not NULL, _type char(20) not NULL, _date DATE not NULL, _method char(20) not NULL, _amount INTEGER not NULL);

create table account (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, isAlive boolean NOT NULL, balance INTEGER, open_date DATE NOT NULL, last_modify DATE);

create table bank (client_id INTEGER not NULL, account_id INTEGER not NULL);

/*Триггеры*/
CREATE TRIGGER last_modify_trigger AFTER UPDATE ON account
BEGIN
update account SET last_modify = CURRENT_DATE WHERE account.id = NEW.id;
END;

CREATE TRIGGER last_modify_history_trigger AFTER UPDATE ON accounts_history
BEGIN
update account SET last_modify = CURRENT_TIME WHERE account.id = NEW.id;
END;

CREATE TRIGGER update_balance AFTER INSERT ON accounts_history
BEGIN
update account SET balance = balance + NEW._amount WHERE account.id = NEW._where;
update account SET balance = balance - NEW._amount WHERE account.id = NEW._from;
END;
/*-----------------------------------*/


insert into clients values ("Иван Петрович", "ул. Пушкина, д. 27", NULL);
insert into clients values ("Георгий Николаевич", "ул. Ломоносова, д. 35", NULL);
insert into clients values ("Степан Викторович", "ул. Ленина, д. 33", NULL);


insert into account values (NULL, 1, 300, CURRENT_DATE,NULL);
insert into account values (NULL, 1, 500, DATE(strftime('%s', '2016-10-01 00:00:00') + abs(random() % (strftime('%s', '2016-10-30 23:59:59') - strftime('%s', '2016-10-01 00:00:00'))),'unixepoch'), NULL);
insert into account values (NULL, 1, 10010, DATE(strftime('%s', '2016-10-01 00:00:00') + abs(random() % (strftime('%s', '2016-10-30 23:59:59') - strftime('%s', '2016-10-01 00:00:00'))),'unixepoch'), NULL);
insert into account values (NULL, 1, 5000000, DATE(strftime('%s', '2002-10-01 00:00:00') + abs(random() % (strftime('%s', '2002-10-30 23:59:59') - strftime('%s', '2002-10-01 00:00:00'))),'unixepoch'), NULL);

insert into bank values (1,1);
insert into bank values (1,2);
insert into bank values (3,2);
insert into bank values (2,3);
insert into bank values (3,4);


insert into accounts_history values (null, null, 1, "Пополнение", "2004-02-01", "Онлайн-банк", 10000);
insert into accounts_history values (null, null, 1, "Пополнение", "2004-01-04", "Онлайн-банк", 10000);
insert into accounts_history values (null, null, 2, "Пополнение", "2004-01-01", "Онлайн-банк", 10000);

/*Задачи:*/
SELECT "
----------";
SELECT "Задача 9:
Выведите список номеров счетов, 
суммы на них и даты открытия
1. в порядке возрастания номеров счетов;
2. в порядке убывания сумм наших, 
а в случае одинаковых сумм -  в порядке возрастания номеров.
";
SELECT DISTINCT id, balance, open_date FROM account ORDER BY id;
SELECT "";
SELECT DISTINCT id, balance, open_date FROM account ORDER BY balance DESC, id;
SELECT "
----------";

SELECT "Задача 17:
Выведите список счетов, которые были открыты ранее 2003 года 
и на которых при этом содержится не менее 1000000.
";
SELECT * from account WHERE (open_date < "2003-01-01" AND balance > 1000000);
SELECT "
----------";

SELECT "Задача 18:
Выведите список счетов, которые были открыты, в 2002 году.
";
SELECT * FROM account WHERE (open_date BETWEEN "2002-01-01" AND "2002-12-31");
SELECT "
----------";

SELECT "Задача 21:
С помощью between выберите номера счетов, 
на которых находится сумма от 10000 до 100000.
";
SELECT id FROM account WHERE balance BETWEEN 10000 AND 100000;
SELECT "
----------";

SELECT "Задача 27:
Выберите счета, в номере которых присутствует 
хотя бы одна из цифр: 3, 5, или 9.
";
SELECT id FROM account WHERE id LIKE "%3%" OR id LIKE "%5%" OR id LIKE "%9%";
SELECT "
----------";

SELECT "Задача 51:
Построить запрос, соединяющий таблицы клиентов и счетов.";
select "Клиент:", client_id, " Аккаунт: ", account_id from bank;
SELECT "
----------";

select "Задача 52:
Построить запрос, определяющий количество владельцев каждого счета.";
select "Счет: ", account_id, " Количество владельцев: ",count(account_id) from bank GROUP BY account_id;
SELECT "
----------";

select "Задача 53:
Построить запрос, определяющий для каждого клиента 
количество счетов, владельцем или совладельцем которых он является.";
SELECT "Клиент ", client_id, " имеет счет под номером: ", account_id FROM bank;
SELECT "
----------";

select "Задача 57:
Для каждого счета определить, сколько операций с ним 
было проделано после его открытия 01.01.2004-01.02.2004";
select "Счет под номером: ",_where, " имеет ", count(_where), " операций." from accounts_history GROUP BY _where HAVING _date BETWEEN "2004-01-01" AND "2004-02-01";
SELECT "
----------";

select "Задача 68:
Запишите следующий запрос при помощи подзапросов-сравнений 
и при помощи exists: найдите клиентов, общая сумма на
счетах (с учетом общих с другими клиентами счетов) которых 
является наибольшей.
";
select max(reqsum),client_id from (select sum(balance) as reqsum, client_id from account, bank where exists (select balance from account where balance not NULL) AND account_id==account.id GROUP BY client_id);
SELECT "
----------";

select "Задача 69:
Запишите следующей запрос при помощи подзапросов-сравнений 
и при помощи exists: найдите клиентов, общая сумма на счетах 
(без учета общих с другими клиентами счетов) которых является наибольшей.";
SELECT "
----------";