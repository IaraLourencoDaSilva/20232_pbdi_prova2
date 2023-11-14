--Prova 2
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