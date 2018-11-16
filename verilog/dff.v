/*
* D-Flip Flop module
*/

module programCounter
   (
    input [31:0] d,
    input  clk,
    input wrenable,
    output reg [31:0] q
    );

   always @(posedge clk) begin
    if(wrenable) begin
        q <= d;
    end
    end

    initial begin
      q = 32'b0;
    end
endmodule
