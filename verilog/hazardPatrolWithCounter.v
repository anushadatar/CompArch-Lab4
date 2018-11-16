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
    input [31:0] instruction_ID,
    input clk,

    output reg regIF_en, regID_en, nopMux
  );

  wire nzero, zero, rtype;
  not nalgene(nzero, zero);
  reg [1:0] counter;

  reg [5:0] rs, One_Before_Rs, Two_Before_Rs, Three_Before_Rs;
  reg [5:0] rt, One_Before_Rt, Two_Before_Rt, Three_Before_Rt;
  reg [5:0] rd, One_Before_Rd, Two_Before_Rd, Three_Before_Rd;
    
  reg[15:0] immediate; 
 
  initial begin
    counter <= 2'd3;
  end

  always @(posedge clk) begin
    if (instruction_ID[31:26] == `RTYPE) begin
    rs <= instruction_ID[26:21];
    rt <= instruction_ID[20:16];
    rd <= instruction_ID[15:11];
    immediate <= instruction_ID[15:0];

    if(counter == 2'd3) begin    
        One_Before_Rs <= rs;
        Two_Before_Rs <= One_Before_Rs;
        Three_Before_Rs <= Two_Before_Rs;
        One_Before_Rt <= rt;
        Two_Before_Rt <= One_Before_Rt;
        Three_Before_Rt <= Two_Before_Rt;

        One_Before_Rd <= rd;
        Two_Before_Rd <= One_Before_Rd;
        Three_Before_Rd <= Two_Before_Rd;
    
        if(One_Before_Rs == rd || One_Before_Rt == rd || One_Before_Rd == rt || One_Before_Rd == rs) begin
          regIF_en <= 0;
          regID_en <= 0;
          nopMux <= 1;
          counter <= 2'd0;
        end
        if(Two_Before_Rs == rd || Two_Before_Rt == rd || Two_Before_Rd == rt || Two_Before_Rd == rs) begin
          regIF_en <= 0;
          regID_en <= 0;
          nopMux <= 1;
          counter <= 2'd1;
        end
        if(Three_Before_Rs == rd || Three_Before_Rt == rd || Three_Before_Rd == rt || Three_Before_Rd == rs) begin
          regIF_en <= 0;
          regID_en <= 0;
          nopMux <= 1;
          counter <= 2'd2;
        end
      
    end
    else begin
        counter <= counter + 2'd1;
    end 
    end
    end
endmodule


module hazardPatrolJump (
    input clk,
    input[31:0] instruction_ID, 
    output reg regIF_en, regID_en, nopMux
  );
    reg[1:0] counter;
    initial begin
        counter <= 2'd3
    end

endmodule

