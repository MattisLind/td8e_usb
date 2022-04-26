# td8e_usb
Emulating the TD8E controller and connect to a host over USB

This project is to be able to connect to a host over USB and be able to read and write Dectapes on either a TU55 or a TU56 drive.

A CPLD is taking care of the generation of clocksignals and capturing the data and latching the data when writing. A STM32F103 uC will assemble the data into blocks which is transfered to and from the host over USB.

The CPLD is a Xilinx XC2C64 in a 44 pin package. 

The interface towards the drive will be TD8E compatible. 

## TD8E interface

### M868 board connector layout

|   Pin   |   Function |
|---------|------------|
|    A    |   GND      |
|    B    |   GND      |
|    C    |   GND      |
|    D    |   RD00     |
|    E    |   GND      |
|    F    |   RMT      |
|    H    |   GND      |
|    J    |   /RTT     |
|    K    |   GND      |
|    L    |   RD01     |
|    M    |   GND      |
|    N    | SEL_ECHO   |
|    P    |   GND      |
|    R    |    NC      |
|    S    |   GND      |
|    T    | WRT_ECHO   |
|    U    |   GND      |
|    V    |  RD02      |
|    W    |   GND      |
|    X    |   ND2      |
|    Y    |   GND      |
|    Z    |  WD_ENAB   |
|    AA   |   GND      |
|    BB   |   WPT      |
|    CC   |   GND      |
|    DD   |   ND1      |
|    EE   |   GND      |
|    FF   |   ND0      |
|    HH   |   GND      |
|    JJ   |   S/G\     |
|    KK   |   GND      |
|    LL   | UNITH      |
|    MM   |   GND      |
|    NN   | T/M ENABLE |
|    PP   |   GND      |
|    RR   | CON_ALL_HALT|
|    SS   |   GND      |
|    TT   |   F/R\     |
|    UU   |   GND      |
|    VV   |   GND      |
