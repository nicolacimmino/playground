// Bipolar2phStepper implements a controller for a a bipolar 2-phases stepper motor.
//  Copyright (C) 2014 Nicola Cimmino
//
//    This program is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//   This program is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with this program.  If not, see http://www.gnu.org/licenses/.
//

#define COILA_N 2
#define COILA_S 3
#define COILB_N 4
#define COILB_S 5

void setup()
{
  pinMode(COILA_N, OUTPUT);
  pinMode(COILA_S, OUTPUT);
  pinMode(COILB_N, OUTPUT);
  pinMode(COILB_S, OUTPUT);
}

// Coil pulse stimulus direction.
// For a bipolar stepper motor we have two
// opposite energized positions and a neutral
#define PLUS 1
#define MINUS 2
#define NEUTRAL 3

// Rotation direction
#define CW 0
#define CCW 1


void loop()
{ 
  while(1)
  {
    stepMotor(CW, 3);
  }
}

/*
 * Move the motor one step forwad in the supplied 
 * direction. For the time being speedRPM passed
 * is the speed that would be achieved if the 
 * function was called repeatedly with no delay.
 * This is suitable only for testing.
 */
void stepMotor(byte direction, uint8_t speedRPM)
{
    static uint8_t currentStep = 0;

    currentStep=currentStep+((direction==CCW)?-1:1);
    currentStep=currentStep%4;
    uint8_t controlPulseDuration = (speedRPM<=20)?100:30;
    
    switch(currentStep)
    {
       case 0: driveMotor(PLUS, PLUS, controlPulseDuration); break;
       case 1: driveMotor(PLUS, MINUS, controlPulseDuration); break;
       case 2: driveMotor(MINUS, MINUS, controlPulseDuration); break;
       case 3: driveMotor(MINUS, PLUS, controlPulseDuration); break;  
    }
    delay((3000.0f/speedRPM)-controlPulseDuration);
}

/*
 * Drives the motor sending the control pulse specified for
 * the supplied contol pulse duration (in mS).
 */
void driveMotor(byte coilA, byte phaseB, uint8_t controlPulseDuration)
{
    digitalWrite(COILA_N, (coilA==PLUS)?HIGH:LOW);
    digitalWrite(COILA_S, (coilA==MINUS)?HIGH:LOW);
    digitalWrite(COILB_N, (phaseB==PLUS)?HIGH:LOW);
    digitalWrite(COILB_S, (phaseB==MINUS)?HIGH:LOW);
    if(coilA!=NEUTRAL && phaseB!=NEUTRAL)
    {
      delay(controlPulseDuration);
      driveMotor(NEUTRAL,NEUTRAL, 0);
    }
}


