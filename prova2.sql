--Prova 2

--testando
SELECT * FROM tb_youtube
-- Criando tabela 
CREATE TABLE tb_youtube(
	cod_youtube SERIAL PRIMARY KEY,
	rank INT,
	youtuber VARCHAR(200),
	subcribers INT,
	video_views BIGINT,
	video_count INT,
	category VARCHAR(30),
	started INT
);