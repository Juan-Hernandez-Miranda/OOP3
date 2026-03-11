-- Migracion Flyway V2: asegurar que folio sea VARCHAR(6) llenar folios faltantes con ID con ceros a la izquierda y agregar indice unico
-- Agrega columna si falta ajusta longitud de columna llena folios nulos o vacios y crea indice unico
-- Migracion Flyway V2: ajustar longitud de folio a 6 y llenar folios faltantes

-- Si falta la columna (defensivo) agregarla
SET @col_exists = (
  SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'patients' AND COLUMN_NAME = 'folio'
);
SET @sql = IF(@col_exists = 0, 'ALTER TABLE patients ADD COLUMN folio VARCHAR(6) NULL', 'SELECT 1');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Modificar tipo/longitud de columna a VARCHAR(6) (si es necesario)
SET @modify_sql = 'ALTER TABLE patients MODIFY COLUMN folio VARCHAR(6) NULL';
PREPARE stmtm FROM @modify_sql;
EXECUTE stmtm;
DEALLOCATE PREPARE stmtm;

-- Llenar folios faltantes usando id de paciente con ceros a la izquierda (6 digitos)
UPDATE patients
SET folio = LPAD(CAST(id AS CHAR), 6, '0')
WHERE folio IS NULL OR folio = '';

-- Crear indice unico si falta
SET @idx_exists = (
  SELECT COUNT(*) FROM information_schema.STATISTICS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'patients' AND INDEX_NAME = 'idx_patients_folio'
);
SET @sql2 = IF(@idx_exists = 0, 'CREATE UNIQUE INDEX idx_patients_folio ON patients(folio)', 'SELECT 1');
PREPARE stmt2 FROM @sql2;
EXECUTE stmt2;
DEALLOCATE PREPARE stmt2;
