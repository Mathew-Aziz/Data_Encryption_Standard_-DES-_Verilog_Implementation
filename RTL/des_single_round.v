module des_single_round (
    input  wire        clk,
    input  wire [31:0] left_in,
    input  wire [31:0] right_in,
    input  wire [47:0] round_key,

    output wire [31:0] left_out,
    output wire [31:0] right_out
);

  wire [47:0] expanded_right;
  wire [47:0] mixed_right;
  wire [31:0] substituted_right;
  wire [31:0] permuted_right;
  wire [31:0] feistel_result;

endmodule
