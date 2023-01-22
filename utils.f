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

\ Fetches the content of the return stack.
: R@ ( -- top_of_return_stack )
    R> R> TUCK >R >R ;

\ Multiplies a number by 4 to refer to word offsets.
: TO_WORD ( number -- word_aligned_number )
    02 LSHIFT ;

\ Returns GPFSEL register address for a given GPIO pin.
: GPFSEL ( gpio_pin_number -- gpio_pin_address )
    0A / TO_WORD GPIO_BASE + ;

\ Creates mask for a given GPIO pin.
: MASK ( gpio_pin_number -- mask )
    0A MOD DUP 01 LSHIFT + 07 SWAP LSHIFT INVERT ;

\ Returns a configuration for a GPFSEL content update given a functionality in 0-7 and a GPIO pin number.
: CONFIGURATION ( functionality_number gpio_pin_number -- configuration_for_GPFSEL )
    0A MOD DUP 01 LSHIFT + LSHIFT ;

\ Configures a specific functionality for a GPIO pin given its number and the functionality in 0-7.
: CONFIGURE ( gpio_pin_number functionality_number -- )
    SWAP DUP GPFSEL >R DUP MASK R@ @ AND -ROT CONFIGURATION OR R> ! ;

\ Returns GPSET register address for a given GPIO pin.
: GPSET ( gpio_pin_number -- gpio_pin_address )
    20 / TO_WORD GPIO_BASE + GPIO_SET_OFFSET + ;

\ Returns GPCLR register address for a given GPIO pin.
: GPCLR ( gpio_pin_number -- gpio_pin_address )
    20 / TO_WORD GPIO_BASE + GPIO_CLR_OFFSET + ;

\ Returns a 32 bit word with just one bit high in the proper positon for a GPIO pin.
: BIT_TO_WORD ( gpio_pin_number -- bit_word )
    20 MOD 01 SWAP LSHIFT ;

\ Returns 0 or 1 depending on the value of the bit a given position of a given 32 bit word.
: WORD_TO_BIT ( bit_word bit_number -- bit_value )
    RSHIFT 01 AND ;

\ Sets a GPIO output high for a given GPIO pin.
: HIGH ( gpio_pin_number -- )
    DUP BIT_TO_WORD SWAP GPSET ! ;

\ Sets a GPIO output low for a given GPIO pin.
: LOW ( gpio_pin_number -- )
    DUP BIT_TO_WORD SWAP GPCLR ! ;

\ Returns GPLEV register address for a given GPIO pin.
: GPLEV ( gpio_pin_number -- gpio_pin_address )
    20 / TO_WORD GPIO_BASE + GPIO_LEV_OFFSET + ;

\ Returns 0 or 1 depending on the level (low or high) of a specific GPIO pin when set as input.
: READ ( gpio_pin_number -- )
    DUP GPLEV @ SWAP WORD_TO_BIT ;
