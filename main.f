\ Creates variable to store the last sampled command.
VARIABLE LAST_COMMAND

\ Creates constant for 2 seconds delay.
1E8480 CONSTANT 2SECONDS

\ Welcome quote to start the program.
: QUOTE ( -- )
    S" `Learning never "    PRINT_STRING
    RH_LINE2
    S" exhausts the "       PRINT_STRING 
    2SECONDS DELAY 
    CLEAR_DISPLAY
    RH_LINE1
    S" mind.` "             PRINT_STRING
    RH_LINE2
    S" - Leonardo da "      PRINT_STRING
    2SECONDS DELAY 
    CLEAR_DISPLAY
    RH_LINE1
    S" Vinci"               PRINT_STRING 
    2SECONDS DELAY 
    CLEAR_DISPLAY
    RH_LINE1
    S" Waiting for "        PRINT_STRING
    RH_LINE2
    S" a command... "       PRINT_STRING ; 

\ The main program. It consists of a loop that prints a new command each time
\ one is encountered.
\ It prints the command in hexadecimal form in the first line of the LCD and its string 
\ equivalent in the second line.
\ The display is updated only when a new command is found.
: MAIN ( -- )
    0 LAST_COMMAND !                        \ Resets the last sampled command
    INIT_I2C                                \ Initialize the I2C interface
    INIT_LCD                                \ Initialize the LCD
    INIT_RECEIVER                           \ Initialize the receiver

    QUOTE                                   \ Prints the quote

    BEGIN
        DETECT_COMMAND                      \ Detects the sampled command
        ?DUP IF                             \ If it is a valid command
            DUP
            LAST_COMMAND @
            <>                              \ Checks whether it is not equal to the last one
            IF                              \ If they are different
                CLEAR_DISPLAY               \ Clears the display
                RH_LINE1                    \ In the first line
                DUP PRINT_HEX               \ prints the new command in hexadecimal form
                DUP LAST_COMMAND !          \ Stores the new command
                RH_LINE2                    \ In the second line
                LOOKUP PRINT_STRING         \ prints the new command as a string
            ELSE
                DROP                        \ drops the sampled command, otherwise
            THEN
        THEN
    AGAIN ;
