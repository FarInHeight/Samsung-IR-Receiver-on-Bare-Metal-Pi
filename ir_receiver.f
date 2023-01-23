\ Creates constant for IR receiver GPIO pin
19 CONSTANT RECEIVER

\ Sets up receiver by configuring its GPIO pin as input.
: RECEIVER_SETUP ( -- )
    RECEIVER INPUT CONFIGURE ;

\ Returns -1 is a value in contained within an interval, 0 otherwise.
: IN_RANGE ( value low high -- truth_value )
    ROT DUP ROT <= -ROT <= AND ;

\ Awaits a transition from the given value to its negation and returns the elapsed time.
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
\ Since perfect timing cannot be achieved, I sample a timing contained within 4.2 ms and 4.7 ms.
: START_BIT ( receiver -- good_or_fail )
    BEGIN
        DUP READ
        0=
    UNTIL
    RECEIVER 00 AWAIT
    1068 125C IN_RANGE
    RECEIVER 01 AWAIT
    1068 125C IN_RANGE 
    AND ;
