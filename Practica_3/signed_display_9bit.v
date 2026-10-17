module signed_display_9bit (
    input wire signed [8:0] value,
    output wire [6:0] HEX0,
    output wire [6:0] HEX1,
    output wire [6:0] HEX2,
    output wire [6:0] HEX3
);
    // Magnitud sin signo de 9 bits: permite representar abs(-256) = 256.
    wire [8:0] magnitude = value[8] ? -value : value;
    wire [3:0] hundreds = magnitude / 9'd100;
    wire [3:0] tens     = (magnitude % 9'd100) / 9'd10;
    wire [3:0] ones     = magnitude % 9'd10;

    // Codigos activos en bajo para HEX de DE10-Lite: bit 6 = g, bit 0 = a.
    function [6:0] seg7;
        input [3:0] digit;
        begin
            case (digit)
                4'd0: seg7 = 7'b1000000;
                4'd1: seg7 = 7'b1111001;
                4'd2: seg7 = 7'b0100100;
                4'd3: seg7 = 7'b0110000;
                4'd4: seg7 = 7'b0011001;
                4'd5: seg7 = 7'b0010010;
                4'd6: seg7 = 7'b0000010;
                4'd7: seg7 = 7'b1111000;
                4'd8: seg7 = 7'b0000000;
                4'd9: seg7 = 7'b0010000;
                default: seg7 = 7'b1111111;
            endcase
        end
    endfunction

    assign HEX0 = seg7(ones);
    assign HEX1 = seg7(tens);
    assign HEX2 = seg7(hundreds);
    assign HEX3 = value[8] ? 7'b0111111 : 7'b1111111;
endmodule
