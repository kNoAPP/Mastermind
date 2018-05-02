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

JSR INIT		;Resets everything
TRAP x22		;Print R0

LOOP	TRAP x20	;Get Input -> R0
  JSR CORRECT_INPUT	;Correct the input
  STR R0, R2, #0	;Store the input
  LD R0, HIDDEN		;Load # character
  TRAP x21		;Print character
  ADD R2, R2, #1	;Add 1 to the address
  ADD R3, R3, #-1	;Remove 1 from the counter
BRp LOOP
GAME	LD R0, ENDLINE	;Load ENDLINE character
  TRAP x21		;Print character
  LD R0, AD_PB		;Load Address of Prompt B
  TRAP x22		;Print prompt
  AND R3, R3, #0	;Clear R3
  ADD R3, R3, #4	;Add 4 to R3
  LEA R2, PASSA		;Load address of Password's first character

  PREPARE
    LDR R1, R2, #0	;Load value of one Password character
    STR R1, R2, #4	;Store it 4 spaces below in a Temp location
    ADD R2, R2, #1	;Add 1 to address
    ADD R3, R3, #-1	;Remove 1 from counter
  BRp PREPARE

  AND R3, R3, #0	;Clear R3
  ADD R3, R3, #4	;Add 4 to R3
  LEA R2, GUESSA	;Load address of GuessA
  ASK	TRAP x20	;Get character
    JSR CORRECT_INPUT	;Correct input
    TRAP x21		;Echo correct input
    STR R0, R2, #0	;Store value in Guess
    ADD R2, R2, #1	;Add 1 to address
    ADD R3, R3, #-1	;Remove 1 from counter
  BRp ASK		;Loop if positive

  AND R3, R3, #0	;Clear R3
  ADD R3, R3, #4	;Add 4 to R3
  LEA R0, TEMPA		;Load address of TempA
  BLACK	LDR R2, R0, #0	;Load value of Temp address
    NOT R2, R2		;Negate it
    ADD R2, R2, #1	;Negate it
    LDR R1, R0, #4	;Load value of guess
    ADD R2, R2, R1	;Add the two to compare
    BRnp CONTB		;Not the same? Continue on.
    ADD R4, R4, #1	;Add 1 to Black balls
    STR R2, R0, #0	;ZERO OUT TEMP! - Prevents a white ball
    ADD R2, R2, #1	;Add 1 to R2
    STR R2, R0, #4	;ONE OUT GUESS! - Prevents a white ball
    CONTB	ADD R0, R0, #1	;Add 1 to address
    ADD R3, R3, #-1	;Remove 1 from counter
  BRp BLACK		;Loop if positive

  AND R3, R3, #0	;Clear R3
  ADD R3, R3, #4	;Add 4 to R3
  LEA R7, GUESSA	;Load address of GuessA into R7
  WHITE	LDR R1, R7, #0	;Load value of Guess
    AND R6, R6, #0	;Clear R6
    ADD R6, R6, #4	;Add 4 to R6
    LEA R0, TEMPA	;Load address of TempA into R0
    TLOOP	LDR R2, R0, #0	;Load value of Temp into R2
      NOT R2, R2	;Negate R2
      ADD R2, R2, #1	;Negate R2
      ADD R2, R2, R1	;Compare Temp value and Guess value
      BRnp CONTA	;Not same, continue
      ADD R5, R5, #1	;Add 1 to White balls
      STR R2, R0, #0	;ZERO OUT TEMP! - Prevents additional white balls
      ADD R2, R2, #1	;Add 1 to R2
      STR R2, R7, #0	;ONE OUT GUESS! - Prevents additional white balls (Completely overkill)
      BRnzp BREAK	;Break - Prevents additional white balls
      CONTA	ADD R0, R0, #1	;Add 1 to address
      ADD R6, R6, #-1	;Remove 1 from counter
    BRp TLOOP 		;Loop while positive
    BREAK	ADD R7, R7, #1	;Add 1 to address
    ADD R3, R3, #-1	;Remove 1 from counter
  BRp WHITE		;Loop white positive

  LD R0, AD_PC		;Load address of PromptC into R0
  TRAP x22		;Print
  ADD R4, R4, #0	;Check Black balls
  BRnz SKIPB		;If 0, skip printing
  AND R0, R0, #0	;Clear R0
  ADD R0, R4, #-4	;Check for 4 Black Balls (winner)
  BRzp WINNER		;If 4 black balls, goto winner
  LD R0, LETB		;Load character B
  BOUT	TRAP x21	;Print character B
    ADD R4, R4, #-1	;Remove a Black ball
  BRp BOUT		;Any black balls left?
  SKIPB	ADD R5, R5, #0	;Check White balls
  BRnz SKIPW		;If 0, skip printing
  LD R0, LETW		;Load character W
  WOUT	TRAP x21	;Print character W
    ADD R5, R5, #-1	;Remove a White ball
  BRp WOUT		;Any white balls left?

  SKIPW	LEA R2, TICK	;Load address of turn counter
  LDR R3, R2, #0	;Load value of turn counter
  ADD R3, R3, #-1	;Remove 1 from counter
  STR R3, R2, #0	;Store value of turn counter
BRp GAME		;Out of turns?
LD R0, ENDLINE		;Load ENDLINE character
TRAP x21		;Print ENDLINE character
LD R0, AD_PE		;Load address of PromptE
TRAP x22		;Print PromptE
FIN	HALT		;End Game!

WINNER	LD R0, AD_PD	;Load address of PromptD
TRAP x22		;Print PromptD
BRnzp FIN		;Goto to HALT line

INIT	LD R0, AD_PA	;Load address of PromptA into R0
  AND R1, R1, #0	;Clear R1
  LEA R2, PASSA		;Load address of PASSA into R2
  AND R3, R3, #0	;Clear R3
  ADD R3, R3, #12	;Add 12 to R3 (12 turns)
  LEA R4, TICK		;Get address of turn counter (TICK)
  STR R4, R3, #0	;Store 12 to turn counter
  AND R4, R4, #0	;Clear R4
  ADD R3, R3, #-8	;Remove 8 from R3 (Now set to 4)
RET			;Return

CORRECT_INPUT	AND R6, R6, #0	;Clear R6
  ADD R6, R7, #0	;Copy R7 to R6
  LD R1, START		;Load lower bound into R1
  JSR NEGATE_R1		;Negate it
  ADD R1, R1, R0	;Compare input to lower bound
  BRzp CK_A		;Lower or Higher?
  LD R0, START		;If lower, set R0 to lower bound (character 1)
  CK_A	LD R1, END	;Load upper bound into R1
  JSR NEGATE_R1		;Negate it
  ADD R1, R1, R0	;Compare input to upper bound
  BRnz CK_B		;Lower or Higher?
  LD R0, END		;If higher, set R0 to upper bound (character 6)
  CK_B	AND R7, R7, #0	;Clear R7
  ADD R7, R6, #0	;Copy R6 to R7
RET			;Return

NEGATE_R1	NOT R1, R1	;Not R1
  ADD R1, R1, #1	;Add 1 to R1 to complete negation
RET			;Return

START	.FILL x0031	;Begin Data storage...
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
