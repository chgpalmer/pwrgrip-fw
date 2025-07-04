# PHYPLUS6252 vs Freqchip Peripheral IP Comparison

## Name-based matches

### AP_CACHE_TypeDef <-> struct_CACHE_t
- **Struct name match:** 0.71
- **Field match:** 0.20
- **Matched:** CTRL0:CTRL
- **Unmatched in AP_CACHE_TypeDef:** CTRL1, reserverd, REMAP_TABLE, REMAP_CTRL
- **Unmatched in struct_CACHE_t:** ADDR_RANGE0, BANK_FLUSH_ADDR, ADDR_RANGE1, BANK_FLUSH_MASK, ADDR_RANGE2, ADDR_RANGE3, ENABLING

### AP_WDT_TypeDef <-> struct_WDT_t
- **Struct name match:** 0.60
- **Field match:** 0.83
- **Matched:** wdt_CR:CR, wdt_CCVR:CCVR, wdt_CRR:CRR, wdt_STAT:STAT, wdt_EOI:EOI
- **Unmatched in AP_WDT_TypeDef:** wdt_CNT
- **Unmatched in struct_WDT_t:** reserverd2, reserverd1, TORR

### AP_I2C_TypeDef <-> struct_I2C_t
- **Struct name match:** 0.60
- **Field match:** 0.94
- **Matched:**  
  TAR:IC_TAR, SAR:IC_SAR, HS_MADDR:IC_HS_MADDR, DATA_CMD:IC_DATA_CMD, FS_SCL_HCNT:IC_SS_SCL_HCNT, FS_SCL_LCNT:IC_SS_SCL_LCNT, INT_STAT:IC_INTR_STAT, INT_MASK:IC_INTR_MASK, RAW_INT_STAT:IC_RAW_INTR_STAT, RX_TL:IC_RX_TL, TX_TL:IC_TX_TL, CLR_INTR:IC_CLR_INTR, CLR_RX_UNDER:IC_CLR_UNDER, CLR_RX_OVER:IC_CLR_RX_OVER, CLR_TX_OVER:IC_CLR_TX_OVER, CLR_RD_REQ:IC_CLR_RD_REG, CLR_TX_ABRT:IC_CLR_TX_ABRT, CLR_RX_DONE:IC_CLR_RX_DONE, CLR_ACTIVITY:IC_CLR_ACTIVITY, CLR_STOP_DET:IC_CLR_STOP_DET, CLR_START_DET:IC_CLR_START_DET, ENABLE:IC_ENABLE, STATUS:IC_STATUS, TXFLR:IC_TXFLR, RXFLR:IC_RXFLR, SDA_HOLD:IC_SDA_HOLD, TX_ABRT_SOURCE:IC_TX_ABRT_SOURC, SLV_DATA_NACK:IC_SLV_DATA_NACK, SDA_SETUP:IC_SDA_SETUP, FS_SPKLEN:IC_FS_SCL_HCNT, CLR_RESTART_DET:IC_CLR_GEN_CALL, SCL_STUCK_LOW_TI:IC_FS_SCL_LCNT, CLR_SCL_STUCK_DE:IC_HS_SCL_HCNT
- **Unmatched in AP_I2C_TypeDef:** CTRL, SDA_STUCK_LOW_TIMEOUT
- **Unmatched in struct_I2C_t:** IC_DMA_RDLR, IC_DMA_CR, IC_FS_SPKLEN, IC_HS_SCL_LCNT, IC_CON, IC_ENABLE_STATUS, IC_DMA_TDLR, IC_ACK_GENERAL_CALL, IC_HS_SPKLEN

### AP_GPIO_TypeDef <-> struct_GPIO_t
- **Struct name match:** 0.67
- **Field match:** 0.20
- **Matched:** EXTI_INT_EN:int_polarity, EXTI_INT_STATUS:int_status
- **Unmatched in AP_GPIO_TypeDef:** GPIO_OutputEN, GPIO_IN_DATA, GPIO_OUT_DATA, GPIO_BIT_SET, GPIO_BIT_CLEAR, EXTI_EN, EXTI_TYPE, EXTI_CNT
- **Unmatched in struct_GPIO_t:** debounce, intmask, ver_id_code, ls_sync, config_reg2, swporta_dr, inten, ext_porta, porta_eoi, config_reg1, swporta_ddr, inttype_level, raw_instatus, id_code, swporta_ctl

