module mux2_to1#(parameter DATAWIDTH = 64)(
    input [DATAWIDTH-1:0]in0,in1,
    input sel,
    output [DATAWIDTH-1:0] out
    );

    assign out = sel? in1:in0;
endmodule