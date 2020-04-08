This example creates four soounds using multiple dividers and a multiplexer. The multiplexer selects sequentially the different outputs. For that purpose, a counter has been created.

# Material

+ [Alhambra II board](https://alhambrabits.com/alhambra/)
+ [Buzzer](https://www.digikey.es/products/es?keywords=1910-PIS-1278-ND%20)

# Pinout

+ Alhambra D0 (pin 2 of the package) => buzzer signal generator. As the buzzer has a three pin connector, I have attached the cable to the D0 row of the male connectors, providing it the signal and the feeding voltage.
+ The source clock is the pin 49, where the oscillator is attached.

_Note:You need to turn on the `I/O PWR` switch!_