### AP_ADCC_TypeDef <-> struct_SARADC_t
- **Struct name match:** 0.57
- **Field match:** 0.21
- **Matched:** control_1:SARADC_Control, int_pointer_ch0_:SARADC_INT_Enble, int_pointer_ch4_:SARADC_INT_Statu
- **Unmatched in AP_ADCC_TypeDef:** enable, reserve0, control_2, control_3, control_4, compare_reset, reserve1, intr_mask, intr_clear, intr_status, compare_cfg
- **Unmatched in struct_SARADC_t:** SARADC_ChannelStatus, SARADC_Queue0_ChannelSel1, SARADC_INT_Raws, SARADC_FIFO_Config, SARADC_AnalogConfig1, SARADC_WDT1_Threshold, SARADC_FIFO_Count, SARADC_ChannelData, SARADC_PGA0Ctrl, SARADC_Queue2_ChannelSel0, SARADC_MICCtrl, SARADC_Queue2_ChannelSel1, SARADC_Queue2_Config, SARADC_WDT1_Config, SARADC_ChannelConfig, SARADC_Queue1_ChannelSel0, SARADC_FIFO_Data, SARADC_WDT0_Config, SARADC_Queue1_ChannelSel1, SARADC_Timing, SARADC_Queue1_Config, SARADC_CAINCtrl, SARADC_Queue0_ChannelSel0, SARADC_Config, SARADC_PGA2Ctrl, SARADC_VbatCtrl, SARADC_AnalogConfig0, SARADC_WDT0_Threshold, SARADC_PGA1Ctrl, SARADC_Queue0_Config, SARADC_VbeCtrl

### AP_SPIF_TypeDef <-> struct_SPDIF_t
- **Struct name match:** 0.62
- **Field match:** 0.40
- **Matched:** SPDIF_CTRL:wr_completion_ct, SPDIF_INT_STS:int_status
- **Unmatched in AP_SPIF_TypeDef:** SPDIF_FIFO_CTRL, SPDIF_RAW_STS, SPDIF_FIFO_DATA
- **Unmatched in struct_SPDIF_t:** fcmd_rddata, dma_peripheral, fcmd_wrdata, int_mask, indirect_wr, indirect_ahb_addr_trig, indirect_rd_start_addr, fcmd, indirect_ahb_trig_addr_range, tx_threshold, rddata_capture, indirect_wr_start_addr, indirect_rd_num, dev_size, poll_fstatus, indirect_rd_watermark, wr_protection, rx_threshold, read_instr, sram_part, poll_expire, indirect_wr_cnt, indirect_rd, write_instr, n3, delay, indirect_wr_watermark, fcmd_addr, n2, n1, n4, config, up_wr_protection, sram_fill_level, mode_bit, low_wr_protection, remap

### AP_PWM_TypeDef <-> struct_PWM_t
- **Struct name match:** 0.60
- **Field match:** 0.00
- **Unmatched in AP_PWM_TypeDef:** pwmen
- **Unmatched in struct_PWM_t:** CaptureCtrl, Edge, CaptureValue, InverterEN, ChannelEN, Frequency, CaptureINTEN, CNT_EN, OutputEN, CapturePrescale, OutputValue, CaptureStatus, Update, OutputSelect

### AP_DMA_CH_TypeDef <-> REG_DMA_CR_t
- **Struct name match:** 0.60
- **Field match:** 0.00
- **Unmatched in AP_DMA_CH_TypeDef:** RDMAE, TDMAE
- **Unmatched in REG_DMA_CR_t:** CFG_H, LLP_H, DAR_H, LLP, DSTAT_L, SSTATAR_H, SSTAT, DSTAT, DSTATAR_H, SSTATAR, DAR, CTL_H, SAR_H, DSTATAR, CFG, CTL, SAR, SSTAT_H

### AP_DMA_INT_TypeDef <-> struct_PDMInit_t
- **Struct name match:** 0.67
- **Field match:** 0.00
- **Unmatched in AP_DMA_INT_TypeDef:** SampleRate, OverSampleMode, ChannelMode, Volume, FIFO_FullThreshold
- **Unmatched in struct_PDMInit_t:** MaskErr_H, StatusDstTran_H, RawErr_H, StatusInt_H, StatusDstTran, ClearDstTran, RawTfr, ClearErr_H, StatusTfr, StatusBlock_H, RawSrcTran, ClearDstTran_H, StatusErr, ClearBlock_H, RawBlock_H, RawDstTran, RawDstTran_H, MaskBlock_H, StatusTfr_H, ClearBlock, ClearSrcTran, ClearTfr, RawBlock, StatusInt, MaskErr, StatusSrcTran, StatusErr_H, ClearTfr_H, ClearErr, MaskBlock, RawSrcTran_H, RawTfr_H, MaskTfr, StatusBlock, StatusSrcTran_H, MaskTfr_H, MaskSrcTran_H, MaskDstTran, ClearSrcTran_H, RawErr, MaskSrcTran, MaskDstTran_H

