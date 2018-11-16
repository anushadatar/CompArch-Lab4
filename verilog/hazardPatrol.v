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
    input [31:0] noopOut,
    input clk,

    output reg regIF_en, regID_en, nopMux, pcEnable
  );

  wire nzero, zero;
  not nalgene(nzero, zero);
  reg [1:0] counter;

  reg [5:0] nush1, nush2, nush3, nush4;
  reg [5:0] opcode, rt, rd, rs;
  reg  rtype, itype, jtype, count3, count2, count1;

  always @(posedge clk) begin
        opcode <= noopOut[31:26];
        //rs <= noopOut[25:21];
        //rt <= noopOut[20:16];
        //rd <= noopOut[15:11];
        itype = (noopOut[31:26] == `ADDI || noopOut[31:26] == `XORI || noopOut[31:26] == `LW || noopOut[31:26] == `SW);
        rtype = (noopOut[31:26] == `RTYPE);
        jtype = (noopOut[31:26] == `JUMP);

        nush4 <= nush3;
        nush3 <= nush2;
        nush2 <= nush1;

        if(itype) begin
          nush1 <= noopOut[20:16];
          count3 <= count2;
          count2 <= count1;
          count1 <= 1;
          if(noopOut[25:21] == nush2 || noopOut[25:21] == nush3 || noopOut[25:21] == nush4) begin
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
        else if(rtype && noopOut != 32'b0) begin
          nush1 <= noopOut[15:11];
          count3 <= count2;
          count2 <= count1;
          count1 <= 1;
          if(noopOut[25:21] == nush2 || noopOut[25:21] == nush3 || noopOut[25:21] == nush4) begin
            regIF_en <= 0;
            regID_en <= 0;
            nopMux <= 1;
            pcEnable <= 0;
          end
          else if(noopOut[20:16] == nush2 || noopOut[20:16] == nush3 || noopOut[20:16] == nush4) begin
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
        else if(jtype) begin
          nush1 <= 6'b0;
          count3 <= 0;
          count2 <= 0;
          count1 <= 1;
          regIF_en <= 0;
          regID_en <= 0;
          nopMux <= 1;
          pcEnable <= 0;

        end
        else begin
          if(count3 == 0) begin
            regIF_en <= 0;
            regID_en <= 0;
            nopMux <= 1;
            pcEnable <= 0;
            count3 <= count2;
            count2 <= count1;
            count1 <= 1;
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
