This example generates a C7 chord notes. The "SW1" is read and used to change of note sequentially. A 4 to 1 multiplexer is used to select the output among the 4 notes, whihc have been created using dividers.

# Material

+ [Alhambra II board](https://alhambrabits.com/alhambra/)
+ [Buzzer](https://www.digikey.es/products/es?keywords=1910-PIS-1278-ND%20)

# Pinout

+ Alhambra D0 (pin 2 of the package) => buzzer signal generator. As the buzzer has a three pin connector, I have attached the cable to the D0 row of the male connectors, providing it the signal and the feeding voltage.
+ The source clock is the pin 49, where the oscillator is attached.
+ SW1 is used to select the note created by the buzzer.

_Note: You need to turn on the `I/O PWR` switch!_