### AP_DMA_SW_HANDSHAKE_TypeDef <-> dma_software_handshake_t
- **Struct name match:** 0.76
- **Field match:** 1.00
- **Matched:** ReqSrcReg:ReqSrcReg, ReqDstReg:ReqDstReg, SglRqSrcReg:ReqSrcReg_H, SglRqDstReg:ReqDstReg_H, LstSrcReg:LstSrcReg, LstDstReg:LstDstReg
- **Unmatched in dma_software_handshake_t:** LstSrcReg_H, LstDstReg_H, SglReqSrcReg, SglReqDstReg_H, SglReqSrcReg_H, SglReqDstReg

---

## Field-based matches for unmatched structs

### AP_COM_TypeDef <-> qspi_config_reg_t
- **Matched fields:** AP_STATUS:status, remap:enable_AHB_remap, RXEV_EN:write_en_pin, PERI_MASTER_SELECT:peri_sel
- **Unmatched in AP_COM_TypeDef:** CH0_AP_MBOX, CH0_CP_MBOX, CH1_AP_MBOX, CH1_CP_MBOX, CP_STATUS, AP_INTEN, CP_INTEN, STCALIB
- **Unmatched in qspi_config_reg_t:** enable_DAC, enalbe_XIP, cpha, reserved2, enable_XIP_next_R, enable_AHB_decoder, cpol, enable, octal_div2, peri_sel_line, baud_rate, rxd_push_mask, enable_DTR_prot, rxds_smp_mode, octal_xccela, sclk_out_mode, reserved0, enable_DMA, octal_opi, reserved3, enable_legacy

### AP_PCR_TypeDef <-> REG_PDMConfig_t
- **Matched fields:** SW_CLK:CLK_EN, APB_CLK:CLK_INV, CACHE_RST:RST
- **Unmatched in AP_PCR_TypeDef:** SW_RESET0, SW_RESET1, SW_RESET2, SW_RESET3, SW_CLK1, APB_CLK_UPDATE, CACHE_CLOCK_GATE, CACHE_BYPASS
- **Unmatched in REG_PDMConfig_t:** USB_MODE, SAMPLE_RATE, LR_SWAP, DAT_INV, EN, HPF_EN, rsv_0, MONO, OSR_MODE, DATA_SRC, CH_SEL

### AP_TIM_TypeDef <-> struct_Timer_t
- **Matched fields:** LoadCount:LoadCount, ControlReg:Control
- **Unmatched in AP_TIM_TypeDef:** CurrentCount, EOI, status
- **Unmatched in struct_Timer_t:** IntClear, CurrentValue, IntStatus

### AP_TIM_SYS_TypeDef <-> struct_SD_Device_t
- **Matched fields:** IntStatus:IntStatus, unMaskIntStatus:IntStatus2
- **Unmatched in AP_TIM_SYS_TypeDef:** EOI, version
- **Unmatched in struct_SD_Device_t:** Password_63_32, RCA, DMA2Control, IntSignal2, IntStatusEn, Function5Control, Function4Control, Argument, Function3Control, DMA2Address, IOREADY, CardAddress, Password_127_96, Function1Control, CardSize, CardOCR, Command, CardData, ADMAErrorStatus, Control2, DMA1Address, Argument2, IntSignalEn, PasswordLength, Function2Control, EraseWriteblockEnd, Control, SDIOFBRxControl, EraseWriteBlockStart, AHBMasterBurstSize, rsv_1, SDIOCCCRControl, Password_95_64, BlockCount, DMA1Control, Debug, SecureBlockCount, IntStatusEn2, rsv_0

