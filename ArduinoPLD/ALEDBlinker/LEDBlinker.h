/* This is autogenerated code. */

/* (generated Wed, 27 Aug 2014 15:22:36 +0200 by ladder-gen v 1.0) */

#ifndef LEDBLINKER_H
#define LEDBLINKER_H

#if ARDUINO >= 100
    #include "Arduino.h"   
#else
    #include "WProgram.h"
#endif

#define BOOL boolean
#define SWORD int

#define EXTERN_EVERYTHING
#define NO_PROTOTYPES

void PlcCycle(void);

/* Configure digital I/O according to LD (call this in setup()). */

inline void PlcSetup() 
{
  
  pinMode(10, OUTPUT);
  pinMode(9, INPUT);
  digitalWrite(9, HIGH);
}


/* Individual pins (this code is used in ladder.cpp) */

inline extern BOOL Read_U_b_X1(void)
{
   return digitalRead(9)!=0;
}


inline void Write_U_b_Y1(BOOL v)
{
    digitalWrite(10, v);
}


#endif
