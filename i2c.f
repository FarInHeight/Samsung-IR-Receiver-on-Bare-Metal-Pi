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
BSC1 PERI_BASE +             CONSTANT C
BSC1 PERI_BASE + 04 +        CONSTANT S
BSC1 PERI_BASE + 08 +        CONSTANT DLEN
BSC1 PERI_BASE + 0C +        CONSTANT A
BSC1 PERI_BASE + 10 +        CONSTANT FIFO
BSC1 PERI_BASE + 14 +        CONSTANT DIV
BSC1 PERI_BASE + 18 +        CONSTANT DEL
BSC1 PERI_BASE + 1C +        CONSTANT CLKT

\ Set slave address.
\ It can be left across multiple transfers.
: SET_SLAVE ( slave_address -- ) 
    A ! ;

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

\ Clear FIFO.
\ - CLEAR (5:4) set to X1 or 1X in order to clear the FIFO before the new frame is started.
: CLEAR_FIFO ( -- )
    10 C ! ;

\ Modify control register to trigger a transfer.
\ To start a new transfer, all bits are zero except for:
\ - I2CEN (15) set to 1 to enable the BSC controller;
\ - ST (7) set to 1 to start a new transfer (one-shot operation).
\ Interrupts are disabled.
: TRANSFER ( -- )
    8080 C ! ;

\ Data transfer through the I2C bus interface.
\ Since communication is established to the LCD panel, 8 bits at a time are sent.
: SEND
    RESET_STATUS
    CLEAR_FIFO
    1 SET_DLEN
    APPEND
    TRANSFER ;

\ Setup the I2C bus interface and the slave address.
\ Configure GPIO pin 2 for Serial Data Line.
\ Configure GPIO pin 3 for Serial Clock Line.
\ Set the slave address to 0x27.
: I2C_SETUP
    2 ALT0 CONFIGURE
    3 ALT0 CONFIGURE
    27 SET_SLAVE ;

: 4BM>LCD 
  F0 AND DUP ROT
  D + OR SEND 1000 DELAY
  8 OR SEND 1000 DELAY ;

: >LCDM
  OVER OVER F0 AND 4BM>LCD
  F AND 4 LSHIFT 4BM>LCD ;

: IS_CMD 
  DUP 8 RSHIFT 1 = ;

: >LCD 
  IS_CMD SWAP >LCDM 
;
