# HVAC IoT Telemetry Analysis

An end-to-end analysis of HVAC IoT telemetry data using Python and SQL to evaluate data quality, time-series behaviour, energy usage, and operational anomalies.

## Project Overview

This project analyzes approximately two weeks of telemetry data collected from five HVAC devices.

The analysis focuses on:

- Data cleaning and quality validation
- Time-series analysis at regular 15-minute intervals
- Device-level hourly and daily summaries
- Offline and telemetry-gap detection
- Temperature setpoint deviation analysis
- Flatline/stuck sensor detection
- High-power anomaly detection
- Estimated energy consumption
- Business-oriented operational insights

## Dataset

The dataset contains HVAC device telemetry recorded at approximately 15-minute intervals.

### Columns

| Column | Description |
|---|---|
| `device_id` | Unique HVAC device identifier |
| `timestamp` | Telemetry reading timestamp |
| `room_temp_c` | Measured room temperature |
| `setpoint_c` | Target temperature |
| `ambient_temp_c` | Ambient/outside temperature |
| `compressor_state` | Compressor state: ON/OFF |
| `power_watt` | Instantaneous power draw in watts |
| `mode` | HVAC operating mode |

The dataset intentionally contains imperfect telemetry, including duplicate readings, missing intervals, abnormal sensor values, offline periods, and sensor behaviour that may require investigation.

## Tools & Technologies

- Python
- Pandas
- NumPy
- Matplotlib
- Seaborn
- Plotly
- SQL

## Analysis Workflow

### 1. Data Preparation

The telemetry data was inspected and cleaned before analysis.

Key data-quality steps included:

- Timestamp parsing
- Duplicate-row removal
- Identification of implausible room-temperature readings
- Alignment of devices to a regular 15-minute interval
- Detection and flagging of missing telemetry intervals

### 2. Time-Series Analysis

Hourly and daily summaries were used to analyze:

- Average room temperature
- Average power consumption
- Compressor runtime
- Device-level operating patterns
- Daily power-usage patterns

### 3. Anomaly Detection

The analysis identifies several types of operational anomalies:

- Offline or telemetry-gap events
- Persistent flatline temperature behaviour
- Temperature deviations from setpoint
- High-power readings
- High-power readings occurring while the compressor is reported OFF

### 4. Energy Analysis

Approximate energy consumption was estimated from telemetry power readings using the 15-minute sampling interval.

## Data Quality Findings

The analysis identified:

- **32 duplicate rows** removed
- **25 implausible room-temperature readings** converted to missing values
- **282 missing 15-minute intervals** created during time-series alignment
- **136 offline/gap events** detected from the original telemetry intervals

## Key Findings

- **DVC-101** recorded the highest estimated energy consumption at approximately **179.57 kWh**.
- **DVC-104** recorded a setpoint miss rate of approximately **25.3%**, compared with approximately 7–9% for the other devices.
- **DVC-104** showed prolonged room-temperature readings around **23.5°C**, indicating potentially stuck or faulty sensor behaviour.
- **DVC-101** recorded **15 power readings above 2000 W**; 11 of these occurred while the compressor was reported OFF and were flagged for further investigation.
- Power consumption showed a recurring daily pattern, with higher usage during operating periods and lower usage overnight.

## Operational Recommendations

Based on the analysis:

- Investigate DVC-104's temperature-control behaviour and persistent flatline readings.
- Investigate DVC-101's high-power readings, particularly cases where the compressor is reported OFF.
- Monitor devices with repeated telemetry gaps, including DVC-102, DVC-103 and DVC-104.
- Use the observed daily power pattern to focus energy-efficiency monitoring during higher-usage periods.

## Repository Structure

```text
HVAC-IoT-Telemetry-Analysis/
│
├── data/
│   └── raw/
│       └── device_telemetry.csv
│
├── notebooks/
│   └── HVAC_Telemetry_Analysis.ipynb
│
├── sql/
│   └── HVAC_Telemetry_Analysis.sql
│
├── reports/
│   └── HVAC_Telemetry_Analysis_Report.html
│
├── requirements.txt
│
└── README.md
