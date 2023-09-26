/*DO $$
DECLARE
--1. declaração do cursor
--esse cursor é unbound por não ser associado a nenhuma query
cur_nomes_youtubers REFCURSOR;
--para armazenar o nome do youtuber a cada iteração
v_youtuber VARCHAR(200);
BEGIN
--2. abertura do cursor
OPEN cur_nomes_youtubers FOR
SELECT youtuber
FROM
tb_top_youtubers;
LOOP
--3. Recuperação dos dados de interesse
FETCH cur_nomes_youtubers INTO v_youtuber;
--FOUND é uma variável especial que indica
EXIT WHEN NOT FOUND;
RAISE NOTICE '%', v_youtuber;
END LOOP;
--4. Fechamento do cursos
CLOSE cur_nomes_youtubers;
END;
$$
*/

/*
--2.6 (Cursor não vinculado (unbound) com query dinâmica: Exibindo os nomes dos
--youtubers que começaram a partir de um ano específico) Vejamos como criar um cursor
--capaz de operar com uma query qualquer, especificada como uma string.

DO $$
DECLARE
cur_nomes_a_partir_de REFCURSOR;
v_youtuber VARCHAR(200);
v_ano INT := 2008;
v_nome_tabela VARCHAR(200) := 'tb_top_youtubers';
BEGIN
OPEN cur_nomes_a_partir_de FOR EXECUTE
format
(
'
SELECT
youtuber
FROM
%s
WHERE started >= $1
'
,
v_nome_tabela
)USING v_ano;
LOOP
FETCH cur_nomes_a_partir_de INTO v_youtuber;
EXIT WHEN NOT FOUND;
RAISE NOTICE '%', v_youtuber;
END LOOP;
CLOSE cur_nomes_a_partir_de;
END;
$$
*/

/*
--7 (Cursor vinculado (bound): Concatenando nome e número de inscritos) Um Cursor é
--vinculado ou bound quando, no momento de sua declaração, já especificamos a query a que
--ficará associado. Neste exemplo, vamos montar uma string contendo os nomes e números
--de inscritos de cada canal. Veja o Bloco de Código 2.7.1.

DO $$
DECLARE
--cursor vinculado (bound)
cur_nomes_e_inscritos CURSOR FOR SELECT youtuber, subscribers FROM
tb_top_youtubers;
--capaz de abrigar uma tupla inteira
--tupla.youtuber nos dá o nome do youtuber
--tupla.subscribers nos dá o número de inscritos
tupla RECORD;
resultado TEXT DEFAULT '';
BEGIN
OPEN cur_nomes_e_inscritos;
FETCH cur_nomes_e_inscritos INTO tupla;
WHILE FOUND LOOP
resultado := resultado || tupla.youtuber || ':' || tupla.subscribers || ',';
FETCH cur_nomes_e_inscritos INTO tupla;
END LOOP;
CLOSE cur_nomes_e_inscritos;
RAISE NOTICE '%', resultado;
END;
$$
*/

/*
--2.8 (Cursor: Parâmetros nomeados e pela ordem) Um cursor pode receber parâmetros. Eles
--podem ser especificados por ordem e também por nome. No Bloco de Código 2.8.1
--exibimos os nomes dos youtubers que começaram a partir de 2010 e que têm, pelo menos,
--60 milhões de inscritos. Ilustramos as duas formas de passagem de parâmetro.
DO $$
DECLARE
v_ano INT := 2010;
v_inscritos INT := 60000000;
cur_ano_inscritos CURSOR (ano INT, inscritos INT) FOR SELECT youtuber FROM
tb_top_youtubers WHERE started >= ano AND subscribers >= inscritos;
v_youtuber VARCHAR(200);
BEGIN
--execute apenas um dos dois comandos OPEN a seguir
-- passando argumentos pela ordem
OPEN cur_ano_inscritos (inscritos := v_inscritos, ano := v_ano);
LOOP
FETCH cur_ano_inscritos INTO v_youtuber;
EXIT WHEN NOT FOUND;
RAISE NOTICE '%', v_youtuber;
END LOOP;
CLOSE cur_ano_inscritos;
END;
$$
*/

/*
--2.9 (Cursor: UPDATE e DELETE) O processamento realizado por meio de um cursor pode
--envolver operações UPDATE e DELETE. No Bloco de Código 2.9.1 ilustramos um cursor em
--que
--- remove todas as duplas em que video_count é desconhido
--- exibe as tuplas remanescentes na tabela, de baixo para cima
DO $$
DECLARE
cur_delete REFCURSOR;
tupla RECORD;
BEGIN
-- scroll para poder voltar ao início
OPEN cur_delete SCROLL FOR
SELECT
*
FROM
tb_top_youtubers;
LOOP
FETCH cur_delete INTO tupla;
EXIT WHEN NOT FOUND;
IF tupla.video_count IS NULL THEN
DELETE FROM tb_top_youtubers WHERE CURRENT OF cur_delete;
END IF;
END LOOP;
-- loop para exibir item a item, de baixo para cima
LOOP
FETCH BACKWARD FROM cur_delete INTO tupla;
EXIT WHEN NOT FOUND;
RAISE NOTICE '%', tupla;
END LOOP;
CLOSE cur_delete;
END;
$$
*/