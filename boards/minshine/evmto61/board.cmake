# Copyright (c) 2024 Charlie Palmer
# SPDX-License-Identifier: Apache-2.0

board_runner_args(pyocd "--target=at32f413cb" "--tool-opt=--pack=${ZEPHYR_HAL_ARTERY_MODULE_DIR}/${CONFIG_SOC_SERIES}/support/ArteryTek.AT32F413_DFP.2.1.4.pack")

include(${ZEPHYR_BASE}/boards/common/pyocd.board.cmake)
