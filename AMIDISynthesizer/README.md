A polyfonic MIDI synthesizer based on an Arduino.

I have been attempting this project, after the SID emulator based Synth, with an idea to explore in mode detail music synthesis and in particular DDS and digital filters. The rough plan was to have several voices, perhaps 16 or more, envelope generators, LFOs and digitally controlled filters and, of course a MIDI interface. A bonus add on wuold have been a waveform generator, for at least some voices to generate more rich sounds. 

This code, which is not final, was a first attempt to get a rough idea of the processing power needed. Since it really doesn't do much useful or proper it has been left here in the playground as reference.

Timing and code analysis showed that, on an ATMega328, resources are barely enough for 3 voices and the MIDI interface without too many other features. DDS calculations take too long over 3 voices, at least at 32KHz sample rate. There is surely some optimization that can be done in the calculations, and this could be an interesting topic to detail in future.

I have decided, anyhow, to bring forward this project using a Teensy 3.1 with an Audio extension board as, even optimizing the few operations in the current DDS it doesn't seem realistic to fit also the digitally controlled filters and many more voices. The Teensy 3.1 has a Cortex-M4 processor running at 72MHz and has 64K of RAM so it seems more in line with the needs of this project.

I might in future still mangle with this project to see how much I can get out of an ATMega328, but for now I am more interested in getting to know the Teensy.

