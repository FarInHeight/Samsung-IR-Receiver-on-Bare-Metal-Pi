\ Returns the string representation corresponding to a given code.
\ Note that ENDCASE eliminates the top of the stack, so to return
\ the default string to print we have to do a rotation and let
\ ENDCASE discard the value used for the lookup.
: LOOKUP ( code -- address length )
    CASE 
        7070205F OF S" POWER ON/OFF"        ENDOF
        7070403F OF S" SOURCE"              ENDOF
        70706897 OF S" HDMI"                ENDOF
        7070106F OF S" ONE"                 ENDOF
        7070502F OF S" TWO"                 ENDOF
        7070304F OF S" THREE"               ENDOF
        70700877 OF S" FOUR"                ENDOF
        70704837 OF S" FIVE"                ENDOF
        70702857 OF S" SIX"                 ENDOF
        70701867 OF S" SEVEN"               ENDOF
        70705827 OF S" EIGHT"               ENDOF
        70703847 OF S" NINE"                ENDOF
        7070443B OF S" ZERO"                ENDOF
        70701A65 OF S" TTX/MIX"             ENDOF
        7070641B OF S" PREVIOUS CHANNEL"    ENDOF
        7070700F OF S" VOLUME UP"           ENDOF
        70706817 OF S" VOLUME DOWN"         ENDOF
        70707807 OF S" MUTE"                ENDOF
        70706B14 OF S" CHANNEL LIST"        ENDOF
        7070245B OF S" CHANNEL UP"          ENDOF
        7070047B OF S" CHANNEL DOWN"        ENDOF
        70704F30 OF S" SMART MODE"          ENDOF
        70707906 OF S" GUIDE"               ENDOF
        70702C53 OF S" MENU"                ENDOF
        70706916 OF S" TOOLS"               ENDOF
        70707C03 OF S" INFO"                ENDOF 
        7070037C OF S" UP"                  ENDOF        \ prova
        7070433C OF S" DOWN"                ENDOF
        7070532C OF S" LEFT"                ENDOF
        7070235C OF S" RIGHT"               ENDOF
        70700B74 OF S" OK/ENTER"            ENDOF
        70705A25 OF S" EXIT"                ENDOF
        70700D72 OF S" RETURN"              ENDOF
        70701B64 OF S" RED"                 ENDOF
        7070146B OF S" GREEN"               ENDOF
        7070542B OF S" YELLOW"              ENDOF
        7070344B OF S" BLUE"                ENDOF
        707031CE OF S" FAMILY STORY"        ENDOF
        70706718 OF S" SEARCH"              ENDOF
        70707C83 OF S" 3D"                  ENDOF
        70707E01 OF S" SUPPORT"             ENDOF
        70707887 OF S" D (WHAT IS IT?)"     ENDOF
        7070522D OF S" AD/SUBT."            ENDOF
        7070512E OF S" PREVIOUS TRACK"      ENDOF
        70700976 OF S" NEXT TRACK"          ENDOF
        70704936 OF S" RECORD"              ENDOF
        7070710E OF S" PLAY"                ENDOF
        70702956 OF S" PAUSE"               ENDOF
        7070314E OF S" STOP"                ENDOF
                    S" UNKNOWN COMMAND" ROT
    ENDCASE ;
