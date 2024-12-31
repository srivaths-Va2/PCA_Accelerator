import serial
import time

class SerialInterface:
    def __init__(self, port, baudrate, timeout, bytesize=serial.EIGHTBITS, parity=serial.PARITY_NONE, stopbits=serial.STOPBITS_ONE):
        self.port = port
        self.baudrate = baudrate
        self.timeout = timeout
        self.bytesize = bytesize
        self.parity = parity
        self.stopbits = stopbits

        try:
            self.ser = serial.Serial(
                port=self.port,
                baudrate=self.baudrate,
                timeout=self.timeout,
                bytesize=self.bytesize,
                parity=self.parity,
                stopbits=self.stopbits
            )
            print(f"Connected to {self.port} at {self.baudrate} baud.")
        except serial.SerialException as e:
            print(f"Error initializing serial connection: {e}")
            self.ser = None

    def transmit_to_FPGA(self, data):
        if self.ser and self.ser.is_open:
            try:
                self.ser.write(data.encode())
                print(f"Sent: {data}")
                time.sleep(3)
            except Exception as e:
                print(f"Error sending data: {e}")
        else:
            print("Serial port is not open or unavailable.")

    def receive_from_FPGA(self):
        if self.ser and self.ser.is_open:
            try:
                if self.ser.in_waiting > 0:
                    received_data = self.ser.readline().decode('utf-8').rstrip()
                    print(f"Received: {received_data}")
                    return received_data
            except Exception as e:
                print(f"Error receiving data: {e}")
        else:
            print("Serial port is not open or unavailable.")
        return None

    def close(self):
        if self.ser and self.ser.is_open:
            self.ser.close()
            print("Serial connection closed.")

# __main__#

port = "COM1"       # Change to the correct port accordingly
baudrate = 115200
timeout = 10

Ser = SerialInterface(port, baudrate, timeout)

# To transmit data
data = 255
Ser.transmit_to_FPGA(data)

# To receive data
Ser.receive_from_FPGA()

# Closing the port
Ser.close()