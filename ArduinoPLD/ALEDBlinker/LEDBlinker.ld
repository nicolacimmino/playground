LDmicro0.1
MICRO=ANSI C Code
CYCLE=10000
CRYSTAL=4000000
BAUD=2400
COMPILED=C:\Users\nicola\Documents\git\playground\ArduinoPLD\ALEDBlinker\LEDBlinker.cpp

IO LIST
    X1 at 0
    Y1 at 0
END

PROGRAM
RUNG
    CONTACTS Rosc 0
    TON TdelayOn 100000
    TOF TdelayOff 400000
    COIL Rosc 1 0 0
END
RUNG
    CONTACTS X1 0
    CTC Cstatus 2
END
RUNG
    PARALLEL
        EQU Cstatus 1
        SERIES
            EQU Cstatus 2
            CONTACTS Rosc 0
        END
    END
    COIL Y1 0 0 0
END
