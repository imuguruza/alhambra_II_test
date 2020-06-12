import serial
import sys
from time import sleep

if len(sys.argv) < 3 :
    print ("Usage: Serial port, image file in hex format. For example: /dev/ttyUSB0 test.mem")
dev = sys.argv[1]
#print(dev)
file = sys.argv[2]

ser = serial.Serial(
	port=dev,
	baudrate=115200,
	parity= serial.PARITY_NONE,
	stopbits=serial.STOPBITS_TWO,
	bytesize=serial.EIGHTBITS
)
ser.reset_output_buffer()

print("Serial open?", end =" ")
print(bool(ser.is_open))
count = 0;

with open(file, "r") as hexfile:
    hexlist = hexfile.readlines()

for hexval in hexlist:
    #print(bytes.fromhex(hexval[:2]))
    ser.write(bytes.fromhex(hexval[:2]))
    count += 1
    #sleep(0.001)

print (str(count) + " bytes sent...")
print("Image sent, closing port and exiting...\n")
ser.close()
