.ORIG x3000

	;Alden Bansemer
	;R0 = Input/Output/Address of Temp
	;R1 = Validation/Temp/Value of Guess
	;R2 = Address Location/Value of Temp
	;R3 = Counter/Counter of Guess
	;R4 = Black
	;R5 = White
	;R6 = Return Preserving/Counter of Temp
	;R7 = Return/Address of Guess

JSR INIT
TRAP x22

LOOP	TRAP x20
  JSR CORRECT_INPUT
  STR R0, R2, #0
  LD R0, HIDDEN
  TRAP x21
  ADD R2, R2, #1
  ADD R3, R3, #-1
BRp LOOP
GAME	LD R0, ENDLINE
  TRAP x21
  LD R0, AD_PB
  TRAP x22
  AND R3, R3, #0
  ADD R3, R3, #4
  LEA R2, PASSA

  PREPARE
    LDR R1, R2, #0
    STR R1, R2, #4
    ADD R2, R2, #1
    ADD R3, R3, #-1
  BRp PREPARE

  AND R3, R3, #0
  ADD R3, R3, #4
  LEA R2, GUESSA
  ASK	TRAP x20
    JSR CORRECT_INPUT
    TRAP x21
    STR R0, R2, #0
    ADD R2, R2, #1
    ADD R3, R3, #-1
  BRp ASK

  AND R3, R3, #0
  ADD R3, R3, #4
  LEA R0, TEMPA
  BLACK	LDR R2, R0, #0
    NOT R2, R2
    ADD R2, R2, #1
    LDR R1, R0, #4
    ADD R2, R2, R1
    BRnp CONTB
    ADD R4, R4, #1
    STR R2, R0, #0
    ADD R2, R2, #1
    STR R2, R0, #4
    CONTB	ADD R0, R0, #1
    ADD R3, R3, #-1
  BRp BLACK

  AND R3, R3, #0
  ADD R3, R3, #4
  LEA R7, GUESSA
  WHITE	LDR R1, R7, #0
    AND R6, R6, #0
    ADD R6, R6, #4
    LEA R0, TEMPA
    TLOOP	LDR R2, R0, #0
      NOT R2, R2
      ADD R2, R2, #1
      ADD R2, R2, R1
      BRnp CONTA
      ADD R5, R5, #1
      STR R2, R0, #0
      ADD R2, R2, #1
      STR R2, R7, #0
      BRnzp BREAK
      CONTA	ADD R0, R0, #1
      ADD R6, R6, #-1
    BRp TLOOP 
    BREAK	ADD R7, R7, #1
    ADD R3, R3, #-1
  BRp WHITE

  LD R0, AD_PC
  TRAP x22
  ADD R4, R4, #0
  BRnz SKIPB
  AND R0, R0, #0
  ADD R0, R4, #-4
  BRzp WINNER
  LD R0, LETB
  BOUT	TRAP x21
    ADD R4, R4, #-1
  BRp BOUT
  SKIPB	ADD R5, R5, #0
  BRnz SKIPW	
  LD R0, LETW
  WOUT	TRAP x21
    ADD R5, R5, #-1
  BRp WOUT

  SKIPW	LEA R2, TICK
  LDR R3, R2, #0
  ADD R3, R3, #-1
  STR R3, R2, #0
BRp GAME
LD R0, ENDLINE
TRAP x21
LD R0, AD_PE
TRAP x22
FIN	HALT

WINNER	LD R0, AD_PD
TRAP x22
BRnzp FIN

INIT	LD R0, AD_PA
  AND R1, R1, #0
  LEA R2, PASSA
  AND R3, R3, #0
  ADD R3, R3, #12
  LEA R4, TICK
  STR R4, R3, #0
  AND R4, R4, #0
  ADD R3, R3, #-8
RET

CORRECT_INPUT	AND R6, R6, #0
  ADD R6, R7, #0
  LD R1, START
  JSR NEGATE_R1
  ADD R1, R1, R0
  BRzp CK_A
  LD R0, START
  CK_A	LD R1, END
  JSR NEGATE_R1
  ADD R1, R1, R0
  BRnz CK_B
  LD R0, END
  CK_B	AND R7, R7, #0
  ADD R7, R6, #0
RET

NEGATE_R1	NOT R1, R1
  ADD R1, R1, #1
RET

START	.FILL x0031
END	.FILL x0036
ENDLINE .FILL x000A
HIDDEN	.FILL x0023
LETB	.FILL x0042
LETW	.FILL x0057

TICK	.FILL #12
PASSA	.FILL x0000
PASSB	.FILL x0000
PASSC	.FILL x0000
PASSD	.FILL x0000
TEMPA	.FILL x0000
TEMPB	.FILL x0000
TEMPC	.FILL x0000
TEMPD	.FILL x0000
GUESSA	.FILL x0000
GUESSB	.FILL x0000
GUESSC	.FILL x0000
GUESSD	.FILL x0000

AD_PA	.FILL PROMPTA
AD_PB	.FILL PROMPTB
AD_PC	.FILL PROMPTC
AD_PD	.FILL PROMPTD
AD_PE	.FILL PROMPTE

PROMPTA	.STRINGZ "Enter a code (4 #s, 1-6): "
PROMPTB	.STRINGZ "Guess: "
PROMPTC	.STRINGZ " -> "
PROMPTD	.STRINGZ "Code Broken!"
PROMPTE	.STRINGZ "Game Over."
RESULT	.STRINGZ "Characters Modified: "

.END