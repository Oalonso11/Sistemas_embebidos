module full_subtractor(
    input wire A,
    input wire B,
    input wire Bin,
    output wire D,
    output wire Bout
);

    // D = A XOR B XOR Bin (Diferencia)
    assign D = A ^ B ^ Bin;
    
    // Bout = (~A & B) | (~A & Bin) | (B & Bin) 
    assign Bout = (~A & B) | (~A & Bin) | (B & Bin);

endmodule