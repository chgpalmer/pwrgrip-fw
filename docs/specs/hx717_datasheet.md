# HX717: Dual-Channel High-Precision 24-bit ADC

## Overview

The HX717, developed by AVIA Semiconductor, is a 24-bit analog-to-digital converter (ADC) chip designed for high-precision electronic scales. Compared to similar chips, it integrates a voltage regulator, on-chip clock oscillator, and other peripheral circuits, resulting in high integration, fast response, and strong anti-interference. This reduces system cost and improves performance and reliability.

## Features

- Two selectable differential input channels
- Simple MCU interface: all control signals are pin-driven, no internal register programming required
- Input multiplexer allows selection of Channel A or B, each connected to a low-noise programmable gain amplifier (PGA)
    - Channel A PGA gain: 128 or 64
    - Channel B PGA gain: 64 or 8
- On-chip voltage regulator can directly power external sensors
- On-chip clock oscillator (no external components needed, but external clock optional)
- Low-noise PGA with selectable gains: 8, 64, 128
- Selectable output data rates: 10, 20, 80, or 320 Hz
- Suppresses 50Hz and 60Hz power line interference
- Typical operating current: 1.5mA (including regulator); shutdown current: <1μA
- Operating voltage: 2.7V ~ 5.5V
- Operating temperature: -40°C ~ +85°C
- SOP-16 package

## Block Diagram

<pre>
Load cell
  |
INA+  INB+
INA-  INB-
  |    |
  +----+----> Input MUX --> PGA (Gain 8/64/128) --> 24-bit Sigma-Delta ADC --> Digital Interface (DOUT, PD_SCK)
  |
On-chip Regulator (AVDD, VRO/VREF)
On-chip Oscillator (XI)
</pre>

## Pinout (SOP-16)

| Pin | Name      | Type        | Description                                      |
|-----|-----------|-------------|--------------------------------------------------|
| 1   | AVDD      | Power       | Analog power input (2.7V ~ 5.5V)                 |
| 2   | AGND      | Ground      | Analog ground                                    |
| 3   | VRO/VREF  | Power/Ref   | Regulator output & ADC reference input (1.8V~AVDD)|
| 4   | VFB       | Analog In   | Feedback for regulator                           |
| 5   | AGND      | Ground      | Analog ground                                    |
| 6   | S0        | Digital In  | Output data rate control 0                       |
| 7   | INNA      | Analog In   | Channel A negative input                         |
| 8   | INPA      | Analog In   | Channel A positive input                         |
| 9   | INNB      | Analog In   | Channel B negative input                         |
| 10  | INPB      | Analog In   | Channel B positive input                         |
| 11  | PD_SCK    | Digital In  | Power down control (active high) & serial clock  |
| 12  | DOUT      | Digital Out | Serial data output                               |
| 13  | S1        | Digital In  | Output data rate control 1                       |
| 14  | XI        | Digital In  | External clock input (0 = use internal oscillator)|
| 15  | DGND      | Ground      | Digital ground                                   |
| 16  | DVDD      | Power       | Digital power input (2.7V ~ 5.5V, ≤ AVDD)        |

## Electrical Characteristics (Typical, unless noted)

- **Full-scale differential input range:** ±0.5 × (VREF / Gain)
- **Input common-mode voltage:** 0.9V to AVDD-1.5V
- **VREF input range:** 1.8V to AVDD
- **Resolution:** 24 bits (no missing codes)
- **Noise-free bits:** 18.2 (10Hz), 17.7 (20Hz), 16.7 (80Hz), 15.8 (320Hz)
- **Output data rates:** 10/20/80/320 Hz (selectable)
- **Power supply:** 2.7V to 5.5V
- **Operating current:** 1.5mA (typical)
- **Shutdown current:** <1μA

## Channel and Gain Selection

- Channel and gain are selected by the number of PD_SCK pulses after DOUT goes low:
    - 25 pulses: Channel A, Gain 128
    - 26 pulses: Channel B, Gain 64
    - 27 pulses: Channel A, Gain 64
    - 28 pulses: Channel B, Gain 8

## Power Supply and Reference

- AVDD and DVDD: 2.7V ~ 5.5V (DVDD ≤ AVDD)
- VRO/VREF: Connect to sensor supply and ADC reference
- On-chip regulator output (VRO) is set by external resistors:  
  VRO = 1.11 × (R1 + R2) / R2 (should be at least 200mV below AVDD)

## Serial Interface

- **PD_SCK:** Serial clock and power-down control
- **DOUT:** Serial data output
- When DOUT goes low, 24 PD_SCK pulses read the data; 25–28 pulses select channel/gain for next conversion.

## Power Down

- To power down: After DOUT goes low, send 30 PD_SCK pulses, then hold PD_SCK high for >80μs.
- To wake: Bring PD_SCK low.

## Reference Circuit

- Typical application:  
  VDD = 5.0V, ODR = 10Hz (S1=0, S0=0), VRO = 4.44V (R1=30kΩ, R2=10kΩ)

## Example C Driver (Pseudo-code)

<pre>
ulong HX717_Read(void) {
    uchar i;
    ulong bcd = 0;
    PD_SCK = 0;
    while (DOUT == 1);
    // Delay >1us
    for (i = 0; i < 24; i++) {
        PD_SCK = 1;
        // High time <50us
        PD_SCK = 0;
        bcd = bcd << 1;
        if (DOUT == 1) bcd++;
    }
    PD_SCK = 1;
    PD_SCK = 0;
    bcd = bcd ^ 0x800000; // Convert signed to unsigned
    return bcd;
}
</pre>

## Package

- SOP-16L
- Dimensions: 9.9 × 6.0 × 1.27 mm (see datasheet for full mechanical drawing)

## Application Notes

- On MCU power-up, initialize ADC by pulling PD_SCK high for >100μs, then low.
- PD_SCK can be push-pull; 1μs high/low times recommended for noise immunity.
- If DOUT stays high too long, reset ADC by pulling PD_SCK high >100μs, then low.
- After reset or power-up, first valid data is available after 4 output cycles.

## References

- [AVIA SEMICONDUCTOR](http://www.aviaic.com)
- Email: sales@aviaic.com
- Tel: (592) 252-9530 (China)

*Information is for design reference only and subject to change without notice.*