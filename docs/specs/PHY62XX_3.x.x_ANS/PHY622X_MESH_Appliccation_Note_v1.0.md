# PHY622X Mesh Development Guide v1.0 (English Summary)

**Applies to:** PHY6220, PHY6250, PHY6222, PHY6252  
**Date:** 2021.03  
**Author:** PHY+ SW

---

## 1. Introduction

This document introduces the PHY622X Mesh stack and usage, helping you understand the provided components, sample usage, and how to start BLE Mesh development using the provided samples.

### 1.1 Mesh Protocol Stack

The stack is built on Bluetooth Low Energy (BLE). The protocol stack layers are:

- **Model Layer:** Implements models, behaviors, messages, and states.
- **Foundation Model Layer:** Handles mesh network configuration and management models.
- **Access Layer:** Formats application data, manages encryption/decryption, and validates data for the correct network/application.
- **Upper Transport Layer:** Encrypts/decrypts and authenticates application data, handles transport control messages (e.g., friendship heartbeats).
- **Lower Transport Layer:** Handles PDU segmentation and reassembly.
- **Network Layer:** Defines message addressing and network message formats; implements relay and proxy behavior.
- **Bearer Layer:** Defines how PDUs are transported over BLE (Advertising Bearer and GATT Bearer).

### 1.2 Message Processing Flow

Mesh messages enter via the bearer layer (ADV/GATT), are decoded at the network layer, and processed according to their type (relay, proxy, or normal). Non-relay messages are reassembled in the lower transport layer, decrypted in the upper transport layer, checked in the access layer, and finally handled by the model layer.

Sending messages follows the reverse path: model layer → access layer (formatting) → upper transport layer (encryption) → lower transport layer (segmentation) → network layer (encryption) → bearer layer (output).

### 1.3 Mesh Provisioning

Provisioning is the process of adding an unprovisioned device to the mesh network. The provisioner provides configuration data (network key, IV index, unicast address) to the device, making it a mesh node. Provisioning uses configuration PDUs, which are handled by the configuration protocol and bearer layers.

---

## 2. Project and API Overview

### 2.1 Project Structure

- **ethermind:** Core mesh protocol stack (provisioning, config, message handling)
- **mesh samples & application:** Example applications and model implementations

### 2.2 Common Module Definitions

- `OSAL_CBTIMER_NUM_TASKS`: Number of internal callback timers (fixed at 1)
- `CFG_HEARTBEAT_MODE`: Enable (1) or disable (0) heartbeat feature

### 2.2.1 Mesh Sample Overview

Key libraries:
- `libethermind_ecdh.lib`: ECDH (not used in SDK)
- `libethermind_mesh_core.lib`: Mesh protocol stack (provision, config, message handling)
- `libethermind_mesh_models.lib`: Mesh model implementations (e.g., on/off)
- `libethermind_utils.lib`: Mesh storage

User code typically modifies `appl_sample_mesh_XXX.c`.

### 2.2.2 Model Definitions

Enable/disable models via macros:
- `USE_HEALTH`: Health model
- `USE_HSL`: Light HSL model
- `USE_LIGHTNESS`: Light Lightness model
- `USE_CTL`: Light CTL model
- `USE_SCENE`: Light Scene model
- `USE_VENDORMODEL`: Vendor model (enables easy bonding for Phy mesh app)

---

## 2.3 API Overview

- **UI_health_server_cb:** Health server callback
- **UI_register_foundation_model_servers:** Register foundation model server
- **UI_generic_onoff_model_states_initialization:** Initialize generic on/off model state
- **UI_generic_onoff_model_state_get:** Get generic on/off model state
- **MS_access_register_element:** Create primary element
- **UI_register_generic_onoff_model_server:** Register generic on/off model server
- **UI_generic_onoff_server_cb:** Generic on/off model callback
- **UI_light_hsl_model_states_initialization:** Initialize light HSL model state
- **UI_light_hsl_model_state_get/set:** Get/set light HSL model state
- **UI_light_hsl_server_cb:** Light HSL model callback
- **UI_light_ctl_model_states_initialization:** Initialize light CTL model state
- **UI_light_ctl_model_state_get/set:** Get/set light CTL model state
- **UI_light_ctl_server_cb:** Light CTL model callback
- **UI_register_light_ctl_model_server:** Register light CTL model server
- **UI_vendor_defined_model_states_initialization:** Vendor model state initialization
- **UI_vendor_example_model_state_get/set:** Get/set vendor model state
- **UI_phy_model_server_cb:** Vendor model callback
- **UI_register_vendor_defined_model_server:** Register vendor model server
- **UI_model_states_initialization:** Initialize all model states

