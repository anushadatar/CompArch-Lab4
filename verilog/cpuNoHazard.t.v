`include "cpu.v"
module cpuTest ();
  reg clk;

  initial clk=0;
  always #5 clk=~clk;

  cpu dut(clk);


initial begin

    $dumpfile("nohazard.vcd");
    $dumpvars();

    $readmemh("benHilllBeginsExercising.text", dut.cpuMemory.memory, 0);
    //$readmemh("benHillRemembers.data", dut.cpuMemory.memory, 16'h2000);
    #420; // Run Program
    $finish();

  end

endmodule //
