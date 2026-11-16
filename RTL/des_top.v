module des_top (
    input  [63:0] plaintext,
    input  [63:0] key,
    output [63:0] ciphertext
);

  wire [63:0] initial_permuted_data;
  wire [31:0] initial_left;
  wire [31:0] initial_right;

  wire [55:0] permuted_key;
  wire [27:0] initial_c;
  wire [27:0] initial_d;
  wire [27:0] shifted_c;
  wire [27:0] shifted_d;
  wire [47:0] round_key;

  wire [31:0] round_left [0:16];
  wire [31:0] round_right [0:16];
  wire [63:0] preoutput_data;

endmodule
