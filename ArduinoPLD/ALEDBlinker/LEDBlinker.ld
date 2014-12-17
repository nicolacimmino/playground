LDmicro0.1
MICRO=ANSI C Code
CYCLE=10000
CRYSTAL=20000000
BAUD=2400
COMPILED=C:\Users\nicola\Documents\test.c

IO LIST
    XD12 at 0
    YD13 at 0
END

PROGRAM
RUNG
    CONTACTS RflashOsc 0
    TON Tosc_on 250000
    TOF Tosc_off 750000
    COIL RflashOsc 1 0 0
END
RUNG
    CONTACTS XD12 0
    CTC CLEDstate 2
END
RUNG
    PARALLEL
        EQU CLEDstate 1
        SERIES
            EQU CLEDstate 2
            CONTACTS RflashOsc 0
        END
    END
    COIL YD13 0 0 0
END
