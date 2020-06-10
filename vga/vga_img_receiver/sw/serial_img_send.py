import serial
import sys

print(sys.argv[1], sys.argv[2])
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
#ser.open()
print("Serial open?", end =" ")
print(bool(ser.is_open))
f = open(file, "rb")
byte = f.read(1)
while byte:
    #print(byte)
    byte = f.read(1)
    if byte != '\n' :
        print(byte)
        ser.write(byte)
        ser.flush()
print("Image sent, closing port and exiting...\n")
ser.close()
