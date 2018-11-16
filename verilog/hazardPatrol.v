// Finite State Machine Module

// Op Codes
`define RTYPE 6'b0
`define LW 6'h23
`define SW 6'h2b
`define BEQ 6'h4
`define BNE 6'h5
`define ADDI 6'h8
`define XORI 6'he
`define JUMP 6'h2
`define JAL 6'h3

// Funct Codes
`define JR 6'h8
`define SUB 6'h22
`define SLT 6'h2a
`define ADD 6'h20

//ALU Op Codes
`define ADDSIGNAL  3'd0
`define SUBSIGNAL  3'd1
`define XORSIGNAL  3'd2
`define SLTSIGNAL  3'd3
`define ANDSIGNAL  3'd4
`define NANDSIGNAL 3'd5
`define NORSIGNAL  3'd6
`define ORSIGNAL   3'd7


module hazardPatrolRType (
    input [31:0] noopOut,
    input clk,

    output reg regIF_en, regID_en, nopMux, pcEnable
  );

  wire nzero, zero, rtype;
  not nalgene(nzero, zero);
  reg [1:0] counter;

  reg [5:0] rs, One_Before_Rs, Two_Before_Rs, Three_Before_Rs;
  reg [5:0] rt, One_Before_Rt, Two_Before_Rt, Three_Before_Rt;
  reg [5:0] rd, One_Before_Rd, Two_Before_Rd, Three_Before_Rd;
    
  always @(posedge clk) begin
        rs <= noopOut[26:21];
        rt <= noopOut[20:16];
        rd <= noopOut[15:11];

        One_Before_Rs <= rs;
        Two_Before_Rs <= One_Before_Rs;
        Three_Before_Rs <= Two_Before_Rs;
        One_Before_Rt <= rt;
        Two_Before_Rt <= One_Before_Rt;
        Three_Before_Rt <= Two_Before_Rt;

        One_Before_Rd <= rd;
        Two_Before_Rd <= One_Before_Rd;
        Three_Before_Rd <= Two_Before_Rd;
    
        rs <= noopOut[26:21];
        if(One_Before_Rd == rs || Two_Before_Rd == rs || Three_Before_Rd == rs) begin
          regIF_en <= 0;
          regID_en <= 0;
          nopMux <= 1;
          pcEnable <= 0;
        end
        else if (One_Before_Rd == rt || Two_Before_Rd == rt || Three_Before_Rd == rt) begin
          regIF_en <= 0;
          regID_en <= 0;
          nopMux <= 1;
          pcEnable <= 0;
        end
        else begin
          regIF_en <= 1;
          regID_en <= 1;
          nopMux <= 0;
          pcEnable <= 1;
        end
    end
  end
endmodule

module hazardPatrolJump (
    input clk,
    input[31:0] noopOut, 
    output reg regIF_en, regID_en, nopMux
  );
  

endmodule

