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
wire [31:0] imm_ID, imm_EX;
wire [31:0] branchALUin;
wire [27:0] jumpShifted;
wire [31:0] aluResult;
wire zeroFlag;
wire [31:0] readOut1, readOut2;
wire [31:0] pcPlusFour;
wire [31:0] branchAddress;
wire [31:0] pc_ID, pc_IF, pc_EX, pc_MEM, pc_WB;
wire [31:0] ReadDataMem_WB, ReadDataMem_MEM;

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
wire [31:0] ReadData1_EX, ReadData2_EX, ReadData1_ID, ReadData2_ID, ReadData1_MEM, ReadData2_MEM, ReadData1_WB, ReadData2_WB;
wire [31:0] rd_ID, rd_EX, rd_MEM, rd_WB;
wire [31:0] result_MEM, result_EX, result_WB;
wire zeroflag_MEM, zeroflag_EX, zeroflag_WB;
wire [4:0] raddress_ID, raddress_EX, raddress_MEM, raddress_WB;
wire [4:0] rt_ID, rt_EX, rt_MEM, rt_WB;

memory cpuMemory (
  .clk(clk),
  .dataMemorydataOut(ReadDataMem_MEM),
  .instructionOut(instruction_IF),
  .InstructionAddress(pc_IF), // initially we set these to [15:0], address are not full 32 bits???
  .dataMemoryAddress(result_MEM), //// address are not full 32 bits???
  .dataMemorywriteEnable(dm_we_MEM),
  .dataMemorydataIn(ReadData2_MEM)
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
  .q_rt(rt_EX),
  .q_raddress(raddress_EX),

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
  .d_reg_we(reg_we_ID),
  .d_dm_we(dm_we_ID),
  .d_rt(rt_ID),
  .d_raddress(raddress_ID),

  .wrenable(1'b1),
  .clk(clk)
);

registerEX regiEX(
  .q_ReadData1(ReadData1_MEM),
  .q_ReadData2(ReadData2_MEM),
  .q_pc(pc_MEM),
  .q_result(result_MEM),
  .q_zeroflag(zeroflag_MEM),
  .q_pcmux(pcmux_MEM),
  .q_regmux(regmux_MEM),
  .q_dm_mux(dm_mux_MEM),
  .q_rd(rd_MEM),
  .q_reg_we(reg_we_MEM),
  .q_dm_we(dm_we_MEM),
  .q_rt(rt_MEM),
  .q_raddress(raddress_MEM),

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
  .d_rt(rt_EX),
  .d_raddress(raddress_EX),

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
  .q_ReadDataMem(ReadDataMem_WB),
  .q_rt(rt_WB),
  .q_raddress(raddress_WB),

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
  .d_ReadDataMem(ReadDataMem_MEM),
  .d_rt(rt_MEM),
  .d_raddress(raddress_MEM),

  .wrenable(1'b1),
  .clk(clk)
);


mux4to1by32 muxPC(
  .address(pcmux_ID),
  .input0(pcPlusFour),
  .input1({pcPlusFour[31:28], jumpShifted}),
  .input2(readOut1),
  .input3(branchAddress),
  .out(pcIn)
  );

mux4to1by5 muxRegWriteSelect(
  .address(regmux_WB),
  .input0(rt_WB),
  .input1(raddress_WB),
  .input2(5'h1F),
  .input3(5'b0),
  .out(regWrAddress)
  );

mux2to1by32 muxB(
    .address(alu_b_mux_EX),
    .input0(ReadData2_EX),
    .input1(imm_EX),
    .out(opB)
    );

mux2to1by32 muxA(
  .address(alu_a_mux_EX),
  .input0(ReadData1_EX),
  .input1(pc_EX),
  .out(opA)
  );

mux2to1by32 muxWD3(
  .address(dm_mux_WB),
  .input0(ReadDataMem_WB),
  .input1(result_WB),
  .out(writeData)
  );

signExtend signExtension(
  .immediate(instruction_ID[15:0]),
  .extended(imm_ID)
  );

lshift32 shiftSignExt(
  .immediate(imm_ID),
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
  .zero(zeroflag_EX),
  .carryout(),
  .result(result_EX)
  );

regfile registerFile(
  .Clk(clk),
  .RegWrite(reg_we_WB),
  .WriteRegister(regWrAddress),
  .ReadRegister1(instruction_ID[25:21]),
  .ReadRegister2(instruction_ID[20:16]),
  .WriteData(writeData),
  .ReadData1(ReadData1_ID),
  .ReadData2(ReadData2_ID)
  );

instructionDecoder opDecoder(
  .opcode(instruction_ID[31:26]),
  .functcode(instruction_ID[5:0]),
  .zero(zeroFlag),
  .dm_we(dm_we_ID),
  .dm_mux(dm_mux_ID),
  .alu_a_mux(alu_a_mux_ID),
  .alu_b_mux(alu_b_mux_ID),
  .regmux(regmux_ID),
  .pcmux(pcmux_ID),
  .alu_op(alu_op_ID),
  .reg_we(reg_we_ID),
  .raddressOut(raddress_ID),
  .raddress(instruction_ID[15:11]),
  .rtIn(instruction_ID[20:16]),
  .rtOut(rt_ID)
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
