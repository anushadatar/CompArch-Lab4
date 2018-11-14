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


module instructionDecoder(
    input [5:0] opcode,
    input [5:0] functcode,
    input zero,

    output reg dm_mux, reg_we, alu_a_mux, alu_b_mux, dm_we,
    output reg [1:0] regmux, pcmux, 
    output reg [2:0] alu_op
  );

  wire nzero;
  not not0(nzero, zero);

  initial begin
    pcmux = 2'b0;
    alu_a_mux = 1'b0;
    alu_b_mux = 1'b0;
  end

  always @(*) begin
    case(opcode)

      `RTYPE: begin
        dm_we <= 1'b0;
        alu_a_mux <= 1'b0;
        alu_b_mux <= 2'd1;
        dm_mux <= 1'b1;
        regmux <= 2'd2;

        case(functcode)
          `JR: begin
            reg_we <= 1'b0;
            pcmux <= 2'd2;
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
        dm_mux <= 1'b0;
        alu_b_mux <= 2'd0;
        regmux <= 2'd0;
        pcmux <= 2'd0;
        alu_op <= `ADDSIGNAL;
      end

      `SW: begin
        reg_we <= 1'b0;
        alu_a_mux <= 1'b0;
        dm_we <= 1'b1;
        dm_mux <= 1'b0;
        alu_b_mux <= 2'd0;
        regmux <= 2'b0;
        pcmux <= 2'd0;
        alu_op <= `ADDSIGNAL;
      end

      `BEQ: begin
        reg_we <= 1'b0;
        alu_a_mux <= 1'b0;
        dm_we <= 1'b0;
        dm_mux = 1'b0;
        alu_b_mux <= 2'd1;
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
        alu_b_mux <= 2'd1;
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
        alu_b_mux = 2'd0;
        regmux <= 2'b0;
        pcmux <= 2'd0;
        alu_op <= `ADDSIGNAL;
      end

      `XORI: begin
        reg_we <= 1'b1;
        alu_a_mux <= 1'b0;
        dm_we <= 1'b0;
        dm_mux <= 1'b1;
        alu_b_mux <= 2'd0;
        regmux <= 2'b0;
        pcmux <= 2'b0;
        alu_op <= `XORSIGNAL;
      end

      `JUMP: begin
        reg_we <= 1'b0;
        alu_a_mux = 1'b0;
        dm_we <= 1'b0;
        dm_mux = 1'b0;
        alu_b_mux = 1'b0;
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
