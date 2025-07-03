# PHY62XX BSP Button Application Note v1.1 (English Summary)

## 1. What is BSP_Button?

BSP_Button is a middleware button handling program.  
- Hardware depends on GPIO and KSCAN.  
- The upper layer listens for button events via TASK scheduling.  
- Supports button types: press, long press start, long press keep, release, etc.

---

## 2. Basic Configuration

### 2.1 File Description

To use BSP_Button, include these files and add hardware initialization code in your application task:
- `bsp_gpio.c`: GPIO button driver (include if using GPIO buttons)
- `kscan.c`: KSCAN button driver (include if using KSCAN buttons)
- `bsp_button.c`: BSP_Button detection logic
- `bsp_button_task.c`: BSP_Button scheduling mechanism

### 2.2 Button Data Structure

- Button data type is BYTE.
- High 2 bits: button event type (press, long press start, long press keep, release, etc.)
- Low 6 bits: button value (0x00~0x3F). 0x30~0x3F are reserved for system use; use 0x00~0x2F.

### 2.3 Button Types

- **Single button:** One button corresponds to one GPIO or one KSCAN row/column intersection.
- **Combination button:** Multiple single buttons combined (e.g., P1 and P2 pressed together).

### 2.4 Hardware Configuration

Choose the appropriate hardware configuration:
- `BSP_BTN_JUST_GPIO`: Only use GPIO buttons
- `BSP_BTN_JUST_KSCAN`: Only use KSCAN buttons
- `BSP_BTN_GPIO_AND_KSCAN`: Use both GPIO and KSCAN buttons

Set the number of single and combination buttons:
- `BSP_SINGLE_BTN_NUM`: Number of single buttons
- `BSP_COMBINE_BTN_NUM`: Number of combination buttons (set to 0 if none)
- `BSP_TOTAL_BTN_NUM`: Total number of buttons (single + combination)

If both GPIO and KSCAN are used, specify each type's single and combination button counts:
- `BSP_KSCAN_SINGLE_BTN_NUM`, `BSP_GPIO_SINGLE_BTN_NUM`
- `BSP_KSCAN_COMBINE_BTN_NUM`, `BSP_GPIO_COMBINE_BTN_NUM`

Button order: KSCAN single buttons → GPIO single buttons → combination buttons.

---

## 2.5 Application Examples

### 2.5.1 GPIO Only

- Configure hardware mode and button counts in `bsp_button_task.h`
- Specify GPIO pin count and idle level in `bsp_gpio.h`
- Configure pins and callback in your app; specify combination button relationships if needed.

**Example:**
- 3 single buttons (P14, P15, P26), 2 combination buttons (P14+P15, P14+P26), idle level high.

| Button Value | Hardware Mapping         |
|--------------|-------------------------|
| 0            | P14 pressed             |
| 1            | P15 pressed             |
| 2            | P26 pressed             |
| 3            | P14+P15 pressed         |
| 4            | P14+P26 pressed         |

**Sample Code:**
```c
// bsp_button_task.h
#define BSP_BTN_HARDWARE_CONFIG BSP_BTN_JUST_GPIO
#define BSP_SINGLE_BTN_NUM (GPIO_SINGLE_BTN_NUM)
#define BSP_COMBINE_BTN_NUM (2)
#define BSP_TOTAL_BTN_NUM (BSP_SINGLE_BTN_NUM + BSP_COMBINE_BTN_NUM)

// bsp_gpio.h
#define GPIO_SINGLE_BTN_NUM 3
#define GPIO_SINGLE_BTN_IDLE_LEVEL 1

// bsp_btn_demo.c
uint32_t usr_combine_btn_array[BSP_COMBINE_BTN] = {
    (BIT(0)|BIT(1)),
    (BIT(0)|BIT(2)),
};
void hal_bsp_btn_callback(uint8_t evt) {
    LOG("gpio evt:0x%x\n", evt);
    switch(BSP_BTN_TYPE(evt)) {
        case BSP_BTN_PD_TYPE: LOG("press down "); break;
        case BSP_BTN_UP_TYPE: LOG("press up "); break;
        case BSP_BTN_LPS_TYPE: LOG("long press start "); break;
        case BSP_BTN_LPK_TYPE: LOG("long press keep "); break;
        default: LOG("unexpected "); break;
    }
    LOG("value:%d\n", BSP_BTN_INDEX(evt));
}
Gpio_Btn_Info gpio_btn_info = {
    {P14, P15, P26},
    hal_bsp_btn_callback,
};
void Demo_Init(uint8 task_id) {
    if(PPlus_SUCCESS == hal_gpio_btn_init(&gpio_btn_info)) {
        bsp_btn_gpio_flag = TRUE;
    } else {
        LOG("hal_gpio_btn_init error:%d\n", __LINE__);
    }
}
```

