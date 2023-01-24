\ Creates constant for IR receiver GPIO pin
19 CONSTANT RECEIVER

\ Creates variable to store the sampled command.
VARIABLE COMMAND_HEX

\ Sets up receiver by configuring its GPIO pin as input.
: RECEIVER_SETUP ( -- )
    RECEIVER INPUT CONFIGURE ;

\ Returns -1 is a value in contained within an interval, 0 otherwise.
: IN_RANGE ( value low high -- truth_value )
    ROT DUP ROT <= -ROT <= AND ;

\ Awaits a transition from the given value to its negation and returns the elapsed time.
\ Usage: RECEIVER 0X AWAIT (where X is 0 or 1)
: AWAIT ( receiver value -- elapsed_time )
    TIMER START
    BEGIN
        OVER READ
        OVER <>
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
        DUP READ
        0=
    UNTIL
    DUP 00 AWAIT
    10FE 122A IN_RANGE
    OVER 01 AWAIT
    10FE 122A IN_RANGE 
    AND NIP ;


\ Detects if a new arrived bit is a 0 or a 1.
\ -1 is left on the stack if a 0 is detected, 1 if a 1 is detected, 0 otherwise.
\ A 0 is detected if after a transition from HIGH to LOW, LOW is held for 0.56 ms and 
\ after a transition from LOW to HIGH, HIGH is held for 0.56 ms.
\ A 1 is detected if after a transition from HIGH to LOW, LOW is held for 0.56 ms and 
\ after a transition from LOW to HIGH, HIGH is held for 1.69 ms.
\ Since perfect timing cannot be achieved, I sample a timing contained within 0.44 ms and 0.68 ms.
\ Usage: RECEIVER DETECTED_BIT
: DETECT_BIT ( receiver -- sampled_value )
    DUP 00 AWAIT
    1B8 2A8 IN_RANGE
    OVER 01 AWAIT
    1B8 2A8 IN_RANGE
    IF
        -1
    ELSE
        1
    THEN 
    AND NIP ;

\ Add a new bit to the command sampled.
\ If value is -1 then add a 0, 1 otherwise.
: ADD_BIT ( value -- )
    COMMAND_HEX @ 
    1 LSHIFT SWAP
    1 =
    IF
        01 OR
    THEN 
    COMMAND_HEX ! ;

\ Detects if a stop bit arrives.
\ -1 is left on the stack if a stop bit is detected, 0 otherwise.
\ A stop bit is detected if after a transition from HIGH to LOW, LOW is held for 0.56 ms
\ and after a transition from LOW to HIGH, HIGH is held for  0.56 ms.
\ Since perfect timing cannot be achieved, I sample a timing contained within  0.44 ms and 0.68 ms.
\ Usage: RECEIVER STOP_BIT
: STOP_BIT ( receiver -- )
    DUP >R
    00 AWAIT
    DROP 2A8
    TIMER START
    BEGIN
        R@ READ
        OVER TIMER STOP <
        AND
    UNTIL
    R>
    2DROP ;

\ Samples a command sent to the receiver.
\ If command detection fails then 0 is returned.
: DETECT_COMMAND ( -- command_hex )
    0 COMMAND_HEX !
    RECEIVER START_BIT
    NOT IF
        0 EXIT
    THEN
    20 
    BEGIN
        1- DUP
    WHILE
        RECEIVER DETECT_BIT
        DUP
        NOT IF
            2DROP
            0 EXIT
        THEN
        ADD_BIT
    REPEAT
    DROP
    RECEIVER STOP_BIT
    COMMAND_HEX @ ;
