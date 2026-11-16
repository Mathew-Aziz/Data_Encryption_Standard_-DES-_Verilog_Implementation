module des_final_perm (
    input  [63:0] in,
    output [63:0] out
);

  genvar k;
  generate
    for (k = 0; k < 64; k = k + 1) begin : g_fp
      localparam ROW = k / 8;  // 0..7, output row
      localparam COL = k % 8;  // 0..7, position in row
      localparam BYTE = (COL % 2 == 0) ? (4 + COL / 2) : (COL / 2);  // byte order 4,0,5,1,6,2,7,3
      localparam SRCPOS = 8 * BYTE + (8 - ROW);  // DES input position 1..64
      assign out[63-k] = in[64-SRCPOS];
    end
  endgenerate

endmodule
