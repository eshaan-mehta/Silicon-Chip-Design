import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge

@cocotb.test()
async def compile_only(dut):
    """ Minimal test just to compile the design. No signal driving. """
    
    # Start the clock (optional, you can skip if you don't need clock activity)
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())
    
    # Wait for a couple of clock cycles (optional)
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    
    # Since we're not applying any signals, the test simply compiles and exits
    dut._log.info("Testbench compiled successfully without signal activity.")