---

### 2.5.2 KSCAN Only

- Configure hardware mode and button counts in `bsp_button_task.h`
- Specify KSCAN row/column count in `kscan.h`
- Configure pins and callback in your app; specify combination button relationships if needed.

**Example:**
- 4x4 single buttons (ROW: P0, P2, P25, P18; COL: P1, P3, P24, P20), 2 combination buttons.

| Button Value | Hardware Mapping                |
|--------------|--------------------------------|
| 0            | Row0Col0 pressed               |
| 1            | Row0Col1 pressed               |
| ...          | ...                            |
| 16           | Row0Col0 + Row0Col1 pressed    |
| 17           | Row0Col2 + Row0Col3 pressed    |

**Sample Code:**
```c
// bsp_button_task.h
#define BSP_BTN_HARDWARE_CONFIG BSP_BTN_JUST_KSCAN
#define BSP_SINGLE_BTN_NUM (NUM_KEY_ROWS * NUM_KEY_COLS)
#define BSP_COMBINE_BTN_NUM (2)
#define BSP_TOTAL_BTN_NUM (BSP_SINGLE_BTN_NUM + BSP_COMBINE_BTN_NUM)

// kscan.h
#define NUM_KEY_ROWS 4
#define NUM_KEY_COLS 4

// bsp_btn_demo.c
KSCAN_ROWS_e rows[NUM_KEY_ROWS] = {KEY_ROW_P00, KEY_ROW_P02, KEY_ROW_P25, KEY_ROW_P18};
KSCAN_COLS_e cols[NUM_KEY_COLS] = {KEY_COL_P01, KEY_COL_P03, KEY_COL_P24, KEY_COL_P20};
uint32_t usr_combine_btn_array[BSP_COMBINE_BTN_NUM] = {
    (BIT(0)|BIT(1)),
    (BIT(2)|BIT(3)),
};
void hal_bsp_btn_callback(uint8_t evt) {
    LOG("kscan evt:0x%x ", evt);
    switch(BSP_BTN_TYPE(evt)) {
        case BSP_BTN_PD_TYPE: LOG("press down "); break;
        case BSP_BTN_UP_TYPE: LOG("press up "); break;
        case BSP_BTN_LPS_TYPE: LOG("long press start "); break;
        case BSP_BTN_LPK_TYPE: LOG("long press keep "); break;
        default: LOG("unexpected "); break;
    }
    LOG("value:%d\n", BSP_BTN_INDEX(evt));
}
void Demo_Init(uint8 task_id) {
    hal_kscan_btn_check(hal_bsp_btn_callback);
    if(bsp_btn_kscan_flag != TRUE) {
        LOG("hal_kscan_btn_check error:%d\n", __LINE__);
    }
}
```

---

### 2.5.3 GPIO and KSCAN

- Configure both GPIO and KSCAN pins and counts.
- Specify combination button relationships as needed.

**Example:**
- 4x4 KSCAN single buttons, 3 GPIO single buttons, 1 KSCAN combo, 1 GPIO combo.

| Button Value | Hardware Mapping                |
|--------------|--------------------------------|
| 0            | Row0Col0 pressed               |
| ...          | ...                            |
| 16           | P14 pressed                    |
| 17           | P15 pressed                    |
| 18           | P26 pressed                    |
| 19           | Row0Col2 + Row0Col3 pressed    |
| 20           | P14 + P15 pressed              |