---

## 2.4 Provisioning Interfaces

- **Provisioning timeout configuration:** `PROCFG_COMPLETE_TIMEOUT` (seconds)
- **Unprovision beacon UUID:** Identifies device type and version in the beacon packet
- **UI_provcfg_complete_timeout_handler:** Provisioning timeout callback
- **UI_prov_callback:** Provisioning callback
- **UI_register_prov:** Register provisioning service
- **UI_proxy_start_adv:** Start proxy beacon advertising (connectable)
- **UI_proxy_callback:** Proxy callback
- **UI_setup_prov:** Set up provisioning
- **UI_register_proxy:** Register proxy service
- **UI_set_brr_scan_rsp_data:** Set scan response data
- **UI_gatt_iface_event_pl_cb:** GATT event callback (provision/proxy events)
- **UI_sample_binding_app_key:** Bind app key to model
- **vm_subscriptiong_binding_cb/add/delete:** Handle subscription messages
- **UI_app_config_server_callback:** Config message callback
- **appl_mesh_sample:** Mesh sample initialization
- **UI_sample_get_net_key/device_key/app_key:** Get keys
- **UI_sample_reinit:** Reinitialize mesh sample

---

## 2.5 Other Common APIs

- **MS_access_cm_get_primary_unicast_address:** Get unicast address
- **MS_access_get_element_handle:** Get element handle
- **MS_access_get_model_handle:** Get model handle
- **MS_config_client_send_reliable_pdu:** Send reliable command
- **MS_access_cm_set_model_publication:** Set model publication
- **MS_access_send_pdu:** Send access layer PDU
- **MS_access_raw_data:** Send message to specified address
- **MS_generic_onoff_client_send_reliable_pdu:** Send reliable generic on/off command
- **MS_hsl_client_send_reliable_pdu:** Send reliable HSL command
- **MS_access_publish:** Publish access layer message
- **MS_common_reset:** Reset mesh stack
- **MS_access_ps_store_all_record/disable:** Store/disable mesh config storage
- **Enable/disable relay/proxy/friend features:** `MS_ENABLE_*_FEATURE`, `MS_DISABLE_*_FEATURE`

---

## 3. Application Examples

### 3.1 Mesh Initialization

Example initialization flow (simplified):

```c
void appl_mesh_sample(void) {
    MS_ACCESS_NODE_ID node_id;
    MS_ACCESS_ELEMENT_DESC element;
    MS_ACCESS_ELEMENT_HANDLE element_handle;
    API_RESULT retval;
    MS_CONFIG* config_ptr;

    // Initialize configuration, OSAL, debug, timer, utilities, mesh stack, BLE stack, GATT events, platform, LEDs
    // Create node and register element
    retval = MS_access_create_node(&node_id);
    element.loc = 0x0106; // GATT location
    retval = MS_access_register_element(node_id, &element, &element_handle);

    // Register models
    retval = UI_register_foundation_model_servers(element_handle);
    retval = UI_register_generic_onoff_model_server(element_handle);
    // ... (register other models as needed)

    // Initialize model states and register provisioning
    UI_model_states_initialization();
    UI_register_prov();

    // Set scan response data, config server callback, read MAC address, start timer, etc.
}
```

### 3.2 Vendor Model State Reporting

Example vendor model server callback:

```c
API_RESULT phyplusmodel_server_cb(
    MS_ACCESS_MODEL_HANDLE* handle,
    MS_NET_ADDR saddr,
    MS_NET_ADDR daddr,
    MS_SUBNET_HANDLE subnet_handle,
    MS_APPKEY_HANDLE appkey_handle,
    UINT32 opcode,
    UCHAR* data_param,
    UINT16 data_len
) {
    // Handle vendor model opcodes and call appropriate handlers
    // Call application callback with request context and parameters
    return retval;
}
```

### 3.3 Generic OnOff State Reporting

Example generic on/off server callback:

```c
static API_RESULT UI_generic_onoff_server_cb(
    MS_ACCESS_MODEL_REQ_MSG_CONTEXT* ctx,
    MS_ACCESS_MODEL_REQ_MSG_RAW* msg_raw,
    MS_ACCESS_MODEL_REQ_MSG_T* req_type,
    MS_ACCESS_MODEL_STATE_PARAMS* state_params,
    MS_ACCESS_MODEL_EXT_PARAMS* ext_params
) {
    // Handle GET/SET requests and send response if needed
    return retval;
}
```

---

## 4. References

- See original document for diagrams and additional details.
- Example code: `appl_sample_mesh_XXX.c`, mesh model/server/client registration, provisioning, and vendor model