module des_exp_perm (
    input [31:0] in,
    output reg [47:0] out
);

  wire [33:0] ext = {in[0], in, in[31]};
  integer i;
  always @(*) begin

    for (i = 0; i < 8; i = i + 1) out[i*6+:6] = ext[i*4+:6];
  end
endmodule