**Sample Code:**
```c
// bsp_button_task.h
#define BSP_BTN_HARDWARE_CONFIG BSP_BTN_GPIO_AND_KSCAN
#define BSP_KSCAN_SINGLE_BTN_NUM (NUM_KEY_ROWS * NUM_KEY_COLS)
#define BSP_GPIO_SINGLE_BTN_NUM (GPIO_SINGLE_BTN_NUM)
#define BSP_KSCAN_COMBINE_BTN_NUM (1)
#define BSP_GPIO_COMBINE_BTN_NUM (1)
#define BSP_SINGLE_BTN_NUM (BSP_KSCAN_SINGLE_BTN_NUM + BSP_GPIO_SINGLE_BTN_NUM)
#define BSP_COMBINE_BTN_NUM (BSP_KSCAN_COMBINE_BTN_NUM + BSP_GPIO_COMBINE_BTN_NUM)
#define BSP_TOTAL_BTN_NUM (BSP_SINGLE_BTN_NUM + BSP_COMBINE_BTN_NUM)

// kscan.h
#define NUM_KEY_ROWS 4
#define NUM_KEY_COLS 4

// bsp_gpio.h
#define GPIO_SINGLE_BTN_NUM 3
#define GPIO_SINGLE_BTN_IDLE_LEVEL 1

// bsp_btn_demo.c
KSCAN_ROWS_e rows[NUM_KEY_ROWS] = {KEY_ROW_P00, KEY_ROW_P02, KEY_ROW_P25, KEY_ROW_P18};
KSCAN_COLS_e cols[NUM_KEY_COLS] = {KEY_COL_P01, KEY_COL_P03, KEY_COL_P24, KEY_COL_P20};
BTN_T usr_sum_btn_array[BSP_TOTAL_BTN_NUM];
uint32_t usr_combine_btn_array[BSP_COMBINE_BTN_NUM] = {
    (BIT(2)|BIT(3)),
    (BIT(16)|BIT(17)),
};
void hal_bsp_btn_callback(uint8_t evt) {
    LOG("kscan evt:0x%x ", evt);
    switch(BSP_BTN_TYPE(evt)) {
        case BSP_BTN_PD_TYPE: LOG("press down "); break;
        case BSP_BTN_UP_TYPE: LOG("press up "); break;
        case BSP_BTN_LPS_TYPE: LOG("long press start "); break;
        case BSP_BTN_LPK_TYPE: LOG("long press keep "); break;
        default: LOG("unexpected "); break;
    }
    LOG("value:%d\n", BSP_BTN_INDEX(evt));
}
Gpio_Btn_Info gpio_btn_info = {
    {P14, P15, P26},
    hal_bsp_btn_callback,
};
void Demo_Init(uint8 task_id) {
    hal_kscan_btn_check(hal_bsp_btn_callback);
    if(bsp_btn_kscan_flag != TRUE) {
        LOG("hal_kscan_btn_check error:%d\n", __LINE__);
    }
    if(PPlus_SUCCESS == hal_gpio_btn_init(&gpio_btn_info)) {
        bsp_btn_gpio_flag = TRUE;
    } else {
        LOG("hal_gpio_btn_init error:%d\n", __LINE__);
    }
}
```

---

## 3. Extended Configuration

### 3.1 Supported Button Types

- By default, only button press is supported.
- To support release and long press, define:
  - `BSP_BTN_LONG_PRESS_ENABLE`: Enables long press events (start and keep).

### 3.2 Configurable Timing Parameters

- `BTN_SYS_TICK`: Polling period, in ms.
- `BTN_FILTER_TICK_COUNT`: Debounce time, calculated as `BTN_SYS_TICK * BTN_FILTER_TICK_COUNT`.
- `BTN_LONG_PRESS_START_TICK_COUNT`: Long press start time, `BTN_SYS_TICK * BTN_LONG_PRESS_START_TICK_COUNT`.
- `BTN_LONG_PRESS_KEEP_TICK_COUNT`: Long press keep time, `BTN_SYS_TICK * BTN_LONG_PRESS_KEEP_TICK_COUNT`.

### 3.3 Supported Button Count

- Default: up to 48 buttons.
- Can be increased by modifying the code as needed.

---