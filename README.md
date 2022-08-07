# td8e_usb
Emulating the TD8E controller and connect to a host over USB

This project is to be able to connect to a host over USB and be able to read and write Dectapes on either a TU55 or a TU56 drive.

A CPLD is taking care of the generation of clocksignals and capturing the data and latching the data when writing. A STM32F103 uC will assemble the data into blocks which is transfered to and from the host over USB.

The CPLD is a Xilinx XC2C64 in a 44 pin package. 

The interface towards the drive will be TD8E compatible. 

## TD8E interface


| Pin |   DEC Pin   |   Function M868 |  TD8E databoard |
|-----|---------|------------|----------------------|
|  1  |    A    |   GND      |    GND               |
|  2  |    B    |   GND      |    GND               |           
|  3  |    C    |   GND      |    GND               |
|  4  |    D    |   RD00     |    RD0            |
|  5  |    E    |   GND      |    GND            |
|  6  |    F    |   RMT      |    RMT             |
|  7  |    H    |   GND      |    GND             |
|  8  |    J    |   RTT\     |    RTT            |
|  9  |    K    |   GND      |    GND              |
|  10  |    L    |   RD01     |    RD1            |
|  11  |    M    |   GND      |    GND            |
|  12  |    N    | SEL_ECHO   |  SEL_ECHO            |
|  13  |    P    |   GND      |    GND            |
|  14  |    R    |    NC      |    NC            |
|  15  |    S    |   GND      |    GND            |
|  16  |    T    | WRT_ECHO   | WRT_ECHO            |
|  17  |    U    |   GND      |    GND            |
|  18  |    V    |  RD02      |  RD2            |
|  19  |    W    |   GND      |   GND            |
|  20  |    X    |   ND2      | WD2(1)            |
|  21  |    Y    |   GND      |  GND            |
|  22  |    Z    |  WD_ENAB   | WD_ENAB_TD8E            |
|  23  |    AA   |   GND      |   GND            |
|  24  |    BB   |   WPT      |   WTT(1)            |
|  25  |    CC   |   GND      |   GND            |
|  26  |    DD   |   ND1      |   WD1(1)            |
|  27  |    EE   |   GND      |   GND            |
|  28  |    FF   |   ND0      |   WD2(1)            |
|  29  |    HH   |   GND      |   GND            |
|  30  |    JJ   |   S/G\     |  S/G(0)\_H            |
|  31  |    KK   |   GND      |   GND            |
|  32  |    LL   | UNITH      |UNIT(1)H            |
|  33  |    MM   |   GND      |  GND             |
|  34  |    NN   | T/M ENABLE | T/M_ENAB_L            |
|  35  |    PP   |   GND      |   GND            |
|  36  |    RR   | CON_ALL_HALT| CON_ALL_HALT_L            |
|  37  |    SS   |   GND      |   GND             |
|  38  |    TT   |   F/R\     |  F/R(0)\_H            |
|  39  |    UU   |   GND      |   GND            |
|  40  |    VV   |   GND      |   WMT(1) *              |


(\*) This signal us not TD8E but used when interfacing with TC11 or TC08.

## WRT_ECHO

WRT_ECHO is driven by a PNP open collctor cricuit in the TU55/TU56 drive. It is supposed to be connected to a negative pull down. The logic levels are then either 0V or the negative supply voltage. This then give a need for a negative supply to detect this logic level. An opto-coupler is an easy method of doing the level translation. 

## SEL_ECHO

SEL_ECHO is driven by a PNP open collector via a 100 ohm resistrior in the TU55/TU56 drive. All the SEL_ECHO is wired together and in the TD8E control there is a 500 ohm resistor connected to -15 V potential. A analogue voltage will develop that corresponds to the number of drives selected. Thereby indicating a selection fault if certain analogue voltage are detected.

The TD8E inteface only has a the ability to select among two drives by setting the UNIT signal either 0 or 1. This means that the voltage developed will be either -15 indicating no selected drive, One drive selected should give about -2.5 volt. Two simultaneously selected drives give voltage arroun -1.36V. In practical terms it is not really necessary to have this kind of detection logic.

Originally the circuitry to detect this was two long tailed pairs acting as comparators and then som wire-logic to create the logic function. In moderna day it is perhaps better to use an inverting amplifier and push the signal into the A/D of the microcontroller. Nevertheless there is still a need for a -15 V supply able to supply 50 mA.

By dropping the voltage down to -5V or even -3.3V only around 20 mA is required. Then a MAX868 could solve the problem. Then a dual opamp could be used in inverting configuration to condition the signal for the A/D converter in the microcontroller.
