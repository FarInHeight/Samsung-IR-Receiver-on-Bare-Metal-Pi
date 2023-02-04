\ Creates constant for IR receiver GPIO pin.
19 CONSTANT RECEIVER

\ Creates constant for lower bound time for a START_BIT detection (4.35 ms).
10FE CONSTANT LB_START_BIT

\ Creates constant for upper bound time for a START_BIT detection (4.65 ms).
122A CONSTANT UB_START_BIT

\ Creates constant for lower bound time for a 0 bit detection (0.44 ms).
1B8 CONSTANT LB_0_BIT

\ Creates constant for upper bound time for a 0 bit detection (0.68 ms).
2A8 CONSTANT UB_0_BIT

\ Creates variable to store the sampled command.
VARIABLE COMMAND

\ Sets up the receiver by configuring its GPIO pin as input.
: INIT_RECEIVER ( -- )
    RECEIVER INPUT CONFIGURE ;

\ Awaits a transition from the given value to its negation and returns the elapsed time.
\ Usage: RECEIVER LOW (or HIGH) AWAIT 
: AWAIT ( receiver value -- elapsed_time )
    TIMER START
    BEGIN                                     \ Repeats the loop while the read input for
        OVER READ                             \ RECEIVER is equal to the current value i.e.
        OVER <>                               \ awaits a transition to the negation of value
    UNTIL
    2DROP
    TIMER STOP ;

\ Detects if a start bit arrives.
\ -1 is left on the stack if a start bit is detected, 0 otherwise.
\ A start bit is detected if after a transition from HIGH to LOW, LOW is held for 4.5 ms
\ and after a transition from LOW to HIGH, HIGH is held for 4.5 ms.
\ Since perfect timing cannot be achieved, I sample a timing contained within 4.35 ms and 4.65 ms.
\ Usage: RECEIVER START_BIT
: START_BIT ( receiver -- good_or_fail )
    BEGIN
        DUP READ                               \ Waiting for the transition to begin
        LOW =
    UNTIL
    DUP LOW AWAIT                              \ Times how long input is kept LOW
    LB_START_BIT UB_START_BIT IN_RANGE         \ Checks if it can be considered valid
    OVER HIGH AWAIT                            \ Times how long input is kept HIGH
    LB_START_BIT UB_START_BIT IN_RANGE         \ Checks if it can be considered valid
    AND NIP ;


\ Detects if a new arrived bit is a 0 or a 1.
\ -1 is left on the stack if a 0 is detected, 1 if a 1 is detected, 0 otherwise.
\ A 0 is detected if after a transition from HIGH to LOW, LOW is held for 0.56 ms and 
\ after a transition from LOW to HIGH, HIGH is held for 0.56 ms.
\ A 1 is detected if after a transition from HIGH to LOW, LOW is held for 0.56 ms and 
\ after a transition from LOW to HIGH, HIGH is held for 1.69 ms.
\ Since perfect timing cannot be achieved, I sample a timing contained within 0.44 ms and 0.68 ms.
\ Usage: RECEIVER DETECT_BIT
: DETECT_BIT ( receiver -- sampled_value )
    DUP LOW AWAIT                              \ Times how long input is kept LOW
    LB_0_BIT UB_0_BIT IN_RANGE                 \ Checks if it can be considered valid 
    OVER HIGH AWAIT                            \ Times how long input is kept HIGH
    LB_0_BIT UB_0_BIT IN_RANGE                 \ Checks whether it is 
    IF
        -1                                     \ a 0
    ELSE
        1                                      \ or a 1
    THEN 
    AND NIP ;

\ Add a new bit to the command sampled.
\ If value is -1 then add a 0, 1 otherwise.
: ADD_BIT ( value -- )
    COMMAND @ 
    1 LSHIFT SWAP                              \ Makes room for the new bit
    1 =
    IF
        01 OR                                  \ Adds a 1 if it is a 1
    THEN 
    COMMAND ! ;

\ Detects if a stop bit arrives.
\ -1 is left on the stack if a stop bit is detected, 0 otherwise.
\ A stop bit is detected if after a transition from HIGH to LOW, LOW is held for 0.56 ms
\ and after a transition from LOW to HIGH, HIGH is held for  0.56 ms.
\ Since perfect timing cannot be achieved, I sample a timing contained within  0.44 ms and 0.68 ms.
\ Usage: RECEIVER STOP_BIT
: STOP_BIT ( receiver -- )
    DUP >R                                     \ Stores the RECEIVER pin number in the return stack
    LOW AWAIT                                  \ Waits for a transition from LOW to HIGH
    DROP UB_0_BIT
    TIMER START
    BEGIN                                      \ Repeats while 
        R@ READ                                \ the input is HIGH
        OVER TIMER STOP <                      \ and not enough time has elapsed to
        AND                                    \ declare the arrival of a STOP_BIT
    UNTIL
    R>
    2DROP ;

\ Samples a command sent to the receiver.
\ If command detection fails then 0 is returned.
: DETECT_COMMAND ( -- command_hex )
    0 COMMAND !                                \ Resets the sampled command
    RECEIVER START_BIT                         \ Detects whether a START_BIT has arrived.
    NOT IF                                     \ If not
        0 EXIT                                 \ returns 0 and exits
    THEN
    20                                         \ Number of bits to be detected
    BEGIN
        1- DUP
    WHILE                                      \ While there are bits to detect
        RECEIVER DETECT_BIT                    \ Detects the bit
        DUP
        NOT IF                                 \ If it is not valid
            2DROP
            0 EXIT                             \ returns 0 and exits
        THEN
        ADD_BIT                                \ adds the bit to the current command otherwise
    REPEAT
    DROP
    RECEIVER STOP_BIT                          \ Detects the STOP_BIT
    COMMAND @ ;                                \ Returns the sampled command
