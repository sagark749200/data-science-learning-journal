-------------------------------
-- SQL Data Cleaning session---
-------------------------------


SELECT * FROM sql_cx_live.laptops;
use sql_cx_live;

-- count total rows available
SELECT count(*) FROM laptops;

-- create a backup for future reference
CREATE TABLE laptops_backup LIKE laptops;
INSERT INTO laptops_backup
SELECT * FROM laptops;


-- check dataset size , also will check size after some cleaning and modification
SELECT DATA_LENGTH/1024 FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'sql_cx_live'
AND TABLE_NAME = 'laptops';


-- drop the unwanted column (unnamed) -- used tilted commas for column
ALTER TABLE laptops DROP COLUMN `Unnamed: 0`;
-- check
select * from laptops;


-- delete an entire null row   (below query gives an error)
-- MySQL does not allow modifying a table and reading from it in a subquery at the same time.
DELETE FROM laptops 
WHERE `index` IN (SELECT `index` FROM laptops
WHERE Company IS NULL AND TypeName IS NULL AND Inches IS NULL
AND ScreenResolution IS NULL AND Cpu IS NULL AND Ram IS NULL
AND Memory IS NULL AND Gpu IS NULL AND OpSys IS NULL AND
WEIGHT IS NULL AND Price IS NULL);


-- this will work
DELETE FROM laptops
WHERE Company IS NULL
  AND TypeName IS NULL
  AND Inches IS NULL
  AND ScreenResolution IS NULL
  AND Cpu IS NULL
  AND Ram IS NULL
  AND Memory IS NULL
  AND Gpu IS NULL
  AND OpSys IS NULL
  AND Weight IS NULL
  AND Price IS NULL;


-- check wheather null rows availabe or not (no in our case , already removed)
SELECT * FROM laptops
WHERE Company IS NULL AND TypeName IS NULL AND Inches IS NULL
AND ScreenResolution IS NULL AND Cpu IS NULL AND Ram IS NULL
AND Memory IS NULL AND Gpu IS NULL AND OpSys IS NULL AND
WEIGHT IS NULL AND Price IS NULL;



-- change column data type (inches tezt-decimal)
ALTER TABLE laptops MODIFY COLUMN Inches DECIMAL(10,1);


-- remove GB from rant column and chnage its data type 
UPDATE laptops
SET Ram = REPLACE(Ram, 'GB', '');
-- check
SELECT * FROM laptops;
-- change dtype
ALTER TABLE laptops MODIFY COLUMN Ram INTEGER;

-- check size 
SELECT DATA_LENGTH/1024 FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'sql_cx_live'
AND TABLE_NAME = 'laptops';


-- remove kg from weight column
UPDATE laptops l1
SET Weight = REPLACE(Weight, 'kg', '');

-- check           
SELECT * FROM laptops;

-- round price column and change dtype in INT
UPDATE laptops l1
SET Price = ROUND(Price);
select * from laptops;
-- categorize Opsys column
SELECT DISTINCT OpSys FROM laptops;

SELECT OpSys,
CASE 
	WHEN OpSys LIKE '%mac%' THEN 'macos'
    WHEN OpSys LIKE 'windows%' THEN 'windows'
    WHEN OpSys LIKE '%linux%' THEN 'linux'
    WHEN OpSys = 'No OS' THEN 'N/A'
    ELSE 'other'
END AS 'os_brand'
FROM laptops;

UPDATE laptops
SET OpSys = 
CASE 
	WHEN OpSys LIKE '%mac%' THEN 'macos'
    WHEN OpSys LIKE 'windows%' THEN 'windows'
    WHEN OpSys LIKE '%linux%' THEN 'linux'
    WHEN OpSys = 'No OS' THEN 'N/A'
    ELSE 'other'
END;

-- check
SELECT * FROM laptops;

-- categorize gpy col into 2 new column gpu_brand, gpu_name and then delete the old gpu col
ALTER TABLE laptops
ADD COLUMN gpu_brand VARCHAR(255) AFTER Gpu,
ADD COLUMN gpu_name VARCHAR(255) AFTER gpu_brand;

SELECT * FROM laptops;

UPDATE laptops l1
SET gpu_brand = SUBSTRING_INDEX(Gpu, ' ', 1);

UPDATE laptops l1
SET gpu_name =REPLACE(Gpu, gpu_brand, '');

SELECT * FROM laptops;

ALTER TABLE laptops DROP COLUMN Gpu;
SELECT * FROM laptops;


-- similarly categorized cpu into name, brand, speed and then delete the old cpu column
ALTER TABLE laptops
ADD COLUMN cpu_brand VARCHAR(255) AFTER Cpu,
ADD COLUMN cpu_name VARCHAR(255) AFTER cpu_brand,
ADD COLUMN cpu_speed DECIMAL(10,1) AFTER cpu_name;

SELECT * FROM laptops;
UPDATE laptops
SET cpu_brand = SUBSTRING_INDEX(Cpu, ' ', 1);

UPDATE laptops
SET cpu_speed = CAST(
                    REPLACE(SUBSTRING_INDEX(Cpu, ' ', -1),'GHz','') AS DECIMAL(10,2));

