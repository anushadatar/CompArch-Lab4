`include "alu.v"
`include "memory.v"
`include "lshift2.v"
`include "instructionDecoder.v"
`include "mux.v"
`include "signextend.v"
`include "regfile.v"
`include "dff.v"

module cpu(
  input clk
    );

wire [31:0] pcIn, pcOut, instruction, dataOut;
wire [31:0] opA, opB;
wire [4:0] regWrAddress;
wire [31:0] writeData;
wire [31:0] signExtended;
wire [31:0] branchALUin;
wire [27:0] jumpShifted;
wire [31:0] aluResult;
wire zeroFlag;
wire [31:0] readOut1, readOut2;
wire [1:0] pcMuxSelect, regWriteSelectControl, muxB_en;
wire dm_we, regWr_en, muxAselect, muxWd3_en;
wire [31:0] pcPlusFour;
wire [31:0] branchAddress;
wire [2:0] ALUop;

memory cpuMemory (
  .clk(clk),
  .dataMemorydataOut(dataOut),
  .instructionOut(instruction),
  .InstructionAddress(pcOut), // initially we set these to [15:0], address are not full 32 bits???
  .dataMemoryAddress(aluResult), //// address are not full 32 bits???
  .dataMemorywriteEnable(dm_we),
  .dataMemorydataIn(readOut2)
  );


programCounter pc (
  .d(pcIn),
  .clk(clk),
  .q(pcOut)
  );

mux4to1by32 muxPC(
  .address(pcMuxSelect),
  .input0(pcPlusFour),
  .input1({pcPlusFour[31:28], jumpShifted}),
  .input2(readOut1),
  .input3(branchAddress),
  .out(pcIn)
  );

mux4to1by5 muxRegWriteSelect(
  .address(regWriteSelectControl),
  .input0(instruction[20:16]),
  .input1(5'h1F),
  .input2(instruction[15:11]),
  .input3(),
  .out(regWrAddress)
  );

mux4to1by32 muxB(
    .address(muxB_en),
    .input0(signExtended),
    .input1(readOut2),
    .input2(32'd4),
    .out(opB)
    );

mux2to1by32 muxA(
  .address(muxAselect),
  .input0(readOut1),
  .input1(pcOut),
  .out(opA)
  );

mux2to1by32 muxWD3(
  .address(muxWd3_en),
  .input0(dataOut),
  .input1(aluResult),
  .out(writeData)
  );

signExtend signExtension(
  .immediate(instruction[15:0]),
  .extended(signExtended)
  );

lshift32 shiftSignExt(
  .immediate(signExtended),
  .lshifted(branchALUin)
  );

lshift28 shiftPC(
  .immediate(instruction[25:0]),
  .lshifted(jumpShifted)
  );

ALU OpALU(
  .operandA(opA),
  .operandB(opB),
  .command(ALUop),
  .overflow(),
  .zero(zeroFlag),
  .carryout(),
  .result(aluResult)
  );

regfile registerFile(
  .Clk(clk),
  .RegWrite(regWr_en),
  .WriteRegister(regWrAddress),
  .ReadRegister1(instruction[25:21]),
  .ReadRegister2(instruction[20:16]),
  .WriteData(writeData),
  .ReadData1(readOut1),
  .ReadData2(readOut2)
  );

instructionDecoder opDecoder(
  .opcode(instruction[31:26]),
  .functcode(instruction[5:0]),
  .regWrite(regWr_en),
  .muxA_en(muxAselect),
  .zero(zeroFlag),
  .dm_we(dm_we),
  .muxWD3_en(muxWd3_en),
  .muxB_en(muxB_en),
  .regWriteAddSelect(regWriteSelectControl),
  .muxPC(pcMuxSelect),
  .ALUop(ALUop)
  );

ALU pcAddFour(
  .operandA(32'd4),
  .operandB(pcOut),
  .command(3'd0), // Add Command
  .overflow(),
  .zero(),
  .carryout(),
  .result(pcPlusFour)
  );

ALU pcBranch(
  .operandA(branchALUin),
  .operandB(pcPlusFour),
  .command(3'd0), // Add Command
  .overflow(),
  .zero(),
  .carryout(),
  .result(branchAddress)
  );

  // assign pcIn = 32'b0;

// initial begin
//   pcOut = 32'b0;
// end
endmodule
