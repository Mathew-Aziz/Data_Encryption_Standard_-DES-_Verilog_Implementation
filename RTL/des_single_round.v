module des_single_round (
    input  wire        clk,
    input  wire [63:0] in,
    input  wire [47:0] key,
    input  wire [4:0] round_number,
    output wire [63:0] out,
    output wire [55:0] rounded_key
);

  wire [47:0] expanded_right;
  wire [47:0] expand_xor_key;
  wire [47:0] perm_rounded_key;

  wire [31:0] perm_xor_left;
  wire [31:0] substituted_right;
  wire [31:0] feistel_result;

  wire [31:0] L0,R0; 
  wire [31:0] L1,R1;

  wire [27:0] key_c0,key_d0;
  wire [27:0] key_c1,key_d1;



  assign L0 = in [63:32];
  assign R1 = in [31:0];
  assign out [63:32] = L1;
  assign out [31:0] = R1;

  assign key_c0 = key[47:28];
  assign key_d0 = key[27:0];

  

  des_left_shift (
    .c_in(key_c0),.d_in(key_d0),
    .round_number(round_number),
    .c_out(key_c1),.d_out(key_d1)
  );

  assign rounded_key = {key_c1,key_d1};
  des_pc2 (
    .c_in(key_c1),.d_in(key_d1),.perm_rounded_key(perm_rounded_key)
  );

  des_exp_perm (
    .in(R0),.out(expanded_right)
  );

  assign expand_xor_key = perm_rounded_key ^ expanded_right;

  des_sbox (
    .in(expand_xor_key),.out(substituted_right)
  );

  des_perm (
    .in(substituted_right),.out(feistel_result)
  );

  assign perm_xor_left = feistel_result ^ L0;

  assign R1 = perm_xor_left;
  assign L1 = R0;
endmodule
