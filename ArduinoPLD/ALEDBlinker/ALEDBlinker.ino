
#include "LEDBlinker.h"

void setup() {
    PlcSetup();
}

void loop() {
    PlcCycle();
    delay(10);
}
