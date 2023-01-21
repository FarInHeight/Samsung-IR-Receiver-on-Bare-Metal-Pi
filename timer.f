\ Create constant for the offset of the System Timer registers.
3000 CONSTANT TIMER_OFFSET

\ Create constant for the System Timer Counter Lower bits.
PERI_BASE TIMER_OFFSET + 4 +    CONSTANT TIMER

\ Create variabile to store last time read.
VARIABLE LAST_TIME

\ Start the timer by storing the time read in LAST_TIME.
\ Usage: TIMER START
: START ( timer_address -- )
    @ LAST_TIME ! ;

\ Stop the timer by subtracting the time stored in LAST_TIME to the current time.
\ Usage: TIMER STOP
: STOP ( timer_address -- time_in_us )
    @ LAST_TIME @ - ;

\ Delay by a certain amount of time.
: DELAY ( delay_amount_in_us -- )
    TIMER START BEGIN DUP TIMER STOP < UNTIL DROP ;
