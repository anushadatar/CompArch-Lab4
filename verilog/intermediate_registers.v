
module registerIF
(
  output reg [31:0] q_instruction,
  output reg [31:0] q_pc,
  input [31:0] d_instruction,
  input [31:0] d_pc,
  input wrenable,
  input clk
);

  always @(posedge clk) begin
      if(wrenable) begin
        q_instruction <= d_instruction;
        q_pc <= d_pc;
      end
  end

endmodule

module registerID
(
  output reg [31:0] q_ReadData1,
  output reg [31:0] q_ReadData2,
  output reg [31:0] q_pc,
  output reg [31:0] q_imm,
  output reg [1:0] q_pcmux,
  output reg [1:0] q_regmux,
  output reg q_alu_a_mux,
  output reg programCounter,
  output reg q_alu_b_mux,
  output reg q_dm_mux,
  output reg q_reg_we,
  output reg q_dm_we,
  output reg [2:0] q_alu_op,
  output reg [31:0] q_rd,
  output reg [4:0] q_rt,
  output reg [4:0] q_raddress,
  output reg [27:0] q_jumpShifted,

  input [31:0] d_ReadData1,
  input [31:0] d_ReadData2,
  input [31:0] d_pc,
  input [31:0] d_imm,
  input [1:0] d_pcmux,
  input [1:0] d_regmux,
  input d_alu_a_mux,
  input d_alu_b_mux,
  input d_dm_mux,
  input d_reg_we,
  input d_dm_we,
  input [2:0] d_alu_op,
  input [31:0] d_rd,
  input [4:0] d_rt,
  input [4:0] d_raddress,
  input [27:0] d_jumpShifted,


  input wrenable,
  input clk
);

  always @(posedge clk) begin
    if(wrenable) begin
      q_ReadData1 <= d_ReadData1;
      q_ReadData2 <= d_ReadData2;
      q_pc <= d_pc;
      q_imm <= d_imm;
      q_pcmux <= d_pcmux;
      q_regmux <= d_regmux;
      q_alu_a_mux <= d_alu_a_mux;
      q_alu_b_mux <= d_alu_b_mux;
      q_dm_mux <= d_dm_mux;
      q_reg_we <= d_reg_we;
      q_dm_we <= d_dm_we;
      q_alu_op <= d_alu_op;
      q_rd <= d_rd;
      q_rt <= d_rt;
      q_raddress <= d_raddress;
      q_jumpShifted <= d_jumpShifted;
   end
   else begin
     q_ReadData1 <= 0;
     q_ReadData2 <= 0;
     q_pc <= 0;
     q_imm <= 0;
     q_pcmux <= 0;
     q_regmux <= 0;
     q_alu_a_mux <= 0;
     q_alu_b_mux <= 0;
     q_dm_mux <= 0;
     q_reg_we <= 0;
     q_dm_we <= 0;
     q_alu_op <= 0;
     q_rd <= 0;
     q_rt <= 0;
     q_raddress <= 0;
     q_jumpShifted <= 0;
   end
  end

endmodule

module registerEX
(
  output reg [31:0] q_ReadData1,
  output reg [31:0] q_ReadData2,
  output reg [31:0] q_result,
  output reg [1:0] q_pcmux,
  output reg [1:0] q_regmux,
  output reg q_dm_mux,
  output reg q_reg_we,
  output reg q_dm_we,
  output reg q_zeroflag,
  output reg [31:0] q_rd,
  output reg [31:0] q_pc,
  output reg [4:0] q_rt,
  output reg [4:0] q_raddress,
  output reg [27:0] q_jumpShifted,

  input [31:0] d_ReadData1,
  input [31:0] d_ReadData2,
  input [31:0] d_result,
  input [1:0] d_pcmux,
  input [1:0] d_regmux,
  input d_dm_mux,
  input d_reg_we,
  input d_dm_we,
  input d_zeroflag,
  input [31:0] d_rd,
  input [31:0] d_pc,
  input [4:0] d_rt,
  input [4:0] d_raddress,
  input [27:0] d_jumpShifted,

  input wrenable,
  input clk
);

  always @(posedge clk) begin
    if(wrenable) begin
      q_ReadData1 <= d_ReadData1;
      q_ReadData2 <= d_ReadData2;
      q_result <= d_result;
      q_pcmux <= d_pcmux;
      q_regmux <= d_regmux;
      q_dm_mux <= d_dm_mux;
      q_reg_we <= d_reg_we;
      q_dm_we <= d_dm_we;
      q_zeroflag <= d_zeroflag;
      q_pc <= d_pc;
      q_rd <= d_rd;
      q_rt <= d_rt;
      q_raddress <= d_raddress;
      q_jumpShifted <= d_jumpShifted;
    end
  end

endmodule

module registerMEM
(
  output reg [31:0] q_ReadData1,
  output reg [31:0] q_ReadData2,
  output reg [31:0] q_result,
  output reg [1:0] q_pcmux,
  output reg [1:0] q_regmux,
  output reg q_dm_mux,
  output reg q_reg_we,
  output reg q_zeroflag,
  output reg [31:0] q_ReadDataMem,
  output reg [31:0] q_rd,
  output reg [4:0] q_rt,
  output reg [4:0] q_raddress,
  output reg [31:0] q_pc,
  output reg [27:0] q_jumpShifted,

  input [31:0] d_ReadData1,
  input [31:0] d_ReadData2,
  input [31:0] d_result,
  input [1:0] d_pcmux,
  input [1:0] d_regmux,
  input d_dm_mux,
  input d_reg_we,
  input d_zeroflag,
  input [31:0] d_ReadDataMem,
  input [31:0] d_rd,
  input [4:0] d_rt,
  input [4:0] d_raddress,
  input [31:0] d_pc,
  input [27:0] d_jumpShifted,

  input wrenable,
  input clk
);

  always @(posedge clk) begin
    if(wrenable) begin
      q_ReadData1 <= d_ReadData1;
      q_ReadData2 <= d_ReadData2;
      q_result <= d_result;
      q_pcmux <= d_pcmux;
      q_regmux <= d_regmux;
      q_dm_mux <= d_dm_mux;
      q_reg_we <= d_reg_we;
      q_zeroflag <= d_zeroflag;
      q_ReadDataMem <= d_ReadDataMem;
      q_rd <= d_rd;
      q_pc <= d_pc;
      q_rt <= d_rt;
      q_raddress <= d_raddress;
      q_jumpShifted <= d_jumpShifted;
    end
  end

endmodule
