--1.1 Escreva um cursor que exiba as variáveis rank e youtuber de toda tupla que tiver
--video_count pelo menos igual a 1000 e cuja category seja igual a Sports ou Music.
DO 
$$
DECLARE 
v_youtuber VARCHAR(200);
v_top INT;
cur_vcount_categ CURSOR FOR
SELECT top, youtuber
FROM tb_top_youtubers
WHERE video_count >= 1000
  AND (category = 'Sports ' or category = 'Music ');
BEGIN
-- Abra o cursor
OPEN cur_vcount_categ;
-- Loop para buscar e exibir as tuplas
FETCH NEXT FROM cur_vcount_categ INTO v_top, v_youtuber;
WHILE FOUND
LOOP
    -- Exiba os valores das variáveis rank e youtuber
    RAISE NOTICE 'Rank: %, Youtuber: %', v_top, v_youtuber;

    -- Busque a próxima tupla
    FETCH NEXT FROM cur_vcount_categ INTO v_top, v_youtuber;
END LOOP;

-- Feche o cursor
CLOSE cur_vcount_categ;
END;
$$


--1.2 Escreva um cursor que exibe todos os nomes dos youtubers em ordem reversa. Para tal
---- O SELECT deverá ordenar em ordem não reversa
--- O Cursor deverá ser movido para a última tupla
--- Os dados deverão ser exibidos de baixo para cima
-- Declare o cursor
DO 
$$
DECLARE cursor_reverso CURSOR FOR
SELECT youtuber
FROM tb_top_youtubers
ORDER BY youtuber;

-- Declare uma variável para armazenar o nome do youtuber
youtuber_nome VARCHAR(255);

BEGIN
-- Abra o cursor
OPEN cursor_reverso;

-- Mova o cursor para a última tupla
FETCH LAST FROM cursor_reverso INTO youtuber_nome;

-- Loop para exibir os dados de baixo para cima
WHILE FOUND
LOOP
    -- Exiba o nome do youtuber
    RAISE NOTICE 'Nome do Youtuber: %', youtuber_nome;

    -- Mova o cursor para a tupla anterior
    FETCH PRIOR FROM cursor_reverso INTO youtuber_nome;
END LOOP;

-- Feche o cursor
CLOSE cursor_reverso;
END;
$$
--1.3 Faça uma pesquisa sobre o anti-pattern chamado RBAR - Row By Agonizing Row.
--Explique com suas palavras do que se trata.
/*O RBAR (Row By Agonizing Row) é um anti-pattern na programação e no gerenciamento de bancos de dados. 
Essa abordagem refere-se à prática ineficiente de processar dados de forma individual, linha por linha, 
em vez de aproveitar as capacidades de processamento em lote oferecidas pelo sistema de gerenciamento de banco de dados (DBMS).

Em resumo, o RBAR envolve a iteração sobre cada registro em um conjunto de dados e
aplicação de operações de forma isolada para cada linha. Isso é problemático por várias razões:

Desempenho Ineficiente: Cada operação individual requer comunicação frequente entre o programa e o DBMS, resultando em sobrecarga significativa. Isso pode ser particularmente lento quando se lida com grandes conjuntos de dados.
Bloqueio de Recursos: Processar linha por linha pode resultar em bloqueio de recursos no banco de dados, prejudicando a concorrência e o desempenho geral.
Dificuldade de Manutenção: Código RBAR tende a ser mais complexo, difícil de entender e manter, devido ao número de iterações e à lógica intricada envolvida.

Para evitar o RBAR, é recomendável usar operações em conjunto sempre que possível. 
Isso significa projetar consultas SQL eficientes que realizem operações em lotes de dados, 
aproveitando a capacidade do DBMS de processar várias linhas simultaneamente. 
Isso reduz a sobrecarga de comunicação entre o programa e o banco de dados 
e permite que o DBMS otimize o processamento de dados de maneira mais eficiente.

Em suma, o RBAR é um padrão a ser evitado ao trabalhar com bancos de dados, pois pode levar a problemas de desempenho, bloqueio de recursos e dificuldades de manutenção. Em vez disso, é aconselhável utilizar abordagens que tirem proveito das capacidades de processamento em lote do DBMS para melhorar a eficiência e o desempenho no processamento de dados.
*/
--Exemplo RBAR
-- Declare as variáveis necessárias
-- Declare o cursor
DO
$$
DECLARE cursor_youtubers CURSOR FOR
SELECT cod_top_youtubers, youtuber, subscribers
FROM tb_top_youtubers;

-- Declare variáveis
youtuber_id INT;
youtuber_nome VARCHAR(255);
youtuber_inscritos INT;

-- Abra o cursor
BEGIN
OPEN cursor_youtubers;

-- Loop para processar cada registro
FETCH NEXT FROM cursor_youtubers INTO youtuber_id, youtuber_nome, youtuber_inscritos;
WHILE FOUND
LOOP
    -- Atualize o valor da coluna "inscritos" multiplicando por 1.10
    UPDATE tb_top_youtubers
    SET subscribers = subscribers * 1.10
    WHERE cod_top_youtubers = youtuber_id;

    -- Busque o próximo registro
    FETCH NEXT FROM cursor_youtubers INTO youtuber_id, youtuber_nome, youtuber_inscritos;
END LOOP;

-- Feche o cursor
CLOSE cursor_youtubers;
END;
$$



