module des_encryption(
    input  [63:0] plaintext,
    input  [63:0] key,
    input clk,rst,
    input plian_key_valid,
    output [63:0] ciphertext,
    output cipher_data_valid

  );

  wire [63:0] initial_permuted_data;
  wire [63:0] round_data;

  wire [55:0] permuted_key;
  wire [27:0] initial_c;
  wire [27:0] initial_d;
  wire [55:0] round_key;

  wire [63:0] data_mux_out;
  wire [55:0] key_mux_out;

  wire [4:0]round_number;

  wire mux_sel;
  des_init_perm init_permutation_unit(
    .in_init_perm(plaintext),.out_init_perm(initial_permuted_data)
  );

  des_pc1 pc1_unit(
    .key(key),.pc1_key(permuted_key),.c0(initial_c),.d0(initial_d)
  );

  control control_unit(
    .clk(clk),.rst(rst),.key_valid(plian_key_valid),
    .mux_sel(mux_sel),.data_valid(cipher_data_valid),
    .round_number(round_number)
  );

  mux2_to1#(.DATAWIDTH(64)) data_mux(
    .in0(initial_permuted_data),.in1(round_data),.sel(mux_sel),.out(data_mux_out)
  );

  mux2_to1#(.DATAWIDTH(56)) key_mux(
    .in0({initial_c,initial_d}),.in1(round_key),.sel(mux_sel),.out(key_mux_out)
  );
  des_single_round #(.encryption(1)) round_unit(
    .clk(clk),.rst(rst),
    .in(data_mux_out),.key(key_mux_out),.round_number(round_number),
    .round_data(round_data),.round_key(round_key)
  );

  des_final_perm inverse_permutaion(
    .in({round_data[31:0],round_data[63:32]}),.out(ciphertext)
  );

endmodule