UPDATE laptops
SET cpu_name = TRIM(
                    REPLACE(REPLACE(Cpu, cpu_brand, ''),SUBSTRING_INDEX(REPLACE(Cpu, cpu_brand, ''), ' ', -1),''));

SELECT * FROM laptops;

ALTER TABLE laptops DROP COLUMN Cpu;



-- made new columns for resolution width and height from ScreenResolution column and then delete the old column
SELECT ScreenResolution,
SUBSTRING_INDEX(SUBSTRING_INDEX(ScreenResolution,' ',-1),'x',1),
SUBSTRING_INDEX(SUBSTRING_INDEX(ScreenResolution,' ',-1),'x',-1)
FROM laptops;

ALTER TABLE laptops 
ADD COLUMN resolution_width INTEGER AFTER ScreenResolution,
ADD COLUMN resolution_height INTEGER AFTER resolution_width;

UPDATE laptops
SET resolution_width = SUBSTRING_INDEX(SUBSTRING_INDEX(ScreenResolution,' ',-1),'x',1),
resolution_height = SUBSTRING_INDEX(SUBSTRING_INDEX(ScreenResolution,' ',-1),'x',-1);

-- made new column touchscreen to indicate whether the laptop is touchscreen or not
ALTER TABLE laptops 
ADD COLUMN touchscreen INTEGER AFTER resolution_height;

SELECT ScreenResolution LIKE '%Touch%' FROM laptops;

UPDATE laptops
SET touchscreen = ScreenResolution LIKE '%Touch%';

SELECT * FROM laptops;


-- drop the old ScreenResolution column
ALTER TABLE laptops
DROP COLUMN ScreenResolution;

SELECT * FROM laptops;


-- clean the cpu_name column to keep only first two words
SELECT cpu_name,
SUBSTRING_INDEX(TRIM(cpu_name),' ',2)
FROM laptops;

UPDATE laptops
SET cpu_name = SUBSTRING_INDEX(TRIM(cpu_name),' ',2);

SELECT DISTINCT cpu_name FROM laptops;
SELECT Memory FROM laptops;


-- categorize memory column into memory_type, primary_storage, secondary_storage
ALTER TABLE laptops
ADD COLUMN memory_type VARCHAR(255) AFTER Memory,
ADD COLUMN primary_storage INTEGER AFTER memory_type,
ADD COLUMN secondary_storage INTEGER AFTER primary_storage;

SELECT Memory,
CASE
	WHEN Memory LIKE '%SSD%' AND Memory LIKE '%HDD%' THEN 'Hybrid'
    WHEN Memory LIKE '%SSD%' THEN 'SSD'
    WHEN Memory LIKE '%HDD%' THEN 'HDD'
    WHEN Memory LIKE '%Flash Storage%' THEN 'Flash Storage'
    WHEN Memory LIKE '%Hybrid%' THEN 'Hybrid'
    WHEN Memory LIKE '%Flash Storage%' AND Memory LIKE '%HDD%' THEN 'Hybrid'
    ELSE NULL
END AS 'memory_type'
FROM laptops;

UPDATE laptops
SET memory_type = CASE
	WHEN Memory LIKE '%SSD%' AND Memory LIKE '%HDD%' THEN 'Hybrid'
    WHEN Memory LIKE '%SSD%' THEN 'SSD'
    WHEN Memory LIKE '%HDD%' THEN 'HDD'
    WHEN Memory LIKE '%Flash Storage%' THEN 'Flash Storage'
    WHEN Memory LIKE '%Hybrid%' THEN 'Hybrid'
    WHEN Memory LIKE '%Flash Storage%' AND Memory LIKE '%HDD%' THEN 'Hybrid'
    ELSE NULL
END;

--use REGEXP_SUBSTR to extract storage values only
SELECT Memory,
REGEXP_SUBSTR(SUBSTRING_INDEX(Memory,'+',1),'[0-9]+'),
CASE WHEN Memory LIKE '%+%' THEN REGEXP_SUBSTR(SUBSTRING_INDEX(Memory,'+',-1),'[0-9]+') ELSE 0 END
FROM laptops;

UPDATE laptops
SET primary_storage = REGEXP_SUBSTR(SUBSTRING_INDEX(Memory,'+',1),'[0-9]+'),
secondary_storage = CASE WHEN Memory LIKE '%+%' THEN REGEXP_SUBSTR(SUBSTRING_INDEX(Memory,'+',-1),'[0-9]+') ELSE 0 END;

-- update storage values to be in GB (1 TB = 1024 GB)
SELECT 
primary_storage,
CASE WHEN primary_storage <= 2 THEN primary_storage*1024 ELSE primary_storage END,
secondary_storage,
CASE WHEN secondary_storage <= 2 THEN secondary_storage*1024 ELSE secondary_storage END
FROM laptops;

UPDATE laptops
SET primary_storage = CASE WHEN primary_storage <= 2 THEN primary_storage*1024 ELSE primary_storage END,
secondary_storage = CASE WHEN secondary_storage <= 2 THEN secondary_storage*1024 ELSE secondary_storage END;

SELECT * FROM laptops;

-- drop the old Memory column
ALTER TABLE laptops DROP COLUMN gpu_name;

SELECT * FROM laptops;
