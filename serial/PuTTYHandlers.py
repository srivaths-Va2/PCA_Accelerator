'''
This file contains functions to transfer data from the Python file to PuTTy over to the FPGA
It also has functions to receive data from the FPGA 

'''

import serial

class PCToFPGAInterface:
    def __init__(self, port, baudrate, timeout):
        self.port = port
        self.baudrate = baudrate
        self.timeout = timeout
    
    def PuTTy_configure(self):
        self.ser = serial.Serial(
            port = self.port, 
            baudrate = self.baudrate, 
            timeout = self.timeout
        )

    def send_data_to_FPGA(self, data_Tx):
        data_to_send = data_Tx + '\n'
        self.ser.write(data_to_send.encode())
    
    def receive_data_from_FPGA(self):
        data_Rx = self.ser.readline().decode('utf-8')
        print('Received Response: ', data_Rx)
    
    def close_connection(self):
        self.ser.close()




''' 
# Configure the serial port
ser = serial.Serial(
    port='COM3',     # Replace with your port (e.g., COM3, /dev/ttyUSB0)
    baudrate=9600,   # Match the baud rate in PuTTY
    timeout=1        # Optional: Timeout for read/write operations
)

# Write data to the serial port
data_to_send = "0\n"
ser.write(data_to_send.encode())

# Optionally, read response
response = ser.readline().decode('utf-8')
print("Received:", response)

# Close the port
ser.close()
'''

