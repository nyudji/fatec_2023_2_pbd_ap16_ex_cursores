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


--1.3 Faça uma pesquisa sobre o anti-pattern chamado RBAR - Row By Agonizing Row.
--Explique com suas palavras do que se trata.
