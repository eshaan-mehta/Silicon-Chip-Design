# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Set the clock period to 10 ns (100 MHz)
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Resetting design")
    dut.ena.value = 1
    dut.ui_in.value = 0  # Initialize control and address inputs
    dut.uio_in.value = 0  # Initialize write data
    dut.rst_n.value = 0   # Assert reset
    await ClockCycles(dut.clk, 10)  # Wait for 10 clock cycles during reset
    dut.rst_n.value = 1   # Release reset

    dut._log.info("Design out of reset, beginning test...")

    # Test Case 1: Write to RAM at address 0x01
    addr = 0x01
    write_data = 0xAA
    dut.ui_in.value = (0 << 7) | (0 << 6) | addr  # ce_n = 1, lr_n = 0 (write), addr = 0x01
    dut.uio_in.value = write_data  # Write data to RAM
    dut._log.info(f"Writing 0x{write_data:X} to RAM at address 0x{addr:X}")
    await ClockCycles(dut.clk, 1)  # Wait for one clock cycle

    # Test Case 2: Read from RAM at address 0x01
    dut.ui_in.value = (0 << 7) | (1 << 6) | addr  # ce_n = 0 (read), lr_n = 1 (read), addr = 0x01
    await ClockCycles(dut.clk, 1)  # Wait for one clock cycle to see the output

    # Verify the data
    read_data = dut.uio_out.value.integer
    assert read_data == write_data, f"Read data 0x{read_data:X} does not match expected 0x{write_data:X}"
    dut._log.info(f"Successfully read 0x{read_data:X} from RAM at address 0x{addr:X}")

    # Test Case 3: Write to RAM at a different address and verify
    addr = 0x02
    write_data = 0x55
    dut.ui_in.value = (0 << 7) | (0 << 6) | addr  # ce_n = 1, lr_n = 0 (write), addr = 0x02
    dut.uio_in.value = write_data  # Write data to RAM
    dut._log.info(f"Writing 0x{write_data:X} to RAM at address 0x{addr:X}")
    await ClockCycles(dut.clk, 1)  # Wait for one clock cycle

    # Read from the second address
    dut.ui_in.value = (0 << 7) | (1 << 6) | addr  # ce_n = 0 (read), lr_n = 1 (read), addr = 0x02
    await ClockCycles(dut.clk, 1)  # Wait for one clock cycle

    # Verify the data
    read_data = dut.uio_out.value.integer
    assert read_data == write_data, f"Read data 0x{read_data:X} does not match expected 0x{write_data:X}"
    dut._log.info(f"Successfully read 0x{read_data:X} from RAM at address 0x{addr:X}")

    dut._log.info("Test completed successfully")
