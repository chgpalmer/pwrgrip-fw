# PHY6252/6222 Security Boot User Guide v1.0 (English Summary)

**Version:** 1.0  
**Author:** HXR  
**Date:** 2020.12  
**Applies to:** PHY6252, PHY6222

---

## Revision History

| Revision | Author | Date       | Description |
|----------|--------|------------|-------------|
| V1.0     | HXR    | 2020.12.22 | Draft       |

---

## Table of Contents

1. Introduction  
2. Efuse Key  
   - 2.1 Efuse API  
   - 2.2 Efuse Key Programming  
      - 2.2.1 Programming Operation  
      - 2.2.2 Programming Notes  
3. Security Boot Key Generation  
   - 3.1 g_sec_key Generation  
   - 3.2 g_ota_sec_key Generation  
4. Security Boot  
   - 4.1 Process Details  
   - 4.2 ROM Security Boot  
   - 4.3 OTA Security Boot  
5. Flash Mapping  
   - 5.1 No OTA Mode  
   - 5.2 Support OTA Mode  

---

## 1. Introduction

This document describes the Security Boot feature for PHY6252/PHY6222 products.  
It covers Efuse Key programming, key generation, the security boot process, and flash mapping for both No OTA and Support OTA modes.

---

## 2. Efuse Key

A key part of Security Boot is the use of efuse keys.  
**Note:** Each efuse key can only be programmed once and cannot be changed.

### 2.1 Efuse API

There are 4 efuse blocks:

| Block             | Index | Purpose                                 |
|-------------------|-------|-----------------------------------------|
| EFUSE_BLOCK_0     | 0     | Security boot efuse key                 |
| EFUSE_BLOCK_1     | 1     | OTA security boot app efuse key         |
| EFUSE_BLOCK_2     | 2     | Not used                                |
| EFUSE_BLOCK_3     | 3     | Not used                                |

**APIs:**
- `efuse_lock(EFUSE_block_t block)`: Lock efuse block after writing
- `efuse_read(EFUSE_block_t block, buf)`: Read efuse block data
- `efuse_write(EFUSE_block_t block, buf, us)`: Write efuse block data

### 2.2 Efuse Key Programming

Efuse key programming must be done in programming mode (`cmd>>:` prompt).

#### 2.2.1 Programming Operation

- Use PhyPlusKit.exe or programmer tools, which parse and program efuse block keys via CSV files.
- **CSV format example:**

**No OTA Mode:**
```
#efuse0
FFFFFF00-K
8765432111223344
```
- Only efuse block0 is programmed for ROM security boot.

**Support OTA Mode:**
```
#efuse0
FFFFFF00-K
8765432111223344
#efuse1
FFFFFF01-K
1234567813151718
```
- Both efuse block0 and block1 are programmed for OTA security boot.

