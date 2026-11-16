module des_init_perm (
    input [63:0] in_init_perm,
    output [63:0] out_init_perm
);

  assign out_init_perm = {
      in_init_perm[6],
      in_init_perm[14],
      in_init_perm[22],
      in_init_perm[30],
      in_init_perm[38],
      in_init_perm[46],
      in_init_perm[54],
      in_init_perm[62],

      in_init_perm[4],
      in_init_perm[12],
      in_init_perm[20],
      in_init_perm[28],
      in_init_perm[36],
      in_init_perm[44],
      in_init_perm[52],
      in_init_perm[60],

      in_init_perm[2],
      in_init_perm[10],
      in_init_perm[18],
      in_init_perm[26],
      in_init_perm[34],
      in_init_perm[42],
      in_init_perm[50],
      in_init_perm[58],

      in_init_perm[0],
      in_init_perm[8],
      in_init_perm[16],
      in_init_perm[24],
      in_init_perm[32],
      in_init_perm[40],
      in_init_perm[48],
      in_init_perm[56],

      in_init_perm[7],
      in_init_perm[15],
      in_init_perm[23],
      in_init_perm[31],
      in_init_perm[39],
      in_init_perm[47],
      in_init_perm[55],
      in_init_perm[63],

      in_init_perm[5],
      in_init_perm[13],
      in_init_perm[21],
      in_init_perm[29],
      in_init_perm[37],
      in_init_perm[45],
      in_init_perm[53],
      in_init_perm[61],

      in_init_perm[3],
      in_init_perm[11],
      in_init_perm[19],
      in_init_perm[27],
      in_init_perm[35],
      in_init_perm[43],
      in_init_perm[51],
      in_init_perm[59],

      in_init_perm[1],
      in_init_perm[9],
      in_init_perm[17],
      in_init_perm[25],
      in_init_perm[33],
      in_init_perm[41],
      in_init_perm[49],
      in_init_perm[57]
  };
endmodule
//To get the halfs for the first round
//wire [31:0] L0 = out_init_perm[63:32];
//wire [31:0] R0 = out_init_perm[31:0];
