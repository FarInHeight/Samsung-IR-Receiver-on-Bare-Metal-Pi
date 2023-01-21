\ Create constant for SDA alternate function for GPIO pin 2.
4 CONSTANT SDA

\ Create constant for SCL alternate function for GPIO pin 3.
4 CONSTANT SCL

\ Configure GPIO pin 2 for Serial Data Line.
2 SDA CONFIGURE

\ Configure GPIO pin 3 for Serial Clock Line.
3 SCL CONFIGURE

\ There are 8 Broadcom Serial Control (BSC) controllers, numbered from 0 to 7
\ Only 6 of these masters can be used, because BSC masters 2 and 7 are not user-accessible.
\ Since GPIO pins 2 and 3 are used, BSC1 is the reference master.
804000 CONSTANT BSC1

\ There are 8 I2C registers, each of which is at an address obtained by applying an
\ offset to BSC1 (this process is the same for all BSCs).
\ I2C registers are:
\ - C register          The control register is used to enable interrupts, clear the FIFO, 
\                       define a read or write operation and start a transfer;
\ - S register          The status register is used to record activity status, errors 
\                       and interrupt requests;
\ - DLEN register       The data length register defines the number of bytes of data 
\                       to transmit or receive in the I2C transfer. Reading the 
\                       register gives the number of bytes remaining in the current 
\                       transfer;
\ - A register          The slave address register specifies the slave address and cycle type.
\                       The address register can be left across multiple transfers;
\ - FIFO register       The Data FIFO register is used to access the FIFO. Write cycles 
\                       to this address place data in the 16-byte FIFO, ready to 
\                       transmit on the BSC bus. Read cycles access data received from 
\                       the bus;
\ - DIV register        The clock divider register is used to define the clock speed of the 
\                       BSC peripheral;
\ - DEL register        The data delay register provides fine control over the 
\                       sampling/launch point of the data;
\ - CLKT Register       The clock stretch timeout register provides a timeout on how long the
\                       master waits for the slave to stretch the clock before deciding that 
\                       the slave has hung.

\ The following constants are defined to point to the registers above.
\ DIV, DEL and CLKT can be left whitout changes.
BSC1 PERI_BASE +        CONSTANT C
BSC1 PERI_BASE + 4  +   CONSTANT S
BSC1 PERI_BASE + 8  +   CONSTANT DLEN
BSC1 PERI_BASE + C  +   CONSTANT A
BSC1 PERI_BASE + 10 +   CONSTANT FIFO
BSC1 PERI_BASE + 14 +   CONSTANT DIV
BSC1 PERI_BASE + 18 +   CONSTANT DEL
BSC1 PERI_BASE + 1C +   CONSTANT CLKT

\ Set slave address just once, as it can be left across multiple transfers.
: SET_SLAVE ( -- ) 
    27 A ! ;

\ Set number of data bytes to transfer.
: SET_DLEN ( length -- ) 
    DLEN ! ;

\ Place 8 bits at a time in FIFO in order to transmit them on the BSC bus.
: APPEND ( 8_bit_data -- )
    FIFO ! ;

\ Reset status for subsequent transfers.
\ Only CLKT (9), ERR (8) and DONE (1) can be cleared (W1C type), all other flags are read-only (RO). 
: RESET_STATUS ( -- )
    302 S ! ;

\ Modify control register to trigger a transfer.
\ To start a new transfer, all bits are zero except for:
\ - I2CEN (15) set to 1 to enable the BSC controller;
\ - ST (7) set to 1 to start a new transfer (one-shot operation);
\ - CLEAR (5:4) set to X1 or 1X in order to clear the FIFO before the new frame is started.
\ Interrupts are disabled.
: TRANSFER ( -- )
    8090 C ! ;

\ Data transfer through the I2C bus interface.
\ Since communication is established to the LCD panel, 8 bits at a time are sent.
: SEND
    RESET_STATUS
    1 SET_DLEN
    SET_SLAVE
    APPEND
    TRANSFER ;