- CSV file explanation:
  - First line: Name (e.g., #efuse0, #efuse1)
  - Second line: Write address and port (address: FFFFFF00, FFFFFF01, etc.; port: K)
  - Third line: 64-bit key value (must be odd parity)

#### 2.2.2 Programming Notes

1. Programming must be done in programming mode (`cmd>>:`).
2. Each efuse block can only be programmed once and cannot be changed.
3. The programmed value must have odd parity (number of 1-bits is odd), otherwise an error occurs.

---

## 3. Security Boot Key Generation

Security boot uses AES-CCM to encrypt the application. On boot, the image is decrypted.  
Two keys are used: `g_sec_key` (ROM security boot) and `g_ota_sec_key` (OTA security boot).

### 3.1 g_sec_key Generation

- Used for ROM security boot (No OTA).
- Generated using PhyPlusKit.exe by parsing a `*.key.csv` file.

**CSV example:**
```
#sec_key
#sec_plaintext
#iv
#efuse0
2808-M
2810-M
2830-M
FFFFFF00-K
a7471cb6817e9014
3b92b5882ae845586c0d7c2086d6eac0
38363334373835323731343536303030
8765432111223344
```
- Load the `*.key.csv` file in PhyPlusKit.exe, click GenKey to generate a `*.sec.csv` file containing the key.

### 3.2 g_ota_sec_key Generation

- Used for OTA security boot (Support OTA).
- Also generated using PhyPlusKit.exe with a different `*.key.csv` file.

**CSV example:**
```
#sec_key
#sec_plaintext
#iv
#efuse0
#ota_sec_key
#ota_plaintext
#efuse1
2808-M
2810-M
2830-M
FFFFFF00-K
2908-M
2910-M
FFFFFF01-K
a7471cb6817e9014
3b92b5882ae845586c0d7c2086d6eac0
38363334373835323731343536303030
8765432111223344
817e9014a7471cb6
e907c7b41754a060d34a62853cb23de8
1234567813151718
```
- The process is similar to 3.1. The generated `*.sec.csv` file contains both keys.

- The `efuse_wr.csv` file is also generated for efuse programming.

---

## 4. Security Boot

Describes the use of tools and the security boot process.

### 4.1 Process Details

1. Power on PHY6252/PHY6222, connect via DWC (TM=0), reset the board to enter programming mode (`cmd>>:`).
2. In HEXMerge, select SEC_MIC and SEC controls. Use the `*.sec.csv` file generated in section 3.
3. Select the application firmware (No OTA or Support OTA), click HexF to generate the encrypted `hexf` file.
4. In HEX, select the generated `hexf` file and the `efuse_wr.csv` file.
5. Click Erase, then Write to program firmware and efuse.
6. After successful programming, power cycle (TM=0) or reset (TM=1) to run the application and complete security boot.

### 4.2 ROM Security Boot (No OTA)

- Supported in PhyPlusKit.exe v2.4.5e and later.
- In HEXMerge, select SEC_MIC mode and SEC control.
- Batch page: load `*.key.csv` and generate `*.sec.csv`.
- Select application firmware (No OTA), click HexF to generate `hexf`.
- In HEX, select `hexf` and `efuse_wr.csv`.
- Click Erase, then Write.
- After programming, power cycle or reset to complete security boot.

### 4.3 OTA Security Boot (Support OTA)

- Similar to No OTA, but select `ota.hex` and the appropriate mode.
- For offline programming, only the `hexf` and `efuse_wr.csv` files are needed.

---

## 5. Flash Mapping

### 5.1 No OTA Mode Flash Mapping

**256KB Flash:**

| Region         | Start   | End     |
|----------------|---------|---------|
| Reserved       | 0x00000 | 0x01FFF |
| 1st Boot info  | 0x02000 | 0x02FFF |
| FCDS           | 0x03000 | 0x04FFF |
| App Bank       | 0x05000 | 0x1FFFF |
| XIP            | 0x20000 | 0x3BFFF |
| FS (UCDS)      | 0x3C000 | 0x3DFFF |
| Resource       | 0x3E000 | 0x3FFFF |
| FW Storage     | 0x40000 | 0x3FFFF |

**512KB Flash:**  
(Similar structure, with larger address ranges.)

### 5.2 Support OTA Flash Mapping

**256KB Flash:**

| Region         | Start   | End     |
|----------------|---------|---------|
| Reserved       | 0x00000 | 0x01FFF |
| 1st Boot info  | 0x02000 | 0x02FFF |
| 2nd Boot info  | 0x03000 | 0x04FFF |
| FCDS           | 0x05000 | 0x10FFF |
| OTA Bootloader | 0x11000 | 0x1FFFF |
| App Bank       | 0x20000 | 0x3BFFF |
| XIP            | 0x3C000 | 0x3DFFF |
| FS (UCDS)      | 0x3E000 | 0x3FFFF |
| Resource       | 0x40000 | 0x3FFFF |
| FW Storage     | 0x40000 | 0x3FFFF |

**512KB Flash:**  
(Similar structure, with larger address ranges.)

---

**For detailed register-level programming and code examples, refer to the SDK and original document.**