'''
This file transmits data from the PC to the FPGA and receives data from the FPGA
The functions in the PuTTYHandlers are used to communicate between the PC and the FPGA over a PuTTY session
'''

import PuTTYHandlers
import time

if __name__ == "__main__":
    # Define the port, baudrate and timeout configuration
    port = 'COM11'
    baudrate = '115200'
    timeout = 1
    
    Interface = PuTTYHandlers.PCToFPGAInterface(port, baudrate, timeout)

    # Configure the interface
    Interface.PuTTy_configure()

    # Send data to FPGA over loop
    Interface.send_data_to_FPGA('0')
    time.sleep(5)
    Interface.send_data_to_FPGA('h')
    time.sleep(5)

    print("Transmission complete!")
    
    # Close connection
    Interface.close_connection()
    
