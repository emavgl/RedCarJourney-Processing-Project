#include <SoftwareSerial.h>

/* DIO used to communicate with the Bluetooth module's TXD pin */
#define BT_SERIAL_TX_DIO 4
/* DIO used to communicate with the Bluetooth module's RXD pin */
#define BT_SERIAL_RX_DIO 2

/* Initialise the software serial port */
SoftwareSerial BluetoothSerial(BT_SERIAL_TX_DIO, BT_SERIAL_RX_DIO);

/*
AT responds OK 
AT+BAUDn where n=1 ... C (1=1200, 2=2400, 3=4800, 4=9600 (default), 5=19200, 6=38400, 7=57600, 8=115200, 9=230400, A=460800, B=921600, C=1382400). Responds OKnnnn. Retained across power offs. 
AT+NAMEname where name 20 or fewer characters. Responds OKname. Retained across power offs. 
AT+PINnnnn sets the pairing password. Responds OKsetpin. 
AT+Pn where n is N (no parity), O (odd parity) or E (even parity). Firmware version higher than Linvor 1.5 only. 
AT+VERSION responds with the firmware version. 
*/

void setup()
{
  	Serial.begin(115200);
  	BluetoothSerial.begin(19200);
	Serial.println("Starting");
//        BluetoothSerial.print("AT+NAMEPRINTER");
        BluetoothSerial.print("AT+BAUD5");
//        BluetoothSerial.print("AT+VERSION");
}

void loop()
{
  while(Serial.available() > 0 ) 
  {
    byte b = Serial.read();
    BluetoothSerial.write(b);
    Serial.write(b);
  }
  
  while(BluetoothSerial.available() > 0)
  {
    Serial.write(BluetoothSerial.read());
  }
}
