#include <Arduino.h>

const int PIN_RX = 16;
const int PIN_TX = 17;
const int BAUD = 9600;
HardwareSerial FPGA(2);

void setup() {
    Serial.begin(BAUD);
    FPGA.begin(BAUD, SERIAL_8N1, PIN_RX, PIN_TX);
}

void loop() {
    while (Serial.available())
        FPGA.write((uint8_t) Serial.read());

    while (FPGA.available())
        Serial.write((uint8_t) FPGA.read());
}
