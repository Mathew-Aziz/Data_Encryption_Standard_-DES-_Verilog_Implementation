module des_right_shift (
    input wire [27:0] c_in,
    input wire [27:0] d_in,
    input wire [ 4:0] round_number,

    output wire [27:0] c_out,
    output wire [27:0] d_out
);

  reg [1:0] shift_amount;

  always @(*) begin
    case (round_number)
      5'd1:shift_amount = 2'd0;
      5'd2, 5'd9, 5'd16: shift_amount = 2'd1;

      5'd3, 5'd4, 5'd5, 5'd6, 5'd7, 5'd8, 5'd10, 5'd11, 5'd12, 5'd13, 5'd14, 5'd15:
      shift_amount = 2'd2;

      default: shift_amount = 2'd0;
    endcase
  end

  assign c_out = (shift_amount == 2'd1)
                 ? {c_in[0],c_in[27:1]}
                 : (shift_amount == 2'd2)
                 ? {c_in[1:0], c_in[27:2]}
                 : c_in;

  assign d_out = (shift_amount == 2'd1)
                 ? {d_in[0],d_in[27:1]}
                 : (shift_amount == 2'd2)
                 ? {d_in[1:0], d_in[27:2]}
                 : d_in;

endmodule
