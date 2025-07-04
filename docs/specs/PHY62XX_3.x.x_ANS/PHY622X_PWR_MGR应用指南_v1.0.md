# PHY622X Power Manager (PWR_MGR) Application Note v1.0 (English Summary)

**Version:** 1.0  
**Author:** Bingliang Lou, Zhongqi Yang  
**Date:** 2021.03  
**Applies to:** PHY622X series  
**Original Language:** Chinese

---

## Revision History

| Version | Author(s)           | Date       | Description         |
|---------|---------------------|------------|---------------------|
| v0.1    | Bingliang Lou       | 2020.12.09 | Draft               |
| v1.0    | Bingliang Lou, Zhongqi Yang | 2021.03.17 | First Edition      |

---

## Table of Contents

1. Overview  
2. PWR_MGR Module API  
3. Low Power Mode Usage Notes  
4. Power Consumption Evaluation and Measured Data  

---

## 1. Overview

The PHY622X low power features are implemented in the PWR_MGR module.  
API code is located in the SDK at `components/driver/pwrmgr/pwrmgr.c` and `pwrmgr.h`.

PHY622X supports four power modes:
- **Normal Mode:** CPU and peripherals run at full speed, no sleep.
- **CPU Sleep Mode:** Only the CPU sleeps, can be woken by interrupt or event. Controlled by OS, no app intervention needed.
- **Deep Sleep Mode:** CPU and most peripherals sleep. App should set wakeup sources (GPIO pin and trigger type) and memory retention as needed.
- **Standby Mode:** Only AON and one RAM region are retained, CPU and other peripherals sleep. Only RAM0 is retained. App should set wakeup sources.
- **Shutdown Mode:** Only AON is retained, CPU and peripherals sleep. Wakeup is equivalent to system reboot, runtime context is not retained. App should set wakeup sources.

### 1.1 PWR_MGR Block Diagrams

- **Deep Sleep Mode:**  
  When the system is idle, `sleep_process()` is called to attempt sleep. If CPU sleep conditions are met, `__WFI()` is called to wait for interrupt. Otherwise, the system enters deep sleep. Before sleeping, all registered `sleep_handler()` callbacks are called. On wakeup (e.g., IO/RTC), all registered `wakeup_handler()` callbacks are called, then OSAL schedules tasks.

- **Standby Mode:**  
  The app calls `hal_pwrmgr_enter_standby()` to enter standby. On IO wakeup, `wakeupProcess_standby()` is called. If wakeup conditions are met, a system reset is triggered.

---

## 2. PWR_MGR Module API

### 2.1 Data Structures and Types

#### 2.1.1 MODULE_e Type

Module IDs defined in `mcu_phy_bumbee.h`:
```c
typedef enum {
    MOD_NONE = 0, MOD_CK802_CPU = 0,
    MOD_DMA = 3,
    MOD_AES = 4,
    MOD_IOMUX = 7,
    MOD_UART0 = 8,
    MOD_I2C0 = 9,
    MOD_I2C1 = 10,
    MOD_SPI0 = 11,
    MOD_SPI1 = 12,
    MOD_GPIO = 13,
    MOD_QDEC = 15,
    MOD_ADCC = 17,
    MOD_PWM = 18,
    MOD_SPIF = 19,
    MOD_VOC = 20,
    MOD_TIMER5 = 21,
    MOD_TIMER6 = 22,
    MOD_UART1 = 25,
    // ... and more, including user modules MOD_USR0 ~ MOD_USR8
} MODULE_e;
```

#### 2.1.2 pwrmgr_Ctx_t

Each registered module (corresponding to MODULE_e) has a context variable:
```c
typedef struct _pwrmgr_Context_t {
    MODULE_e moudle_id;
    bool lock; // TRUE: sleep forbidden; FALSE: sleep allowed
    pwrmgr_Hdl_t sleep_handler;   // Called before sleep
    pwrmgr_Hdl_t wakeup_handler;  // Called after wakeup
} pwrmgr_Ctx_t;
```

#### 2.1.3 pwroff_cfg_t

Used to set wakeup sources (GPIO pin and trigger type) before entering shutdown mode:
```c
typedef struct {
    gpio_pin_e pin;
    gpio_polarity_e type; // POL_FALLING or POL_RISING
} pwroff_cfg_t;
```

### 2.2 APIs

- `int hal_pwrmgr_init(void);`  
  Initialize the module.

- `bool hal_pwrmgr_is_lock(MODULE_e mod);`  
  Query lock status for module.

- `int hal_pwrmgr_lock(MODULE_e mod);`  
  Set lock TRUE, forbid sleep.

- `int hal_pwrmgr_unlock(MODULE_e mod);`  
  Set lock FALSE, allow sleep.

- `int hal_pwrmgr_register(MODULE_e mod, pwrmgr_Hdl_t sleepHandle, pwrmgr_Hdl_t wakeupHandle);`  
  Register sleep/wakeup callbacks for module.

- `int hal_pwrmgr_unregister(MODULE_e mod);`  
  Unregister module.

- `int hal_pwrmgr_wakeup_process(void) __attribute__((weak));`  
  - Internal, do not call directly.

