clear; clc;

PORT = "COM3";
BAUD = 9600;
s = serialport(PORT, BAUD, "Timeout", 1);
pause(2);
flush(s);

disp("UART bidireccional: FPGA devuelve byte + 1");
disp("Presiona Ctrl+C para terminar");

while true
    valor = input('Numero entre 0 y 255: ');
    if ~isscalar(valor) || ~isnumeric(valor) || ~isfinite(valor) || ...
            valor ~= fix(valor) || valor < 0 || valor > 255
        disp('Valor fuera de rango');
        continue;
    end

    flush(s, "input");
    write(s, uint8(valor), "uint8");

    t = tic;
    while s.NumBytesAvailable < 1 && toc(t) < 1
        pause(0.005);
    end

    if s.NumBytesAvailable > 0
        respuesta = double(read(s, 1, "uint8"));
        esperado = mod(valor + 1, 256);
        fprintf('Enviado: %d | Recibido: %d | Esperado: %d\n', ...
                valor, respuesta, esperado);
        if respuesta == esperado
            disp('OK');
        else
            disp('Respuesta inesperada');
        end
    else
        fprintf('Enviado: %d | Sin respuesta\n', valor);
    end
end
