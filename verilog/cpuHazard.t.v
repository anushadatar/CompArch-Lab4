`include "cpu.v"
module cpuTest ();
  reg clk;

  initial clk=0;
  always #5 clk=~clk;

  cpu dut(clk);


initial begin

    $dumpfile("hazard.vcd");
    $dumpvars();

    $readmemh("tests/memory_test.text", dut.cpuMemory.memory, 0);
    //$readmemh("tests/memory_test.data", dut.cpuMemory.memory, 16'h2000);
    #420; // Run Program
    $finish();

  end

endmodule //
