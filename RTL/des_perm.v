module des_perm(
    input[31:0] in,
    output[31:0] out
    );
    
    localparam [0:191] P = {
        6'd16, 6'd7,  6'd20, 6'd21,
        6'd29, 6'd12, 6'd28, 6'd17,
        6'd1,  6'd15, 6'd23, 6'd26,
        6'd5,  6'd18, 6'd31, 6'd10,
        6'd2,  6'd8,  6'd24, 6'd14,
        6'd32, 6'd27, 6'd3,  6'd9,
        6'd19, 6'd13, 6'd30, 6'd6,
        6'd22, 6'd11, 6'd4,  6'd25
    };

    genvar k;
    generate
        for (k = 0; k < 32; k = k + 1) begin : g_p
            assign out[31 - k] = in[32 - P[k*6 +: 6]];
        end
    endgenerate
endmodule