# Berryboard

A Raspberry Pi HAT+ for ROV (remotely operated vehicle) control, with an RP2350B co-processor for hard real-time servo and sensor management.

## Overview

Berryboard sits on top of a Raspberry Pi 4 or 5 and handles the latency-sensitive workload that the Linux kernel can't guarantee: PWM servo output, sensor polling, and leak detection. The RPi handles high-level control logic over UART; the RP2350B handles everything that needs deterministic timing.

```
┌─────────────────────────────────────────────┐
│                  Raspberry Pi               │
│                  (host computer)            │
└──────────────┬──────────────────────────────┘
               │ 40-pin HAT header
┌──────────────▼──────────────────────────────┐
│                  Berryboard                  │
│                                             │
│  RP2350B ────── 8× servo outputs (PWM)      │
│           ────── IMU (ICM-42688-P, SPI)     │
│           ────── Magnetometer (MMC5983MA)   │
│           ────── 2× leak sensors (ADC)      │
│           ────── Servo power monitor (ADC)  │
│                                             │
│  TPS2121 power mux                          │
│    IN1: XT30 external servo power           │
│    IN2: RPi 5V from header                  │
│    OUT: 5V system rail                      │
│                                             │
│  6× QWIIC connectors                        │
│    3× on RPi I2C1 (GPIO2/3 on header)       │
│    3× on RP2350B I2C                        │
└─────────────────────────────────────────────┘
```

## Hardware Features

| Feature | Detail |
|---------|--------|
| Form factor | 65 × 56 mm RPi HAT+ |
| Co-processor | RP2350B (dual Arm Cortex-M33 / RISC-V, 520 KB SRAM) |
| Flash | W25Q16JVSS 2 MB QSPI (RP2350B) |
| EEPROM | 24LC32 (HAT ID, I2C0) |
| Servo outputs | 8 channels — 3× 1×8 Dupont block (signal / power / GND) |
| Servo power | XT30 connector, monitored via ADC |
| IMU | ICM-42688-P 6-axis (accel + gyro), SPI to RPi |
| Magnetometer | MMC5983MA 3-axis, I2C to RPi |
| QWIIC | 6× JST-SH 1 mm (3 RPi + 3 MCU) |
| Leak detection | 2× probes → RP2350B ADC |
| Status LED | WS2812B RGB (RP2350B GPIO12) |
| USB-C | USB 2.0 to RP2350B (programming / debug edge connector) |
| SWD | 4-pin header (J21) |
| Host link | UART (GPIO14/15 on 40-pin header); optional USB-C |
| Power | 5V from XT30 or RPi header, muxed by TPS2121 |
| 3.3V | AP2112K LDO from 5V system rail |

## Servo Connector

The 8 servo channels use three color-coded 1×8 Dupont headers placed side-by-side:

```
Pin:     1    2    3    4    5    6    7    8
         ┌────┬────┬────┬────┬────┬────┬────┐
Yellow   │ S0 │ S1 │ S2 │ S3 │ S4 │ S5 │ S6 │ S7 │  Signal
         ├────┼────┼────┼────┼────┼────┼────┤────┤
Red      │+V  │+V  │+V  │+V  │+V  │+V  │+V  │+V  │  SERVO_PWR
         ├────┼────┼────┼────┼────┼────┼────┤────┤
Black    │GND │GND │GND │GND │GND │GND │GND │GND │  GND
         └────┴────┴────┴────┴────┴────┴────┘────┘
```

Pin 1 = servo channel 1 (SERVO_0 net). Plug a standard 3-pin servo Dupont connector into any column.

## Repository Contents

| File | Description |
|------|-------------|
| `berryboard.kicad_sch` | Schematic |
| `berryboard.kicad_pcb` | PCB layout |
| `berryboard-custom.kicad_sym` | Custom KiCad symbols (TPS2121, ICM-42688-P, MMC5983MA) |
| `sym-lib-table` | KiCad symbol library table |

## Status

- [x] Schematic complete (0 ERC errors)
- [x] Footprints assigned
- [ ] PCB layout and routing
- [ ] Design rule check
- [ ] BOM verification (JLCPCB availability)
- [ ] Bring-up and testing

## Tools

Designed with [KiCad](https://www.kicad.org/) 9.x.

## License

Hardware design files are released under [CERN Open Hardware Licence Version 2 – Permissive (CERN-OHL-P)](https://ohwr.org/cern_ohl_p_v2.txt).
