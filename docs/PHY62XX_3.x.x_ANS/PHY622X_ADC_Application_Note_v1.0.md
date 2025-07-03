# PHY622X ADC Application Note v1.0 (English Summary)

**Applies to:** PHY6220, PHY6250, PHY6222, PHY6252  
**Date:** 2021.01.25  
**Author:** phyplusinc

---

## 1. Introduction

The ADC (Analog-to-Digital Converter) allows IO pins to be used as analog inputs.  
For QFN32 package, the ADC-capable pins are:

| Pin | Default Mode | Default IN/OUT | ANA |
|-----|--------------|----------------|-----|
| P11 | GPIO         | IN             | √   |
| P14 | GPIO         | IN             | √   |
| P15 | GPIO         | IN             | √   |
| P16 | XTALI(ANA)   | ANA            | √   |
| P17 | XTALO(ANA)   | ANA            | √   |
| P18 | GPIO         | IN             | √   |
| P20 | GPIO         | IN             | √   |
| P23 | GPIO         | IN             | √   |
| P24 | GPIO         | IN             | √   |
| P25 | GPIO         | IN             | √   |

**Table 1: GPIO ANA Pins**

- Only P11~P15, P20~P25 support analog functions.

**Usage:**
- **ADC Sampling:** P11, P14, P15, P18, P20, P23, P24, P25  
  - Single-ended: P11, P14, P15, P20, P23, P24  
  - Differential: P18/P25, P23/P11, P14/P24, P20/P15
- **VOICE Sampling:** P18, P20, P15, P23 (with built-in PGA, supports DMIC and AMIC)

---

## 2. ADC Typical Applications

### 2.1 ADC Overview

- Internal ADC reference voltage: 0.8V
- 12-bit SAR ADC, 8 input channels
- Input types:
  - **PGA:** P18 (PGA+), P20 (PGA-), for AMIC voice
  - **Single-ended:** P11, P14, P15, P20, P23, P24
  - **Differential:** P18/P25, P23/P11, P14/P24, P20/P15

**Modes:**
- **Single-ended:** Measures voltage between pin and GND
- **Differential:** Measures voltage between two pins

**ADC Clock:**
- Derived from HCLK
- If HCLK is 32M or 64M, ADC clock is 1.28MHz; otherwise, 1MHz

**Operation Modes:**
- **Manual:** One channel at a time (single-ended or differential)
- **Auto-scan:** Scans enabled single-ended channels, stores results in memory (SDK uses auto mode)

**Input Range:**
- **Bypass mode:** 0~0.8V (input directly to ADC)
- **Attenuation mode:** 0~3.2V (input divided internally, ~4:1 ratio, resistors 14.15kΩ and 4.72kΩ)

**Precision:**
- **Bypass:** 0.8V/4096 ≈ 0.2mV per LSB
- **Attenuation:** Internal resistor relative error ±1%, absolute error ±15%

**Power Measurement:**  
- Can measure chip supply voltage; keep analog pin isolated.

**Note:**  
- Do not use both internal and external voltage dividers at the same time.

---

### 2.1.1 ADC Hardware Notes

- For voltages <0.8V, use bypass mode; add filter capacitor to input.
- For voltages >0.8V and <3.2V, use attenuation mode or external divider with bypass mode.
- For voltages >3.2V, use external divider with bypass mode; add filter capacitor.
- When using external divider, ensure RC time constant is suitable.

**Bypass mode calculation:**
- Range: 0~0.8V
- VAIO (input to ADC) must be <0.8V

**Voltage divider formula:**
```
VAIO = Vin * (R2 / (R1 + R2))
```
- Choose R1, R2, and C so that:
  - Divider output is <0.8V
  - RC time constant is appropriate for sampling rate

---

### 2.1.2 ADC Software Notes

**6220/6250 Example:**
- Supports bypass ADC and chip supply voltage detection (attenuation)
- Example code for polling ADC values on P11 and P20

```c
void get_battery_voltage(void) {
    int32_t ret;
    adc_handle_t hd;
    adc_status_t adc_status;
    volatile uint32_t adc_data[4] = {0};
    uint32_t ch_adc[] = {ADC_CH1N_P11, ADC_CH3P_P20};
    adc_conf_t adc_config;
    adc_config.mode = ADC_SCAN;
    adc_config.intrp_mode = 0;
    adc_config.channel_array = ch_adc;
    adc_config.channel_nbr = sizeof(ch_adc)/sizeof(ch_adc[0]);
    adc_config.conv_cnt = 10;
    if (adc_config.mode == ADC_SCAN) {
        hd = drv_adc_initialize(0, NULL);
        if (hd == NULL) { printf("err:%d", __LINE__); }
        ret = drv_adc_battery_config(hd, &adc_config, ADC_CH1N_P11);
        if (ret != 0) { printf("err:%d", __LINE__); }
        ret = drv_adc_start(hd);
        if (ret != 0) { printf("err:%d", __LINE__); }
        mdelay(10);
        ret = drv_adc_read(hd, &adc_data[0], sizeof(ch_adc)/sizeof(ch_adc[0]));
        LOGI(TAG, "P11:%dmV P20:%dmV\n", adc_data[0], adc_data[1]);
        ret = drv_adc_stop(hd);
        drv_adc_uninitialize(hd);
    }
}
```

