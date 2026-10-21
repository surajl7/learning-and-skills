; 8085 Assembly Program to Add Two Numbers
ORG 2000H       ; Set starting memory address to 2000H

MVI A, 05H      ; Load immediate hex value 05 into the Accumulator (A)
MVI B, 03H      ; Load immediate hex value 03 into Register B
ADD B           ; Add contents of B to Accumulator (A = A + B)

STA 3000H       ; Store the final sum (in Accumulator) into memory address 3000H
HLT             ; Halt/stop program execution