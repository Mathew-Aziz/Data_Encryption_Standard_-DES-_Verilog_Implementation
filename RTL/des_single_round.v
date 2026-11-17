module des_single_round#(parameter encryption = 1)  (
    input clk,rst,
    input  wire [63:0] in,
    input  wire [55:0] key,
    input  wire [4:0] round_number,
    output reg [63:0] round_data,
    output reg [55:0] round_key
);

  wire [47:0] expanded_right;
  wire [47:0] expand_xor_key;
  wire [47:0] perm_round_key;

  wire [31:0] perm_xor_left;
  wire [31:0] substituted_right;
  wire [31:0] feistel_result;

  wire [31:0] L0,R0; 
  wire [31:0] L1,R1;

  wire [27:0] key_c0,key_d0;
  wire [27:0] key_c1,key_d1;



  assign L0 = in [63:32];
  assign R0 = in [31:0];
  

  assign key_c0 = key[55:28];
  assign key_d0 = key[27:0];

  generate
    if(encryption)begin
      des_left_shift round_left_shift_unit(
      .c_in(key_c0),.d_in(key_d0),
      .round_number(round_number),
      .c_out(key_c1),.d_out(key_d1)
      );
    end else begin
      des_right_shift round_right_shift_unit(
      .c_in(key_c0),.d_in(key_d0),
      .round_number(round_number),
      .c_out(key_c1),.d_out(key_d1)
      );
    end
  endgenerate  

  des_pc2 pc2_unit(
    .c_in(key_c1),.d_in(key_d1),.perm_round_key(perm_round_key)
  );

  des_exp_perm expand_unit(
    .in(R0),.out(expanded_right)
  );

  assign expand_xor_key = perm_round_key ^ expanded_right;

  des_sbox sbox_unit(
    .in(expand_xor_key),.out(substituted_right)
  );

  des_perm permutaion_unit(
    .in(substituted_right),.out(feistel_result)
  );

  assign perm_xor_left = feistel_result ^ L0;

  assign R1 = perm_xor_left;
  assign L1 = R0;

  always @(posedge clk,negedge rst) begin
    if (!rst) begin
      round_data<=0;
      round_key<=0;
    end else begin
      round_data [63:32] <= L1;
      round_data [31:0] <= R1;

      round_key <= {key_c1,key_d1};
    end
  end
endmodule
