\ Some word definitions taken from pijFORTHos.
\ Link: https://github.com/organix/pijFORTHos/blob/master/annexia/jonesforth.f.txt

\ These words are necessery in order to PRINT_STRING (in lcd.f)
\ to work properly. 
\ After a number of attempts trying to rencocile these definitions with
\ those contained in se-ans.f, I observed that lookup_table.f stop working.
\ The problem resides in the use of OF - ENDOF.
\ This file must be uploaded as the first one.

\ We can use [ and ] to insert literals which are calculated at compile time.  
\ (Recall that [ and ] are the FORTH words that allow you to exit and enter compilation mode.)
\ Within definitions, use [ ... ] LITERAL anywhere that '...' is a constant expression
\ which you would rather only compute once (at compile time, rather than calculating 
\ it each time your word runs).

\ Returns the ASCII code of ".
: '"' ( -- ascii_code )
    [ CHAR " ] LITERAL ;

\ Takes an address and rounds it up (aligns it) to the next 4 byte boundary.
: ALIGNED ( c_addr -- a_addr )
    3 + 3 INVERT AND ;

\ Aligns the HERE pointer, so the next word appended will be aligned properly.
: ALIGN ( -- )
    HERE @ ALIGNED HERE ! ;

\ Appends a byte to the current compiled word.
: C, ( byte -- )
    HERE @ C! 1 HERE +! ;


\ S" string" is used in FORTH to define strings.  It leaves the address of the string and
\ its length on the stack, (length at the top of stack).  The space following S" is the 
\ normal space between FORTH words and is not a part of the string.
\ This is tricky to define because it has to do different things depending on whether
\ we are compiling or in interpret mode.  (Thus the word is marked IMMEDIATE so it can
\ detect this and do different things).
\ In compile mode we apppend the string length and the string rounded up 4 bytes
\ to the current word.  
\ In interpret mode there isn't a particularly good place to put the string, but in this
\ case we put the string at HERE (but we _don't_ change HERE). This is meant as a 
\ temporary location, likely to be overwritten soon after.
: S" IMMEDIATE ( -- addr len )
	STATE @ IF
		' LITS , HERE @ 0 ,
		BEGIN KEY DUP '"'
                <> WHILE C, REPEAT
		DROP DUP HERE @ SWAP - 4- SWAP ! ALIGN
	ELSE
		HERE @
		BEGIN KEY DUP '"'
                <> WHILE OVER C! 1+ REPEAT
		DROP HERE @ - HERE @ SWAP
	THEN ;
