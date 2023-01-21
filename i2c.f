\ create constant for SDA alternate function for GPIO pin 2
4 CONSTANT SDA

\ create constant for SCL alternate function for GPIO pin 3
4 CONSTANT SCL

\ configure GPIO pin 2 for Serial Data Line
2 SDA CONFIGURE

\ configure GPIO pin 3 for Serial Clock Line
3 SCL CONFIGURE

\ There are 8 Broadcom Serial Control (BSC) controllers, numbered from 0 to 7
\ Only 6 of these masters can be used, because BSC masters 2 and 7 are not user-accessible.
\ Since GPIO pins 2 and 3 are used, BSC1 is the reference master.
804000 CONSTANT BSC1

\ There are 8 I2C registers, each of which is at an address obtained by applying an
\ offset to BSC1 (this process is the same for all BSCs).
\ I2C registers are:
\ - C register          the control register is used to enable interrupts, clear the FIFO, 
\                       define a read or write operation and start a transfer;
\ - S register          the status register is used to record activity status, errors 
\                       and interrupt requests;
\ - DLEN register       the data length register defines the number of bytes of data 
\                       to transmit or receive in the I2C transfer. Reading the 
\                       register gives the number of bytes remaining in the current 
\                       transfer;
\ - A register          the slave address register specifies the slave address and cycle type.
\                       The address register can be left across multiple transfers;
\ - FIFO register       the Data FIFO register is used to access the FIFO. Write cycles 
\                       to this address place data in the 16-byte FIFO, ready to 
\                       transmit on the BSC bus. Read cycles access data received from 
\                       the bus;
\ - DIV register        the clock divider register is used to define the clock speed of the 
\                       BSC peripheral;
\ - DEL register        the data delay register provides fine control over the 
\                       sampling/launch point of the data;
\ - CLKT Register       the clock stretch timeout register provides a timeout on how long the
\                       master waits for the slave to stretch the clock before deciding that 
\                       the slave has hung.

\ The following constants are defined to point to the registers above.
BSC1 PERI_BASE +        CONSTANT C
BSC1 PERI_BASE + 4  +   CONSTANT S
BSC1 PERI_BASE + 8  +   CONSTANT DLEN
BSC1 PERI_BASE + C  +   CONSTANT A
BSC1 PERI_BASE + 10 +   CONSTANT FIFO
BSC1 PERI_BASE + 14 +   CONSTANT DIV
BSC1 PERI_BASE + 18 +   CONSTANT DEL
BSC1 PERI_BASE + 1C +   CONSTANT CLKT