### AP_I2S_BLOCK_TypeDef <-> struct_SPI_t
- **Matched fields:** RXFFR:RXFTLR, TXFFR:TXFTLR
- **Unmatched in AP_I2S_BLOCK_TypeDef:** IER, IRER, ITER, CER, CCR
- **Unmatched in struct_SPI_t:** RXUICR, CTRL0, CTRL2, DR, MWCR, SSI_EN, SER, IMR, ICR, TXFLR, SR, rsv_1, FLOW_CTRL, MSTICR, RX_SAMPLE_DLY, RISR, RXOICR, DMACR, BAUDR, DMARDLR, DMATDLR, CTRL1, TED, rsv_0, TXOICR, RXFLR, ISR

### AP_SSI_TypeDef <-> struct_SPI_t
- **Matched fields:** CTRL0:CR0, CTRL1:CR1, SSI_EN:SSI_COM_VER, MWCR:MWCR, SER:SER, BAUDR:BAUDR, TXFTLR:TXFTLR, RXFTLR:RXFTLR, TXFLR:TXFLR, RXFLR:RXFLR, SR:SR, IMR:IMR, ISR:ISR, RISR:RISR, TXOICR:TXOICR, RXOICR:RXOICR, RXUICR:RXUICR, MSTICR:MSTICR, ICR:ICR, DMACR:DMACR, DMATDLR:DMATDLR, DMARDLR:DMARDLR, DR:IDR
- **Unmatched in AP_SSI_TypeDef:** RX_SAMPLE_DLY, CTRL2, TED, FLOW_CTRL
- **Unmatched in struct_SPI_t:** CTRL0, RX_SAMPLE_DLY, CTRL2, DR, SSI_EN, CTRL1, TED, rsv_1, rsv_0, FLOW_CTRL

---

## Summary of struct matches

| Peripheral Pair         | Same IP Block? | Driver Code Reusable? | Notes                        |
|------------------------|:--------------:|:---------------------:|------------------------------|
| WDT                    | Yes            | Yes                   | High field match             |
| I2C                    | Yes            | Yes                   | Very high field match        |
| SSI (SPI)              | Yes            | Yes                   | Very high field match        |
| DMA SW HANDSHAKE       | Yes            | Yes                   | 100% field match             |
| SPDIF                  | No             | No                    | Only a couple of fields match|
| TIMER                  | No             | No                    | Only a couple of fields match|

---

## Struct file locations

