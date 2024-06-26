use  acc;
IF OBJECT_ID('accident_median','U') IS NULL
	BEGIN
	CREATE TABLE accident_median(
	vehicle_type varchar(50),
	accident_median FLOAT 
	)
	END;
DECLARE @vehicle_type VARCHAR(50);

DECLARE cur CURSOR FOR
SELECT vehicle_type 
FROM vehicle_types
WHERE vehicle_type LIKE '%torcycle%';

OPEN cur;
FETCH NEXT FROM cur INTO @vehicle_type;

-- Define loop to look at each row that contains '-torcycle-'
WHILE @@FETCH_STATUS = 0
BEGIN
    DECLARE @accidents TABLE (
        accident_severity INT
    );

    -- Insert accident severity into table variable
    INSERT INTO @accidents (accident_severity)
    SELECT a.accident_severity
    FROM accident a
    JOIN vehicles veh ON veh.accident_index = a.accident_index 
    JOIN vehicle_types vt ON vt.vehicle_code = veh.vehicle_type
    WHERE vt.vehicle_type = @vehicle_type
    ORDER BY a.accident_severity;

    -- Declare variables for median calculation
    DECLARE @median_severity FLOAT;
    DECLARE @count INT;
    DECLARE @quotient INT;
    DECLARE @remainder INT;

    -- Calculate the count of rows
    SELECT @count = COUNT(*) FROM @accidents;

    -- Calculate quotient and remainder
    SELECT @quotient = @count / 2, @remainder = @count % 2;

    IF @remainder = 1 
    BEGIN
        -- Odd number of rows: median is the middle value
        SELECT @median_severity = CAST(accident_severity AS FLOAT)
        FROM @accidents
        ORDER BY accident_severity
        OFFSET @quotient ROWS
        FETCH NEXT 1 ROW ONLY;
    END
    ELSE
    BEGIN
        -- Even number of rows: median is the average of the two middle values
        DECLARE @first_half INT;
        DECLARE @second_half INT;

        SELECT @first_half = CAST(accident_severity AS FLOAT)
        FROM @accidents
        ORDER BY accident_severity
        OFFSET @quotient - 1 ROWS
        FETCH NEXT 1 ROW ONLY;

        SELECT @second_half = CAST(accident_severity AS FLOAT)
        FROM @accidents
        ORDER BY accident_severity
        OFFSET @quotient ROWS
        FETCH NEXT 1 ROW ONLY;

        SET @median_severity = (@first_half + @second_half) / 2.0;
    END;

    -- Insert the calculated median severity into accidents_median
    INSERT INTO accident_median (accident_type, accident_median)
    VALUES (@vehicle_type, @median_severity);

    FETCH NEXT FROM cur INTO @vehicle_type;
END;

-- Close and deallocate the cursor
CLOSE cur;
DEALLOCATE cur;