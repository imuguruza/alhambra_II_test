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
#ser.open()
ser.reset_output_buffer()
print("Serial open?", end =" ")
print(bool(ser.is_open))
count = 0;

# Problem => ff is sent 0f - 0f
# f = open(file, "rb")
# byte = f.read(3).replace(b'\n', b'')
# #ser.flush()
# while byte:
#     ser.write(byte)
#     print(byte)
#     sleep(0.01)
#     count += 1
#     byte = f.read(3).replace(b'\n', b'')


# Try to read as string and convert to Hex after
# This sends just 0s
f = open(file, "r")
byte = f.read(3).replace('\n', '')
#ser.flush()
while byte:
    send = int(byte,16)
    #print (send)
    ser.write(send)
    #print(int(byte,16))
    sleep(0.01)
    count += 1
    byte = f.read(3).replace('\n', '')

print (str(count) + " bytes sent...")
print("Image sent, closing port and exiting...\n")
ser.close()
