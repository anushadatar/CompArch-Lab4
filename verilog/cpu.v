`include "alu.v"
`include "memory.v"
`include "lshift2.v"
`include "instructionDecoder.v"
`include "mux.v"
`include "signextend.v"
`include "regfile.v"
`include "dff.v"
`include "intermediate_registers.v"

module cpu(
  input clk
);

wire [31:0] pcIn, instruction, dataOut;
wire [31:0] opA, opB;
wire [4:0] regWrAddress;
wire [31:0] writeData;
wire [31:0] imm_ID;
wire [31:0] branchALUin;
wire [27:0] jumpShifted;
wire [31:0] aluResult;
wire zeroFlag;
wire [31:0] readOut1, readOut2;
wire [31:0] pcPlusFour;
wire [31:0] branchAddress;
wire [31:0] pc_ID, pc_IF, pc_EX, pc_MEM;

// Instruction decoder flags.
wire [1:0] regmux_ID, regmux_EX, regmux_MEM, regmux_WB;
wire [1:0] pcmux_ID, pcmux_EX, pcmux_MEM, pcmux_WB;
wire [2:0] alu_op_ID, alu_op_EX;
wire dm_mux_ID, dm_mux_EX, dm_mux_MEM, dm_mux_WB;
wire alu_a_mux_ID, alu_a_mux_EX;
wire alu_b_mux_ID, alu_b_mux_EX;
wire dm_we_ID, dm_we_EX, dm_we_MEM;
wire reg_we_ID, reg_we_EX, reg_we_MEM, reg_we_WB;
wire [31:0] instruction_IF, instruction_ID;

memory cpuMemory (
  .clk(clk),
  .dataMemorydataOut(dataOut),
  .instructionOut(instruction_IF),
  .InstructionAddress(pc_IF), // initially we set these to [15:0], address are not full 32 bits???
  .dataMemoryAddress(aluResult), //// address are not full 32 bits???
  .dataMemorywriteEnable(dm_we),
  .dataMemorydataIn(readOut2)
  );

programCounter pc (
  .d(pcIn),
  .clk(clk),
  .q(pc_IF)
  );

registerIF regiIF(
  .q_instruction(instruction_ID),
  .q_pc(pc_ID),
  .d_instruction(instruction_IF),
  .d_pc(pc_IF),
  .wrenable(1'b1),
  .clk(clk)
);

registerID regiID(
  .q_ReadData1(ReadData1_EX),
  .q_ReadData2(ReadData2_EX),
  .q_pc(pc_EX),
  .q_imm(imm_EX),
  .q_pcmux(pcmux_EX),
  .q_regmux(regmux_EX),
  .q_alu_a_mux(alu_a_mux_EX),
  .q_alu_b_mux(alu_b_mux_EX),
  .q_dm_mux(dm_mux_EX),
  .q_alu_op(alu_op_EX),
  .q_rd(rd_EX),
  .q_reg_we(reg_we_EX),
  .q_dm_we(dm_we_EX),

  .d_ReadData1(ReadData1_ID),
  .d_ReadData2(ReadData2_ID),
  .d_pc(pc_ID),
  .d_imm(imm_ID),
  .d_pcmux(pcmux_ID),
  .d_regmux(regmux_ID),
  .d_alu_a_mux(alu_a_mux_ID),
  .d_alu_b_mux(alu_b_mux_ID),
  .d_dm_mux(dm_mux_ID),
  .d_alu_op(alu_op_ID),
  .d_rd(rd_ID),
  .d_reg_we(reg_we_EX),
  .d_dm_we(dm_we_EX),

  .wrenable(1'b1),
  .clk(clk)
);

registerEX regiEX(
  .q_ReadData1(ReadData1_ID),
  .q_ReadData2(ReadData2_ID),
  .q_pc(pc_MEM),
  .q_result(result_MEM),
  .q_zeroflag(zeroflag_MEM),
  .q_pcmux(pcmux_MEM),
  .q_regmux(regmux_MEM),
  .q_dm_mux(dm_mux_MEM),
  .q_alu_op(alu_op_MEM),
  .q_rd(rd_MEM),
  .q_reg_we(reg_we_MEM),
  .q_dm_we(dm_we_MEM),

  .d_ReadData1(ReadData1_EX),
  .d_ReadData2(ReadData2_EX),
  .d_result(result_EX),
  .d_pcmux(pcmux_EX),
  .d_regmux(regmux_EX),
  .d_zeroflag(zeroflag_EX),
  .d_dm_mux(dm_mux_EX),
  .d_pc(pc_EX),
  .d_rd(rd_EX),
  .d_reg_we(reg_we_EX),
  .d_dm_we(dm_we_EX),

  .wrenable(1'b1),
  .clk(clk)
);

registerMEM regiMEM(
  .q_ReadData1(ReadData1_WB),
  .q_ReadData2(ReadData2_WB),
  .q_result(result_WB),
  .q_pcmux(pcmux_WB),
  .q_regmux(regmux_WB),
  .q_zeroflag(zeroflag_WB),
  .q_dm_mux(dm_mux_WB),
  .q_pc(pc_WB),
  .q_rd(rd_WB),
  .q_reg_we(reg_we_WB),
  .q_pc(dm_we_WB),
  .q_ReadDataMem(ReadDataMem_WB),

  .d_ReadData1(ReadData1_MEM),
  .d_ReadData2(ReadData2_MEM),
  .d_result(result_MEM),
  .d_pcmux(pcmux_MEM),
  .d_regmux(regmux_MEM),
  .d_zeroflag(zeroflag_MEM),
  .d_dm_mux(dm_mux_MEM),
  .d_pc(pc_MEM),
  .d_rd(rd_MEM),
  .d_reg_we(reg_we_MEM),
  .d_pc(dm_we_MEM),
  .d_ReadDataMem(ReadDataMem_MEM)
  .wrenable(1'b1),
  .clk(clk)
);


mux4to1by32 muxPC(
  .address(pcmux_WB),
  .input0(pcPlusFour),
  .input1({pcPlusFour[31:28], jumpShifted}),
  .input2(readOut1),
  .input3(branchAddress),
  .out(pcIn)
  );

mux4to1by5 muxRegWriteSelect(
  .address(regmux_WB),
  .input0(instruction[20:16]),
  .input1(5'h1F),
  .input2(instruction[15:11]),
  .input3(5'b0),
  .out(regWrAddress)
  );

mux2to1by32 muxB(
    .address(alu_b_mux_EX),
    .input0(signExtended),
    .input1(readOut2),
    .out(opB)
    );

mux2to1by32 muxA(
  .address(alu_a_mux),
  .input0(readOut1),
  .input1(pc_IF),
  .out(opA)
  );

mux2to1by32 muxWD3(
  .address(dm_mux),
  .input0(dataOut),
  .input1(aluResult),
  .out(writeData)
  );

signExtend signExtension(
  .immediate(instruction[15:0]),
  .extended(imm_ID)
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
  .command(alu_op_EX),
  .overflow(),
  .zero(zeroFlag),
  .carryout(),
  .result(aluResult)
  );

regfile registerFile(
  .Clk(clk),
  .RegWrite(reg_we),
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
  .zero(zeroFlag),
  .dm_we(dm_we_ID),
  .dm_mux(dm_mux_ID),
  .alu_a_mux(alu_a_mux_ID),
  .alu_b_mux(alu_b_mux_ID),
  .regmux(regmux_ID),
  .pcmux(pcmux_ID),
  .alu_op(alu_op_ID),
  .reg_we(reg_we_ID)
  );

ALU pcAddFour(
  .operandA(32'd4),
  .operandB(pc_IF),
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
