\ Changes base from decimal to hex.
HEX

\ Creates constant for peripherals base memory address.
FE000000    CONSTANT PERI_BASE

\ Creates constant for offset GPIO registers base address.
200000      CONSTANT GPIO_OFFSET

\ Creates constant for offset GPIO output set register.
1C          CONSTANT GPIO_SET_OFFSET

\ Creates constant for offset GPIO output clear register.
28          CONSTANT GPIO_CLR_OFFSET

\ Creates constant for offset GPIO pin level registers.
34          CONSTANT GPIO_LEV_OFFSET

\ Creates constant for LOW bit value.
00          CONSTANT LOW

\ Creates constant for HIGH bit value.
01          CONSTANT HIGH

\ Creates constant for input function.
00          CONSTANT INPUT

\ Creates constant for output function.
01          CONSTANT OUTPUT

\ Creates constant for alternate function 0.
04          CONSTANT ALT0

\ Creates constant for alternate function 1.
05          CONSTANT ALT1

\ Creates constant for alternate function 2.
06          CONSTANT ALT2

\ Creates constant for alternate function 3.
07          CONSTANT ALT3

\ Creates constant for alternate function 4.
03          CONSTANT ALT4

\ Creates constant for alternate function 5.
02          CONSTANT ALT5

\ Creates constant for GPIO register base address.
PERI_BASE GPIO_OFFSET + CONSTANT GPIO_BASE

\ Fetches the contents of the return stack.
: R@ ( -- top_of_return_stack )
    R> R> TUCK >R >R ;

\ Clears the specified bits of a given word using a pattern.
: BIC ( word pattern -- word_with_cleared_bits )
    INVERT AND ;

\ Returns -1 if a value in contained within an interval, 0 otherwise.
: IN_RANGE ( value low high -- truth_value )
    ROT DUP ROT                              \ low value value high
    <=                                       \ low value value<=high
    -ROT                                     \ value<=high low value
    <= AND ;                                 \ low<=value<=high

\ Multiplies a number by 4 to refer to word offsets.
: >WORD ( number -- word_aligned_number )
    02 LSHIFT ;

\ Returns GPFSEL register address for a given GPIO pin.
: GPFSEL ( gpio_pin_number -- gpio_pin_address )
    0A /                                     \ GPFSEL register number
    >WORD GPIO_BASE + ;

\ Creates mask for a given GPIO pin.
: MASK ( gpio_pin_number -- mask )
    0A MOD                                   \ Offset (base 10) for gpio_pin_number in GPFSEL contents
    DUP 2* +                                 \ Multiplies by 3 to get the real offset 
    07 SWAP LSHIFT INVERT ;                  \ Returns the mask

\ Returns a configuration for a GPFSEL contents update given a functionality in 0-7 and a GPIO pin number.
: CONFIGURATION ( functionality_number gpio_pin_number -- configuration_for_GPFSEL )
    0A MOD                                   \ Offset (base 10) for gpio_pin_number in GPFSEL contents
    DUP 2* +                                 \ Multiplies by 3 to get the real offset
    LSHIFT ;                                 \ Returns contents to update the functionality of a pin

\ Configures a specific functionality for a GPIO pin given its number and the functionality in 0-7.
: CONFIGURE ( gpio_pin_number functionality_number -- )
    SWAP DUP GPFSEL >R                       \ Gets GPFSEL register address and stores in the return stack
    DUP MASK                                 \ Gets the mask for gpio_pin_number
    R@ @ AND                                 \ Cleans up the GPFSEL register contents for gpio_pin_number
    -ROT CONFIGURATION OR                    \ Updates the contents to set up the functionality
    R> ! ;                                   \ Stores the new value in the GPFSEL register address

\ Returns GPSET register address for a given GPIO pin.
: GPSET ( gpio_pin_number -- gpio_pin_address )
    20 /                                     \ GPSET register number
    >WORD GPIO_BASE + GPIO_SET_OFFSET + ;

\ Returns GPCLR register address for a given GPIO pin.
: GPCLR ( gpio_pin_number -- gpio_pin_address )
    20 /                                     \ GPCLR register number
    >WORD GPIO_BASE + GPIO_CLR_OFFSET + ;

\ Returns a 32 bit word with just one bit high in the proper positon for a GPIO pin.
: BIT>WORD ( gpio_pin_number -- bit_word )
    20 MOD                                   \ Converts to base 32
    01 SWAP LSHIFT ;

\ Returns 0 or 1 depending on the value of the bit in a given position of a given 32 bit word.
: WORD>BIT ( bit_word bit_number -- bit_value )
    RSHIFT 01 AND ;

\ Sets a GPIO output high for a given GPIO pin.
: SET_HIGH ( gpio_pin_number -- )
    DUP BIT>WORD                             \ Gets the right bit position to update the contents of GPSET
    SWAP GPSET ! ;

\ Sets a GPIO output low for a given GPIO pin.
: SET_LOW ( gpio_pin_number -- )
    DUP BIT>WORD                             \ Gets the right bit position to update the contents of GPCLR
    SWAP GPCLR ! ;

\ Returns GPLEV register address for a given GPIO pin.
: GPLEV ( gpio_pin_number -- gpio_pin_address )
    20 /                                     \ GPLEV register number
    >WORD GPIO_BASE + GPIO_LEV_OFFSET + ;

\ Returns 0 or 1 depending on the level (low or high) of a specific GPIO pin when set as input.
: READ ( gpio_pin_number -- )
    DUP GPLEV @                              \ Gets the contents of GPLEV register
    SWAP WORD>BIT ;
