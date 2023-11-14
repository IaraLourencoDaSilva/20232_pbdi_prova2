--Prova 2

--5Trigger--
CREATE TRIGGER tg_antes_delete
BEFORE DELETE ON tb_log
FOR EACH ROW
EXECUTE FUNCTION fn_delete_youtuber();

CREATE OR REPLACE FUNCTION fn_delete_youtuber()
RETURNS TRIGGER
LANGUAGE plpgsql AS $$
BEGIN
    IF OLD.ativo = 1 THEN
        INSERT INTO tb_youtube_logs (cod_youtuber, nome_youtuber, categoria_canal, ano_inicio, ativo)
        VALUES (OLD.cod_youtuber, OLD.nome_youtuber, OLD.categoria_canal, OLD.ano_inicio, 0);
		
        UPDATE youtuber SET ativo = 0 WHERE cod_youtuber = OLD.cod_youtuber;
        RAISE EXCEPTION 'Operação DELETE não permitida. Registro ativo registrado na tabela de logs.';
    ELSE
        RETURN OLD;
    END IF;
END;
$$;

--Testando
SELECT * FROM tb_log;

--4 Tabeladelog--
CREATE TABLE tb_log(
	cod_youtuber SERIAL PRIMARY KEY,
	nome_youtuber VARCHAR(30),
	categoria_canal VARCHAR (30),
	ano_inicio INT
);

--3 Altertable--
ALTER TABLE tb_youtube ADD COLUMN ativo INT DEFAULT 1 CHECK (ativo IN (0, 1));

--2 Trigger--
CREATE OR REPLACE TRIGGER tg_antes_insert_update
BEFORE INSERT OR UPDATE ON tb_youtube
FOR EACH ROW
EXECUTE PROCEDURE fn_antes_insert_update('Antes: V1', 'Antes: V2');

CREATE OR REPLACE FUNCTION fn_antes_insert_update()
RETURNS TRIGGER
LANGUAGE plpgsql AS $$
BEGIN
	IF NEW.subscribers >= 0 AND NEW.video_views >= 0 AND NEW.video_count >= 0 THEN
        RETURN NEW;
    ELSE
        RAISE EXCEPTION 'Valores numéricos inválidos: subscribers=%, video_views=%, video_count=%',
                        NEW.subscribers, NEW.video_views, NEW.video_count;
        RETURN NULL;
    END IF;
END;
$$


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