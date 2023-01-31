\ Creates constant for 0 ASCII code.
30 CONSTANT 0ASCII

\ Creates constant for A ASCII code.
41 CONSTANT AASCII

\ Sets up the LCD.
\ By sending this command to the LCD, we set up the data interface to 4 bits, instead
\ of 8 bits, and turn the cursor and cursor position off.
: INIT_LCD ( -- )
    102 >LCD                    \ Sets 4 bit mode using FUNCTION SET
    10C >LCD ;                  \ Disables cursor and cursor position

\ The following words can be used only after the LCD has been set up.

\ Clears the LCD display.
: CLEAR_DISPLAY ( -- )
    101 >LCD ;

\ Moves the cursor to the first cell in the first row of the LCD display.
\ It stands for Return Home Line 1.
: RH_LINE1 ( -- )
    102 >LCD ;

\ Returns the cursor to the first cell in the second row of the LCD display.
\ It stands for Return Home Line 2.
: RH_LINE2 ( -- )
    1C0 >LCD ;

\ Prints a string to the LCD. 
\ Usage: S" embedded systems" PRINT_STRING
: PRINT_STRING ( address length -- )
    OVER + SWAP                 \ address_last_char+1 address_first_char
    BEGIN                       \ While there are chars to send
        DUP C@ >LCD             \ Sends the char of the current position
        1+                      \ Increment address
        2DUP =                  \ Checks whether the string is terminated
    UNTIL 2DROP ;

\ Converts a 4-bit hexadecimal number to the corrisponding ASCII code.
: HEX>ASCII ( 4_bit_number -- ascii_code )
    DUP 09 >
    IF                          \ If it is greater than 9, it is a letter
        0A -                    \ Then subtracts 10 and adds the ASCII code of A
        AASCII +
    ELSE
        0ASCII +                \ Adds the ASCII code of 0 otherwise
    THEN ;

\ Prints a hexadecimal number to the LCD.
: PRINT_HEX ( number -- )
    1C                          \ The amount of shift for sending the current nibble
    BEGIN
        DUP
        0 >=                    \ While there are nibbles to send
    WHILE
        2DUP RSHIFT
        0F AND                  \ Gets the current nibble
        HEX>ASCII >LCD          \ Sends it to the LCD
        04 -                    \ Decrements the amount of current shift
    REPEAT 2DROP ;
