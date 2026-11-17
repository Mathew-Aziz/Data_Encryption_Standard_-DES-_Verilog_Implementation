module control#(parameter encryption =1)(
    input clk,rst,
    input key_valid,
    output mux_sel,
    output data_valid,
    output reg [4:0] round_number
);
    reg[4:0] cur_state,next_state;

    localparam  R1=4'b0000,R2=4'b0001,R3=4'b0010,R4=4'b0011,
                R5=4'b0100,R6=4'b0101,R7=4'b0110,R8=4'b0111,
                R9=4'b1000,R10=4'b1001,R11=4'b1010,R12=4'b1011,
                R13=4'b1100,R14=4'b1101,R15=4'b1110,R16=4'b1111,
                valid_out=5'b10000;
    
    
    always @(posedge clk,negedge rst) begin
        if(!rst)begin
            cur_state <=R1;
            next_state <=R1;    
        end else begin
            cur_state <= next_state;
        end
    end

    always @(*) begin
        next_state = R1;
        case (cur_state)
            R1:next_state = key_valid? R2:R1;
            R2:next_state = R3;
            R3:next_state = R4;
            R4:next_state = R5;
            R5:next_state = R6;
            R6:next_state = R7;
            R7:next_state = R8;
            R8:next_state = R9;
            R9:next_state = R10;
            R10:next_state = R11;
            R11:next_state = R12;
            R12:next_state = R13;
            R13:next_state = R14;
            R14:next_state = R15;
            R15:next_state = R16;
            R16:next_state = valid_out;
            valid_out:next_state = R1;
            default:next_state = R1; 
        endcase
    end

    always @(*) begin
        round_number = 1;
        case (cur_state)
            R1:round_number = 1;
            R2:round_number = 2;
            R3:round_number = 3;
            R4:round_number = 4;
            R5:round_number = 5;
            R6:round_number = 6;
            R7:round_number = 7;
            R8:round_number = 8;
            R9:round_number = 9;
            R10:round_number = 10;
            R11:round_number = 11;
            R12:round_number = 12;
            R13:round_number = 13;
            R14:round_number = 14;
            R15:round_number = 15;
            R16:round_number = 16;
            default:round_number = 1;
        endcase
    end

    assign mux_sel = (cur_state == R1)? 0:1;
    assign data_valid = (cur_state == valid_out)? 1:0;
endmodule