CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update_film`(
    IN p_film_id INT,
    IN p_title VARCHAR(255),
    IN p_description TEXT,
    IN p_release_year YEAR,
    IN p_language_id INT,
    IN p_rental_duration INT,
    IN p_rental_rate DECIMAL(4,2),
    IN p_length INT,
    IN p_replacement_cost DECIMAL(5,2),
    IN p_rating ENUM('G', 'PG', 'PG-13', 'R', 'NC-17'),
    IN p_special_features TEXT,
    IN p_category_ids VARCHAR(255) 
)
BEGIN
    DECLARE current_category_id INT;
    DECLARE category_pos INT DEFAULT 1;
    DECLARE category_id_str VARCHAR(255);
    DECLARE exit handler for sqlexception
    BEGIN
        -- Manejo del error: realizar un ROLLBACK
        ROLLBACK;
        -- Lanzar un error
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error al actualizar la película';
    END;

    -- Iniciar la transacción
    START TRANSACTION;

    -- Intentar actualizar la película existente
    UPDATE film 
    SET title = p_title,
        description = p_description,
        release_year = p_release_year,
        language_id = p_language_id,
        rental_duration = p_rental_duration,
        rental_rate = p_rental_rate,
        length = p_length,
        replacement_cost = p_replacement_cost,
        rating = p_rating,
        special_features = p_special_features
    WHERE film_id = p_film_id;

    -- Eliminar las relaciones existentes entre la película y las categorías
    DELETE FROM film_category WHERE film_id = p_film_id;

    -- Crear una tabla temporal para almacenar los IDs de las categorías
    CREATE TEMPORARY TABLE temp_category_ids (category_id INT);

    -- Insertar los IDs de las categorías en la tabla temporal
    WHILE category_pos > 0 DO
        SET category_pos = INSTR(p_category_ids, ',');
        IF category_pos > 0 THEN
            SET category_id_str = LEFT(p_category_ids, category_pos - 1);
            SET p_category_ids = SUBSTRING(p_category_ids, category_pos + 1);
        ELSE
            SET category_id_str = p_category_ids;
        END IF;
        SET current_category_id = CAST(category_id_str AS UNSIGNED);
        IF current_category_id IS NOT NULL THEN
            INSERT INTO temp_category_ids (category_id) VALUES (current_category_id);
        END IF;
    END WHILE;

    -- Insertar las relaciones entre la película y las categorías usando la tabla temporal
    INSERT INTO film_category (film_id, category_id)
    SELECT p_film_id, category_id FROM temp_category_ids;

    -- Eliminar la tabla temporal
    DROP TEMPORARY TABLE temp_category_ids;

    -- Finalizar la transacción con éxito
    COMMIT;
END;