- `int hal_pwrmgr_sleep_process(void) __attribute__((weak));`  
  - Internal, do not call directly.

- `int hal_pwrmgr_RAM_retention(uint32_t sram);`  
  Configure RAM retention (RET_SRAM0 | RET_SRAM1 | RET_SRAM2).

- `int hal_pwrmgr_clk_gate_config(MODULE_e module);`  
  Configure clock source to enable on wakeup.

- `int hal_pwrmgr_RAM_retention_clr(void);`  
  Clear RAM retention.

- `int hal_pwrmgr_RAM_retention_set(void);`  
  Enable RAM retention.

- `int hal_pwrmgr_LowCurrentLdo_enable(void);`  
  Enable LowCurrentLDO output voltage.

- `int hal_pwrmgr_LowCurrentLdo_disable(void);`  
  Disable LowCurrentLDO output voltage.

- `int hal_pwrmgr_poweroff(pwroff_cfg_t *pcfg, uint8_t wakeup_pin_num);`  
  Enter shutdown mode after configuring wakeup sources.

- `void wakeupProcess_standby(void);`  
  Standby mode wakeup function (internal).

- `void hal_pwrmgr_enter_standby(pwroff_cfg_t* pcfg, uint8_t wakeup_pin_num);`  
  Enter standby mode.

---

## 3. Low Power Mode Usage Notes

- **Set CFG_SLEEP_MODE macro:**  
  Set `CFG_SLEEP_MODE=PWR_MODE_SLEEP` in your project to enable sleep mode.

- **Initialize pwrmgr module:**  
  Call `hal_pwrmgr_init()` during system initialization.

- **Configure RAM retention:**  
  Call `hal_pwrmgr_RAM_retention()` to retain needed memory regions during sleep.

- **Register module and callbacks:**  
  Use `hal_pwrmgr_register(MODULE_e mod, pwrmgr_Hdl_t sleepHandle, pwrmgr_Hdl_t wakeupHandle);`  
  Choose a module ID between MOD_USR1 and MOD_USR8 for your APP task.

- **Control sleep permission:**  
  Use `hal_pwrmgr_is_lock()`, `hal_pwrmgr_lock()`, and `hal_pwrmgr_unlock()` to control sleep.

- **Typical usage:**  
  - In `sleepHandle()`, configure pins and settings for sleep.
  - In `wakeupHandle()`, check wakeup source and reinitialize as needed.

---

## 4. Power Consumption Evaluation and Measured Data

### 4.1 Power Consumption Model

A sleep-wakeup cycle consists of:
- Sleep time (X1), Wakeup time (X2), Work time (X3), RF transmit time (X4), RF receive time (X5)
- Corresponding currents: Y1~Y5

**Average Power Calculation:**
```
Average Power = Total Power / Total Time
Total Power = (Sleep Current × Sleep Time) + (Wakeup Current × Wakeup Time) +
              (Work Current × (Work Time + RF Tx Time + RF Rx Time)) +
              (RF Tx Current × RF Tx Time) + (RF Rx Current × RF Rx Time)
Total Time = Sleep Time + Wakeup Time + Work Time + RF Tx Time + RF Rx Time
Battery Life (seconds) = Battery Capacity × 3600 / Average Power
```

### 4.2 Power Estimation

- Use the above model to estimate average power and battery life.

### 4.3 Measured Power Data

Example (simpleBlePeripheral project):

| HCLK | RF Time | Wakeup Time | Work Time | Sleep Time | Total Time | Wakeup Current | RF Current | Work Current | Sleep Current | Avg Power (mA) |
|------|---------|-------------|-----------|------------|------------|---------------|------------|--------------|---------------|----------------|
| 64M  | 676×3us | 854us       | 728×3us   | 500ms      | 505ms      | 3.07mA        | 3.65mA     | 3.65mA       | 5.8μA         | 0.046          |
| 48M  | 684×3us | 886us       | 738×3us   | 500ms      | 505ms      | 3.03mA        | 3.60mA     | 3.60mA       | 5.6μA         | 0.044          |
| 16M  | 683×3us | 964us       | 736×3us   | 500ms      | 505ms      | 3.03mA        | 3.60mA     | 3.60mA       | 5.6μA         | 0.039          |

- For a 520mAh battery and average power 0.0398mA:  
  Battery life = 520 × 3600 / 0.0398 = 47,035,175 seconds ≈ 1.5 years

### 4.4 System Power-On Startup Time

| Process         | Time   | Example Project         |
|-----------------|--------|------------------------|
| Cold Start      | 91ms   | simpleBLEPeripheral    |
| Soft Start      | 44ms   | simpleBLEPeripheral    |
| Wakeup          | 3.4ms  | bleuart_at             |
| Main to BLE Init| 31ms   | simpleBLEPeripheral    |

- **Cold Start:** First power-on, time depends on code initialization (handled by ROM code).
- **Soft Start:** Software reset, can bypass some steps via AON register (~50ms).
- **Wakeup:** Fastest, from SRAM, no flash copy or extra delay.

---

**For detailed register-level programming and code examples, refer to the SDK and code examples, refer to the SDK and original document.**