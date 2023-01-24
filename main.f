\ Creates variable to store the last sampled command.
VARIABLE LAST_COMMAND

\ Welcome quote to start the program.
: QUOTE ( -- )
    S" `Learning never "    PRINT_STRING
    RH_LINE2
    S" exhausts the "       PRINT_STRING 
    1E8480 DELAY 
    CLEAR_DISPLAY
    RH_LINE1
    S" mind.` "             PRINT_STRING
    RH_LINE2
    S" - Leonardo da "      PRINT_STRING
    1E8480 DELAY 
    CLEAR_DISPLAY
    RH_LINE1
    S" Vinci"               PRINT_STRING 
    1E8480 DELAY 
    CLEAR_DISPLAY
    RH_LINE1
    S" Waiting for "        PRINT_STRING
    RH_LINE2
    S" a command... "       PRINT_STRING ; 

\ The main program. It is consists of a loop that prints a new command each time
\ one is encountered.
\ It prints the command in hexadecimal form in the first line of the LCD and its string 
\ equivalent in the second line.
\ The display is updated only when a new command is found.
: MAIN ( -- )
    0 LAST_COMMAND !
    INIT_I2C
    INIT_LCD
    INIT_RECEIVER

    QUOTE

    BEGIN
        DETECT_COMMAND
        DUP IF
            DUP
            LAST_COMMAND @
            <>
            IF
                CLEAR_DISPLAY
                RH_LINE1
                DUP LAST_COMMAND !
                DUP PRINT_HEX
                RH_LINE2
                LOOKUP PRINT_STRING
            THEN
        THEN
    AGAIN ;