| Struct Name                  | File Path                                                                 |
|------------------------------|--------------------------------------------------------------------------|
| AP_CACHE_TypeDef             | ./phy6252-SDK/components/inc/mcu_phy_bumbee.h                            |
| struct_CACHE_t               | ./hal_freqchip/fr30xx_c/components/drivers/peripheral/Inc/driver_cache.h |
| struct_WDT_t                 | ./hal_freqchip/fr30xx_c/components/drivers/peripheral/Inc/driver_wdt.h   |
| AP_WDT_TypeDef               | ./phy6252-SDK/components/inc/mcu_phy_bumbee.h                            |
| struct_I2C_t                 | ./hal_freqchip/fr30xx_c/components/drivers/peripheral/Inc/driver_i2c.h   |
| AP_I2C_TypeDef               | ./phy6252-SDK/components/inc/mcu_phy_bumbee.h                            |
| struct_GPIO_t                | ./hal_freqchip/fr30xx_c/components/drivers/peripheral/Inc/driver_gpio.h   |
| AP_GPIO_TypeDef               | ./phy6252-SDK/components/inc/mcu_phy_bumbee.h                            |
| AP_ADCC_TypeDef              | ./phy6252-SDK/components/inc/mcu_phy_bumbee.h                            |
| struct_SARADC_t              | ./hal_freqchip/fr30xx_c/components/drivers/peripheral/Inc/driver_saradc.h |
| struct_SPDIF_t               | ./hal_freqchip/fr30xx_c/components/drivers/peripheral/Inc/driver_spdif.h |
| AP_SPIF_TypeDef              | ./phy6252-SDK/components/inc/mcu_phy_bumbee.h                            |
| AP_PWM_TypeDef               | ./phy6252-SDK/components/inc/mcu_phy_bumbee.h                            |
| struct_PWM_t                 | ./hal_freqchip/fr30xx_c/components/drivers/peripheral/Inc/driver_pwm.h   |
| REG_DMA_CR_t                 | ./hal_freqchip/fr30xx_c/components/drivers/peripheral/Inc/driver_i2c.h   |
| AP_DMA_CH_TypeDef            | ./phy6252-SDK/components/inc/mcu_phy_bumbee.h                            |
| struct_PDMInit_t             | ./hal_freqchip/fr30xx_c/components/drivers/peripheral/Inc/driver_pdm.h   |
| AP_DMA_INT_TypeDef           | ./phy6252-SDK/components/inc/mcu_phy_bumbee.h                            |
| dma_software_handshake_t     | ./hal_freqchip/fr30xx_c/components/drivers/peripheral/Inc/driver_dma.h   |
| AP_DMA_SW_HANDSHAKE_TypeDef  | ./phy6252-SDK/components/inc/mcu_phy_bumbee.h                            |
| qspi_dma_peri_cfg_t          | ./hal_freqchip/fr30xx_c/components/drivers/peripheral/Inc/driver_qspi.h   |
| AP_DMA_MISC_TypeDef          | ./phy6252-SDK/components/inc/mcu_phy_bumbee.h                            |
| AP_COM_TypeDef               | ./phy6252-SDK/components/inc/mcu_phy_bumbee.h                            |
| qspi_config_reg_t            | ./hal_freqchip/fr30xx_c/components/drivers/peripheral/Inc/driver_qspi.h   |
| AP_PCR_TypeDef               | ./phy6252-SDK/components/inc/mcu_phy_bumbee.h                            |
| REG_PDMConfig_t              | ./hal_freqchip/fr30xx_c/components/drivers/peripheral/Inc/driver_pdm.h   |
| AP_TIM_TypeDef               | ./phy6252-SDK/components/inc/mcu_phy_bumbee.h                            |
| struct_Timer_t               | ./hal_freqchip/fr30xx_c/components/drivers/peripheral/Inc/driver_timer.h   |
| AP_TIM_SYS_TypeDef           | ./phy6252-SDK/components/inc/mcu_phy_bumbee.h                            |
| struct_SD_Device_t           | ./hal_freqchip/fr30xx_c/components/drivers/peripheral/Inc/driver_sd_device.h |
| AP_I2S_BLOCK_TypeDef         | ./phy6252-SDK/components/inc/mcu_phy_bumbee.h                            |
| struct_SPI_t                 | ./hal_freqchip/fr30xx_c/components/drivers/peripheral/Inc/driver_spi.h   |
| AP_SSI_TypeDef               | ./phy6252-SDK/components/inc/mcu_phy_bumbee.h                            |
| struct_SPI_t                 | ./hal_freqchip/fr30xx_c/components/drivers/peripheral/Inc/driver_spi.h   |
| struct_GPIO_t                | ./hal_freqchip/fr30xx_c/components/drivers/peripheral/Inc/driver_gpio.h   |
| IOMUX_TypeDef                | ./phy6252-SDK/components/inc/mcu_phy_bumbee.h                            |
| AP_AON_TypeDef               | ./phy6252-SDK/components/inc/mcu_phy_bumbee.h                            |
| struct_SPI_t                 | ./hal_freqchip/fr30xx_c/components/drivers/peripheral/Inc/driver_spi.h   |
| AP_RTC_TypeDef               | ./phy6252-SDK/components/inc/mcu_phy_bumbee.h                            |
| SD_CardCSDTypeDef            | ./hal_freqchip/fr30xx_c/components/drivers/peripheral/Inc/driver_sd_card.h |
| AP_Wakeup_TypeDef            | ./phy6252-SDK/components/inc/mcu_phy_bumbee.h                            |
| struct_SD_Device_t           | ./hal_freqchip/fr30xx_c/components/drivers/peripheral/Inc/driver_sd_device.h |
| struct_SEC_AES_t             | ./hal_freqchip/fr30xx_c/components/drivers/peripheral/Inc/driver_aes.h   |
| AP_PCRM_TypeDef              | ./phy6252-SDK/components/inc/mcu_phy_bumbee.h                            |
| AP_KSCAN_TypeDef             | ./phy6252-SDK/components/inc/mcu_phy_bumbee.h                            |
| struct_SPI_t                 | ./hal_freqchip/fr30xx_c/components/drivers/peripheral/Inc/driver_spi.h   |
| AP_PWMCTRL_TypeDef           | ./phy6252-SDK/components/inc/mcu_phy_bumbee.h                            |
| struct_SPI_t                 | ./hal_freqchip/fr30xx_c/components/drivers/peripheral/Inc/driver_spi.h   |

---

## Notes

- For WDT, I2C, SSI (SPI), and DMA SW HANDSHAKE, the register fields match closely and driver code can be reused.
- For SPDIF and TIMER, the register fields do not match closely enough for direct driver reuse.
- For all other peripherals, there is insufficient similarity for code reuse.
