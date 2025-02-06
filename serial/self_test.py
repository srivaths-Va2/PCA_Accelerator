import SerialInterfaceHandlers

# Self-test script with loopback
if __name__ == "__main__":
    port = "loop://"  # Use PySerial's loopback feature
    baudrate = 115200
    timeout = 1

    Ser = SerialInterfaceHandlers.SerialInterface(port, baudrate, timeout)

    # Transmit data
    test_data = "Hello, FPGA!"
    Ser.transmit_to_FPGA(test_data)

    # Receive data
    received_data = Ser.receive_from_FPGA()

    # Validate the loopback communication
    if received_data == test_data:
        print("Loopback test successful!")
    else:
        print("Loopback test failed.")

    # Close the port
    Ser.close()
