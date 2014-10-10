// Synthesizer implements a MIDI controllable synthetizer.
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

// We make use of the MIDI library (http://arduinomidilib.sourceforge.net)
#include <MIDI.h>
#include <midi_Defs.h>
#include <midi_Message.h>
#include <midi_Namespace.h>
#include <midi_Settings.h>

#define MAX_VOICES 3
#define OUTPUT_MARGIN_BITS 4
#define SAWTOOTH 1
#define TRIANGLE 2
#define PULSE 4
#define NOISE 8

#define MIDI_CHANNEL 1

// We sample output with a 32KHz frequency which is
// almost five times above nyqist for the highest expected
// frequency (4KHz). This should keep aliasing at a minimum.
// 
#define OUTPUTSAMPLEFREQUENCY 16000L

// (F_CPU/(8*OUTPUTSAMPLEFREQUENCY)-1)
#define OUTPUTSAMPLESCOUNT 124

// 62/(OUTPUTSAMPLEFREQUENCY/16000L)
#define DDS_CYCLES_PER_SAMPLE 62

// Creates an instance of the MIDI controller.
MIDI_CREATE_DEFAULT_INSTANCE();

uint32_t phase_accumulator[MAX_VOICES];

uint32_t dds_frequency_increment[MAX_VOICES];

uint16_t envelope_setting[MAX_VOICES];

uint16_t envelope_index[MAX_VOICES];

byte waveform_selector[MAX_VOICES];

uint16_t output_signal = 0;

uint16_t noise = 0xACE1;

// The currently playing note in each of the voices.
byte voiceNotes[MAX_VOICES];

void setup()
{
  for(int v=0;v<MAX_VOICES;v++)
  {
    voiceNotes[v]=0;
    waveform_selector[v]=0;
  }
    
  pinMode(9, OUTPUT);
 
  setupInterrupts();

   // Register callbacks for MIDI events.
  MIDI.setHandleNoteOn(handleNoteOn);
  MIDI.setHandleNoteOff(handleNoteOff);
  //MIDI.setHandleSystemExclusive(handleSystemExclusive);
  //MIDI.setHandleControlChange(handleControlChange);
  MIDI.begin();
  
}

void loop()
{ 
  // Process next MIDI command if any.
  MIDI.read();
}

void setupInterrupts()
{
        // We use TIMER1 for the audio autput. We do the A/D conversion
        // driving a pin at high frequency PWM and setting the PWM value
        // according to the desired output level. We make use of the 10 bits
        // PWM to increase the dynamic range give the high amount of voices
        // summed into the output.
        //
        // WGM10,11,12 set -> Fast PWM 10 bits
        // CS10 set -> no prescaling on the timer clock
	TCCR1A = (1 << WGM10) | (1 << WGM11) |  (1 << COM1A1) ; 
	TCCR1B = (1 << WGM12) | (1 << CS10);	
		
        // TIMER2 is used to generated an interrupt at OUTPUTSAMPLEFREQUENCY
        // CS21 set -> prescale counter clock /8
	TCCR2A = 0 ;
	TCCR2B = (1 << CS21);
	OCR2A = OUTPUTSAMPLESCOUNT;
	
	// Enable TIMER2 Output Compare interrup
        TIMSK2 = (1 << OCIE2A);
	
	// Enable TIMER1 overflow.	
	TIMSK1 = (1 << TOIE1);

}

ISR(TIMER1_OVF_vect)
{
  OCR1A = output_signal; // Output to PWM
}

/*
 * This Interrupt Service Routine is invoked at OUTPUTSAMPLEFREQUENCY
 * interval. Here we recalculate the output level processing all 
 * oscialltors and filters.
 */
ISR(TIMER2_COMPA_vect)
{
  OCR2A += OUTPUTSAMPLESCOUNT;
  
  clockDDS();
}

void clockDDS()
{

  // noise generator based on Galois LFSR
  // This is based on the SID noise generator from (http://code.google.com/p/sid-arduino-lib/)
  // Might change it to something that allows to color the noise.
  noise = (noise >> 1) ^ (-(noise & 1) & 0xB400u);
  
  output_signal=0;
  for(int v=0; v<MAX_VOICES; v++)
  {
    phase_accumulator[v]+=dds_frequency_increment[v];
    phase_accumulator[v]=phase_accumulator[v]&0xFFFFFF;
    
    output_signal+=(phase_accumulator[v]>>18)*((waveform_selector[v]&SAWTOOTH)?1:0);
    output_signal+=(abs((int32_t)phase_accumulator[v]-0x8FFFFF)>>(14+OUTPUT_MARGIN_BITS))*((waveform_selector[v]&TRIANGLE)?1:0);
    output_signal+=(noise>>8)*((waveform_selector[v]&NOISE)?1:0);
  }
  
}

// This will be invoked by the MIDI library every time we receive
//  a NoteOn command.
//
void handleNoteOn(byte inChannel, byte inNote, byte inVelocity)
{
  if(inChannel != MIDI_CHANNEL)
  {
    return;
  }
  
  // Alternate mode in MIDI to give noteoff is to pass the note with velocity zero.
  if(inVelocity==0)
  {
    handleNoteOff(inChannel, inNote, inVelocity);  
    return;
  }
  
  // Find a free voice to play this note
  for(int v=0; v<MAX_VOICES; v++)
  {
    if(voiceNotes[v]==0)
    {
      // We first convert the MIDI note to a frequency and then that
      //  to the suitable SID registers value.
      double frequency = getNoteFrequency(inNote);
      dds_frequency_increment[v]=frequency*16.777*DDS_CYCLES_PER_SAMPLE;
      waveform_selector[v]=TRIANGLE;
      
      // Store the note that is being played in this voice.
      voiceNotes[v] = inNote;      
      break;
    }
  }
 
}

// This will be invoked by the MIDI library every time we receive
//  a NoteOff command.
//
void handleNoteOff(byte inChannel, byte inNote, byte inVelocity)
{ 
  if(inChannel != MIDI_CHANNEL)
  {
    return;
  }
  
  // Find the voice that is playing this note
  for(int v=0; v<MAX_VOICES; v++)
  {
    if(voiceNotes[v]==inNote)
    {
      waveform_selector[v]=0;
      dds_frequency_increment[v]=0;
      
      // The voice is now free.
      voiceNotes[v] = 0;    
    
      break;  
    }
  }
}

// This is a table used to convert MIDI notes numbers to frequency.
// This is the first octave (notes 0 to 11). The following octaves
// can be calculated.
double note_freq_lookup[] = {
 8.1757989156,
 8.6619572180, 
 9.1770239974, 
 9.7227182413, 
 10.3008611535, 
 10.9133822323, 
 11.5623257097, 
 12.2498573744, 
 12.9782717994, 
 13.7500000000, 
 14.5676175474,
 15.4338531643 };

double pow_2_lookup[] = { 1, 2, 4, 8, 16, 32, 64, 128, 256, 512 };

// Gets the frequency, in Hz, of a note given the MIDI note number.
double getNoteFrequency(byte note)
{
  int octave=floor(((double)(note))/12.0f);
  return note_freq_lookup[note-(12*octave)]*pow_2_lookup[octave]; 
}

 

