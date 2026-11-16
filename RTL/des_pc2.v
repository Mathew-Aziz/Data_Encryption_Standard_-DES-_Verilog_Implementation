module des_pc2 (
    input wire        clk,
    input wire [27:0] c_in,
    input wire [27:0] d_in,

    output reg [47:0] round_key
);

  wire [55:0] combined_key;

  assign combined_key = {c_in, d_in};

  always @(posedge clk) begin
    round_key <= {
      combined_key[42],
      combined_key[39],
      combined_key[45],
      combined_key[32],
      combined_key[55],
      combined_key[51],

      combined_key[53],
      combined_key[28],
      combined_key[41],
      combined_key[50],
      combined_key[35],
      combined_key[46],

      combined_key[33],
      combined_key[37],
      combined_key[44],
      combined_key[52],
      combined_key[30],
      combined_key[48],

      combined_key[40],
      combined_key[49],
      combined_key[29],
      combined_key[36],
      combined_key[43],
      combined_key[54],

      combined_key[15],
      combined_key[4],
      combined_key[25],
      combined_key[19],
      combined_key[9],
      combined_key[1],

      combined_key[26],
      combined_key[16],
      combined_key[5],
      combined_key[11],
      combined_key[23],
      combined_key[8],

      combined_key[12],
      combined_key[7],
      combined_key[17],
      combined_key[0],
      combined_key[22],
      combined_key[3],

      combined_key[10],
      combined_key[14],
      combined_key[6],
      combined_key[20],
      combined_key[27],
      combined_key[24]
    };
  end

endmodule
