\ Creates constant for 0 ASCII code.
30 CONSTANT 0ASCII

\ Creates constant for A ASCII code.
41 CONSTANT AASCII

\ Sets up the LCD.
\ By sending this command to the LCD, we set up the data interface to 4 bits, instead
\ of 8 bits.
: LCD_SETUP ( -- )
    102 TO_LCD ;

\ The following words can be used only after the LCD has been set up.

\ Clears the LCD display.
: CLEAR_DISPLAY ( -- )
    101 TO_LCD ;

\ Moves the cursor to the first cell in the first row of the LCD display.
\ It stands for Return Home Line 1.
: RH_LINE1 ( -- )
    102 TO_LCD ;

\ Returns the cursor to the first cell in the second row of the LCD display.
\ It stands for Return Home Line 2.
: RH_LINE2 ( -- )
    1C0 TO_LCD ;

\ Prints a string to the LCD. 
\ Usage: S" embedded systems" PRINT_STRING
: PRINT_STRING ( address length -- )
    OVER + SWAP
    BEGIN
        DUP C@ TO_LCD
        1+
        2DUP =
    UNTIL 2DROP ;

\ Converts a 4-bit hexadecimal number to the corrisponding ASCII code.
: HEX_TO_ASCII ( 4_bit_number -- ascii_code )
    DUP 09 >
    IF
        0A -
        AASCII +
    ELSE
        0ASCII +
    THEN ;

\ Prints a hexadecimal number to the LCD.
: PRINT_HEX ( number -- )
    1C
    BEGIN
        DUP
    WHILE
        2DUP RSHIFT
        0F AND 
        HEX_TO_ASCII TO_LCD
        04 -
    REPEAT 2DROP ;
