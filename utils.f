\ change base from decimal to hex
HEX

\ create constant for peripherals base memory address
FE000000 CONSTANT PERI_BASE

\ create constant for offset GPIO registers base address
200000 CONSTANT GPIO_OFFSET

\ create constant for offset GPIO output set register
1C CONSTANT GPIO_SET_OFFSET

\ create constant for offset GPIO output clear register
28 CONSTANT GPIO_CLR_OFFSET

\ create constant for offset GPIO pin level registers
34 CONSTANT GPIO_LEV_OFFSET

\ create constant for input function
0 CONSTANT INPUT

\ create constant for output function
1 CONSTANT OUTPUT

\ create constant for GPIO register base address
PERI_BASE GPIO_OFFSET + CONSTANT GPIO_BASE

\ fetch the content of the return stack
: R@ ( -- top_of_return_stack )
    R> DUP >R ;

\ multiply a number by 4 to refer to word offsets
: TO_WORD ( number -- word_aligned_number )
    2 LSHIFT ;

\ returns GPFSEL register address for a given GPIO pin
: GPFSEL ( gpio_pin_number -- gpio_pin_address )
    A / TO_WORD GPIO_BASE + ;

\ create mask for a given GPIO pin
: MASK ( gpio_pin_number -- mask )
    A MOD DUP 1 LSHIFT + 7 SWAP LSHIFT INVERT ;

\ returns a configuration for a GPFSEL content update given a functionality in 0-7 and a GPIO pin number
: CONFIGURATION ( functionality_number gpio_pin_number -- configuration_for_GPFSEL )
    A MOD DUP 1 LSHIFT + LSHIFT ;

\ configure a specific functionality for a GPIO pin given its number and the functionality in 0-7
: CONFIGURE ( gpio_pin_number functionality_number -- )
    SWAP DUP GPFSEL >R DUP MASK R@ @ AND -ROT CONFIGURATION OR R> ! ;

\ returns GPSET register address for a given GPIO pin
: GPSET ( gpio_pin_number -- gpio_pin_address )
    20 / TO_WORD GPIO_BASE + GPIO_SET_OFFSET + ;

\ returns GPCLR register address for a given GPIO pin
: GPCLR ( gpio_pin_number -- gpio_pin_address )
    20 / TO_WORD GPIO_BASE + GPIO_CLR_OFFSET + ;

\ returns a 32 bit word with just one bit high in the proper positon for a GPIO pin
: BIT_TO_WORD ( gpio_pin_number -- bit_word )
    20 MOD 1 SWAP LSHIFT ;

\ returns 0 or 1 depending on the value of the bit a given position of a given 32 bit word
: WORD_TO_BIT ( bit_word bit_number -- bit_value )
    RSHIFT 1 AND ;

\ set a GPIO output high for a given GPIO pin
: HIGH ( gpio_pin_number -- )
    DUP BIT_TO_WORD SWAP GPSET ! ;

\ set a GPIO output low for a given GPIO pin
: LOW ( gpio_pin_number -- )
    DUP BIT_TO_WORD SWAP GPCLR ! ;

\ returns GPLEV register address for a given GPIO pin
: GPLEV ( gpio_pin_number -- gpio_pin_address )
    20 / TO_WORD GPIO_BASE + GPIO_LEV_OFFSET + ;

\ returns 0 or 1 depending on the level (low or high) of a specific GPIO pin when set as input
: READ ( gpio_pin_number -- )
    DUP GPLEV @ SWAP WORD_TO_BIT ;
