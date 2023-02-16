\ Returns the string representation corresponding to a given code.
\ Note that ENDCASE eliminates the top of the stack, so to return
\ the default string to print we have to do a rotation and let
\ ENDCASE discard the value used for the lookup.
: LOOKUP ( code -- address length )
    CASE 
        E0E040BF OF S" POWER ON/OFF"        ENDOF
        E0E0807F OF S" SOURCE"              ENDOF
        E0E0D12E OF S" HDMI"                ENDOF
        E0E020DF OF S" ONE"                 ENDOF
        E0E0A05F OF S" TWO"                 ENDOF
        E0E0609F OF S" THREE"               ENDOF
        E0E010EF OF S" FOUR"                ENDOF
        E0E0906F OF S" FIVE"                ENDOF
        E0E050AF OF S" SIX"                 ENDOF
        E0E030CF OF S" SEVEN"               ENDOF
        E0E0B04F OF S" EIGHT"               ENDOF
        E0E0708F OF S" NINE"                ENDOF
        E0E08877 OF S" ZERO"                ENDOF
        E0E034CB OF S" TTX/MIX"             ENDOF
        E0E0C837 OF S" PREVIOUS CHANNEL"    ENDOF
        E0E0E01F OF S" VOLUME UP"           ENDOF
        E0E0D02F OF S" VOLUME DOWN"         ENDOF
        E0E0F00F OF S" MUTE"                ENDOF
        E0E0D629 OF S" CHANNEL LIST"        ENDOF
        E0E048B7 OF S" CHANNEL UP"          ENDOF
        E0E008F7 OF S" CHANNEL DOWN"        ENDOF
        E0E09E61 OF S" SMART MODE"          ENDOF
        E0E0F20D OF S" GUIDE"               ENDOF
        E0E058A7 OF S" MENU"                ENDOF
        E0E0D22D OF S" TOOLS"               ENDOF
        E0E0F807 OF S" INFO"                ENDOF 
        E0E006F9 OF S" UP"                  ENDOF
        E0E08679 OF S" DOWN"                ENDOF
        E0E0A659 OF S" LEFT"                ENDOF
        E0E046B9 OF S" RIGHT"               ENDOF
        E0E016E9 OF S" OK/ENTER"            ENDOF
        E0E0B44B OF S" EXIT"                ENDOF
        E0E01AE5 OF S" RETURN"              ENDOF
        E0E036C9 OF S" RED"                 ENDOF
        E0E028D7 OF S" GREEN"               ENDOF
        E0E0A857 OF S" YELLOW"              ENDOF
        E0E06897 OF S" BLUE"                ENDOF
        E0E0639C OF S" FAMILY STORY"        ENDOF
        E0E0CE31 OF S" SEARCH"              ENDOF
        E0E0F906 OF S" 3D"                  ENDOF
        E0E0FC03 OF S" SUPPORT"             ENDOF
        E0E0F10E OF S" D (WHAT IS IT?)"     ENDOF
        E0E0A45B OF S" AD/SUBT."            ENDOF
        E0E0A25D OF S" PREVIOUS TRACK"      ENDOF
        E0E012ED OF S" NEXT TRACK"          ENDOF
        E0E0926D OF S" RECORD"              ENDOF
        E0E0E21D OF S" PLAY"                ENDOF
        E0E052AD OF S" PAUSE"               ENDOF
        E0E0629D OF S" STOP"                ENDOF
                    S" UNKNOWN COMMAND" ROT
    ENDCASE ;
