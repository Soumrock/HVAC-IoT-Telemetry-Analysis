select * from cleaned_telemetry;

select count(*) from cleaned_telemetry;

--the hourly average room temperature
SELECT
    device_id,
    reading_date,
    reading_hour,
    AVG(room_temp_c) AS avg_room_temp
FROM cleaned_telemetry
GROUP BY
    device_id,
    reading_date,
    reading_hour
ORDER BY
    device_id,
    reading_date,
    reading_hour;

--hourly average power
SELECT
    device_id,
    reading_date,
    reading_hour,
    AVG(power_watt) AS avg_power
FROM cleaned_telemetry
GROUP BY
    device_id,
    reading_date,
    reading_hour
ORDER BY
    device_id,
    reading_date,
    reading_hour;

--hourly compressor runtime
SELECT
    device_id,
    reading_date,
    reading_hour,
    SUM(compressor_hours) AS compressor_runtime_hours
FROM cleaned_telemetry
GROUP BY
    device_id,
    reading_date,
    reading_hour
ORDER BY
    device_id,
    reading_date,
    reading_hour;

--daily summary
SELECT
    device_id,
    reading_date,
    AVG(room_temp_c) AS avg_room_temp,
    AVG(power_watt) AS avg_power,
    SUM(compressor_hours) AS compressor_runtime_hours
FROM cleaned_telemetry
GROUP BY
    device_id,
    reading_date
ORDER BY
    device_id,
    reading_date;

--device-level energy usage

SELECT
    device_id,
    SUM(energy_wh) / 1000.0 AS total_energy_kwh
FROM cleaned_telemetry
GROUP BY device_id
ORDER BY total_energy_kwh DESC;

--how often each device misses its setpoint

SELECT
    device_id,
    COUNT(*) AS total_readings,
    SUM(
        CASE
            WHEN ABS(temp_deviation_c) > 1 THEN 1
            ELSE 0
        END
    ) AS setpoint_miss_count,
    100.0 * SUM(
        CASE
            WHEN ABS(temp_deviation_c) > 1 THEN 1
            ELSE 0
        END
    ) / COUNT(*) AS setpoint_miss_percent
FROM cleaned_telemetry
GROUP BY device_id
ORDER BY setpoint_miss_percent DESC;


--abnormal power spikes

SELECT
    device_id,
    timestamp,
    power_watt,
    compressor_state,
    mode
FROM cleaned_telemetry
WHERE power_watt > 2000
ORDER BY power_watt DESC;


--exactly how many of those 15 spikes happened while the device was OFF

SELECT
    COUNT(*) AS off_state_spikes
FROM cleaned_telemetry
WHERE power_watt > 2000
  AND compressor_state = 0;

--offline periods

SELECT
    device_id,
    COUNT(*) AS offline_gap_count
FROM cleaned_telemetry
WHERE offline_flag = 1
GROUP BY device_id
ORDER BY offline_gap_count DESC;

--one combined hourly SQL query

SELECT
    device_id,
    reading_date,
    reading_hour,
    AVG(room_temp_c) AS avg_room_temp,
    AVG(power_watt) AS avg_power,
    SUM(compressor_hours) AS compressor_runtime_hours
FROM cleaned_telemetry
GROUP BY
    device_id,
    reading_date,
    reading_hour
ORDER BY
    device_id,
    reading_date,
    reading_hour;



--device summary

SELECT
    device_id,
    SUM(energy_wh) / 1000.0 AS total_energy_kwh,
    SUM(CASE WHEN ABS(temp_deviation_c) > 1 THEN 1 ELSE 0 END) AS setpoint_miss_count,
    100.0 * SUM(CASE WHEN ABS(temp_deviation_c) > 1 THEN 1 ELSE 0 END) / COUNT(*) AS setpoint_miss_percent
FROM dbo.cleaned_telemetry
GROUP BY device_id
ORDER BY total_energy_kwh DESC;
