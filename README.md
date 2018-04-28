# Mastermind
My final project for CS-155 at NIC. Code written for the LC3.

Download the LC3: https://sourceforge.net/projects/lc3uarch/?source=dlp


Rules!

Codemaker - Write your 4 number code using valid numbers (1-6).

Codebreaker - You have 12 turns to guess the codemaker's code. After each guess
              the computer will give you some clues based on your input.


Output

B - You've got a right number in a right position

W - You've got a right number in a wrong position


Example #1

The code:   5566

The guess:  6654

The output: WWW


Why? The sixes are correct but in the wrong position. The 5 is correct, but in
     the wrong position. Notice, only one W is printed per number. So replacing
     the 4 with a 5 will return another W.


Example #2

The code:   5566

The guess:  4561

The output: BB


Why? The six and five are correct and in the correct position. Notice, only one B 
     is printed per number. So replacing the 4 with a 5 will return another B.


Who Wins?

Codemaker - If the code isn't broken in 12 guesses

Codebreaker - If the code is broken in 12 guesses
