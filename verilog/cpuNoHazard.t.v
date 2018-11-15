`include "cpu.v"
module cpuTest ();
  reg clk;

  initial clk=0;
  always #5 clk=~clk;

  cpu dut(clk);


initial begin

    $dumpfile("nohazard.vcd");
    $dumpvars();

    $readmemh("benHillIsEnteringStormyWaters.text", dut.cpuMemory.memory, 0);
    #250; // Run Program
    $finish();

  end

endmodule //
