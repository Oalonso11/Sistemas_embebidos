`timescale 1ns/1ps

module tb_alu;

    reg  signed [4:0] A;
    reg  signed [4:0] B;
    reg         [1:0] Sel;
    wire signed [9:0] Y;

    integer errores;

    alu DUT (
        .A(A),
        .B(B),
        .Sel(Sel),
        .Y(Y)
    );

    task probar;
        input signed [4:0] a_test;
        input signed [4:0] b_test;
        input [1:0] sel_test;
        input signed [9:0] esperado;
        begin
            A = a_test;
            B = b_test;
            Sel = sel_test;
            #10;

            if (Y === esperado)
                $display("OK    A=%0d B=%0d Sel=%b -> Y=%0d", A, B, Sel, Y);
            else begin
                $display("ERROR A=%0d B=%0d Sel=%b -> Y=%0d, esperado=%0d",
                         A, B, Sel, Y, esperado);
                errores = errores + 1;
            end
        end
    endtask

    initial begin
        errores = 0;
        A = 0;
        B = 0;
        Sel = 0;
        #10;

        // Casos solicitados en la practica
        probar( 5'sd5,   5'sd3,  2'b00,  10'sd8 );
        probar( 5'sd7,  -5'sd2,  2'b00,  10'sd5 );
        probar( 5'sd8,   5'sd3,  2'b01,  10'sd5 );
        probar( 5'sd4,   5'sd6,  2'b01, -10'sd2 );
        probar( 5'sd3,   5'sd4,  2'b10,  10'sd12);
        probar(-5'sd3,   5'sd4,  2'b10, -10'sd12);

        // Casos extra para comprobar signo y limites
        probar( 5'sd15,  5'sd15, 2'b00,  10'sd30);
        probar(-5'sd16, -5'sd16, 2'b00, -10'sd32);
        probar( 5'sd7,  -5'sd2,  2'b01,  10'sd9 );
        probar(-5'sd16,  5'sd15, 2'b01, -10'sd31);
        probar(-5'sd16, -5'sd16, 2'b10,  10'sd256);
		
		// Easter egg
        probar( 5'sd0,   5'sd0,  2'b11,  10'sd123);

        if (errores == 0)
            $display("TODAS LAS PRUEBAS PASARON");
        else
            $display("PRUEBAS FALLIDAS: %0d", errores);

        $finish;
    end

endmodule