**6222/6252 Example:**
- `adc_Cfg_t` struct configures channel, mode, differential, and resolution
- Supports multiple single-ended channels or one differential channel
- Supports power supply voltage detection

```c
typedef struct _adc_Cfg_t {
    uint8_t channel;
    bool is_continue_mode;
    uint8_t is_differential_mode;
    uint8_t is_high_resolution;
} adc_Cfg_t;
```
- See `example/peripheral/adc` for more details.

---

### 2.1.3 ADC Calibration Principle

- Calibration is not just using fixed sample points, but also compensates for parasitic resistance differences between channels (especially in attenuation mode).
- Attenuation mode: Each channel's parasitic resistance affects the attenuation ratio and thus ADC accuracy.
- The driver should compensate for this using a channel-specific attenuation coefficient (`adc_Lambda`).

**Example attenuation coefficients (6222, single-ended):**

| Channel | Bypass Input 400mV | Attenuation Input 1602mV | Lambda | Vin2/Vout2 |
|---------|--------------------|--------------------------|--------|------------|
| P11     | 2081.5             | 1844.5                   | 4.52   | 0.868      |
| P23     | 2128.5             | 1978.5                   | 4.31   | 0.809      |
| P24     | 2071.5             | 1946                     | 4.26   | 0.823      |
| P14     | 2133.6             | 1906.2                   | 4.48   | 0.840      |
| P15     | 2096.9             | 2008.9                   | 4.18   | 0.797      |
| P20     | 2125               | 2090                     | 4.07   | 0.766      |

**Table 2: ADC Attenuation Coefficient Reference**

---

## 3. Voice Typical Applications

### 3.1 Voice Overview

- Supports DMIC (digital mic, SAR-ADC) and AMIC (analog mic, L+R)
- Sampling rates: 8K, 16K, 32K, 64K (HCLK ≥ 16MHz)
- **DMIC:** External DMIC, flexible pin assignment, PDM sample rate 1.28MHz
- **AMIC:** Internal PGA and ADC, fixed pins: P18 (PGA+), P20 (PGA-), P15 (mic bias), P23 (mic bias ref, optional)

**Voice buffer:**  
- Address: 0x4005800 ~ 0x4005BFF (1024 bytes, 256 words)
- Each word: high 16 bits = left channel, low 16 bits = unused
- Every 128 samples triggers half/full interrupt

---

### 3.1.1 Voice Hardware Notes

- **DMIC:** See reference circuit in original doc
- **AMIC:**  
  - Differential: external dual-ended circuit  
  - Single-ended: P18 to capacitor to GND is required

---

### 3.1.2 Voice Software Notes

- Use `voice_Cfg_t` struct to configure parameters and callback for data processing

```c
typedef struct _voice_Cfg_t {
    bool voiceSelAmicDmic;
    gpio_pin_e dmicDataPin;
    gpio_pin_e dmicClkPin;
    uint8_t amicGain;
    uint8_t voiceGain;
    VOICE_ENCODE_t voiceEncodeMode;
    VOICE_RATE_t voiceRate;
    bool voiceAutoMuteOnOff;
} voice_Cfg_t;
```
- `voiceSelAmicDmic`: Select AMIC or DMIC
- `amicGain`: AMIC PGA gain (two levels)
- `voiceGain`: Voice gain [-20dB, +20dB], step 0.5dB
- `voiceEncodeMode`: Data encoding
- `voiceRate`: Sampling rate
- `voiceAutoMuteOnOff`: Enable/disable auto mute

**Example callback:**
```c
static void voice_evt_handler_adpcm(voice_Evt_t *pev) {
    uint8_t leftbuf[2];
    uint8_t rightbuf[2];
    uint8_t left_right_chanle;
    uint32_t voiceSampleDual;
    int voiceSampleRight;
    int voiceSampleLeft;
    uint32_t i = 0;
    left_right_chanle = SET_LEFT_VOICE;
    if (pev->type == HAL_VOICE_EVT_DATA) {
        for (i = 0; i < pev->size; i++) {
            voiceSampleDual = pev->data[i];
            voiceSampleRight = (int16)(voiceSampleDual & 65535);
            voiceSampleLeft = (int16)((voiceSampleDual >> 16) & 65535);
            if (left_right_chanle == 1) {
                leftbuf[0] = voiceSampleLeft;
                leftbuf[1] = voiceSampleLeft >> 8;
                // FillBuffer(VoiceRaw_FiFO, leftbuf, 2);
                // data process
            } else {
                // rightbuf[0] = voiceSampleRight;
                // rightbuf[1] = voiceSampleRight >> 8;
                // FillBuffer(VoiceRaw_FiFO, rightbuf, 2);
            }
        }
    }
}
```

---

## 4. References

- See original document for diagrams and additional details.
- Example code: `example/peripheral/adc`

---