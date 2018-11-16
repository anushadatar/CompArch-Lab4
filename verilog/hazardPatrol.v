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


module hazardPatrol(
    input [31:0] instruction_ID,

    output regIF_en, regID_en, nopMux,
  );

  wire nzero;
  not not0(nzero, zero);
  reg [1:0] counter;



  initial begin
    rs = instruction_ID[26:21];
    rt = instruction_ID[20:16];
    rd = instruction_ID[15:11];
    immediate = instruction_ID[15:0];
  end

  always @(posedge clk) begin
    
    One_Before_Rs <= rs;
    Two_Before_Rs <= One_Before_Rs;
    Three_Before_Rs <= Two_Before_Rs;

    One_Before_Rt <= rt;
    Two_Before_Rt <= One_Before_Rt;
    Three_Before_Rt <= Two_Before_Rt;

    One_Before_Rd <= rd;
    Two_Before_Rd <= One_Before_Rd;
    Three_Before_Rd <= Two_Before_Rd;

    if(instruction_ID[31:26] == RTYPE) begin
      if(One_Before_Rs == rd || Two_Before_Rs == rd || Three_Before_Rs == rd) begin
        regIF_en <= 0;
        regID_en <= 0;
        nopMux <= 1;
      end


  end

  always @(*) begin
  raddressOut <= raddress;
  rtOut <= rtIn;
    case(opcode)

      `RTYPE: begin
        dm_we <= 1'b0;
        alu_a_mux <= 1'b0;
        alu_b_mux <= 2'd0;
        dm_mux <= 1'b1;
        regmux <= 2'd1;

        case(functcode)
          `JR: begin
            reg_we <= 1'b0;
            pcmux <= 2'd1;
            alu_op <= 3'd0;
          end

          `ADD: begin
            reg_we <= 1'b1;
            pcmux <= 2'd0;
            alu_op <= `ADDSIGNAL;
          end
          `SUB: begin
            reg_we <= 1'b1;
            pcmux <= 2'd0;
            alu_op <= `SUBSIGNAL;
          end
          `SLT: begin
            reg_we <= 1'b1;
            pcmux <= 2'd0;
            alu_op <= `SLTSIGNAL;
          end

        endcase
      end

      `LW: begin
        reg_we <= 1'b1;
        alu_a_mux <= 1'b0;
        dm_we <= 1'b0;
        dm_mux <= 1'b1;
        alu_b_mux <= 2'd1;
        regmux <= 2'd0;
        pcmux <= 2'd0;
        alu_op <= `ADDSIGNAL;
      end

      `SW: begin
        reg_we <= 1'b0;
        alu_a_mux <= 1'b0;
        dm_we <= 1'b1;
        dm_mux <= 1'b0;
        alu_b_mux <= 2'd1;
        regmux <= 2'b0;
        pcmux <= 2'd0;
        alu_op <= `ADDSIGNAL;
      end

      `BEQ: begin
        reg_we <= 1'b0;
        alu_a_mux <= 1'b0;
        dm_we <= 1'b0;
        dm_mux = 1'b0;
        alu_b_mux <= 2'd0;
        regmux = 2'b0;
        alu_op <= `SUBSIGNAL;
        if(zero) begin
          pcmux <= 2'd3;
        end else begin
          pcmux <= 2'd0;
        end
      end

      `BNE: begin
        reg_we <= 1'b0;
        alu_a_mux <= 1'b0;
        dm_we <= 1'b0;
        dm_mux = 1'b0;
        alu_b_mux <= 2'd0;
        regmux = 2'b0;
        alu_op <= `SUBSIGNAL;
        if(nzero) begin
          pcmux <= 2'd3;
        end else begin
          pcmux <= 2'd0;
        end
      end

      `ADDI: begin
        reg_we <= 1'b1;
        alu_a_mux <= 1'b0; // Changed this to 1 from 0
        dm_we <= 1'b0;
        dm_mux <= 1'b1;
        alu_b_mux = 2'd1;
        regmux <= 2'b0;
        pcmux <= 2'd0;
        alu_op <= `ADDSIGNAL;
      end

      `XORI: begin
        reg_we <= 1'b1;
        alu_a_mux <= 1'b0;
        dm_we <= 1'b0;
        dm_mux <= 1'b1;
        alu_b_mux <= 2'd1;
        regmux <= 2'b0;
        pcmux <= 2'b0;
        alu_op <= `XORSIGNAL;
      end

      `JUMP: begin
        reg_we <= 1'b1;
        alu_a_mux = 1'b0;
        dm_we <= 1'b0;
        dm_mux = 1'b1;
        alu_b_mux = 1'b1;
        regmux = 1'b0;
        pcmux <= 2'b1;
        alu_op <= `ADDSIGNAL;
      end

      `JAL: begin
        reg_we <= 1'b1;
        alu_a_mux <= 1'b1;
        dm_we <= 1'b0;
        dm_mux <= 1'b1;
        alu_b_mux <= 2'd2;
        regmux <= 2'b1;
        pcmux <= 2'b1;
        alu_op <= `ADDSIGNAL;
      end

    endcase
  end

endmodule
