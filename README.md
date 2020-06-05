# td8e_usb
Emulating the TD8E controller and connect to a host over USB

This project is to be able to connect to a host over USB and be able to read and write Dectapes on either a TU55 or a TU56 drive.

A CPLD is taking care of the generation of clocksignals and capturing the data and latching the data when writing. A STM32F103 uC will assemble the data into blocks which is transfered to and from the host over USB.

The CPLD is a Xilinx XC2C64 in a 44 pin package. 

The interface towards the drive will be TD8E compatible. 
