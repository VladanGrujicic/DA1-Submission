;
; DA1.asm
;
; Created: 2/14/2023 6:42:47 PM
; Author : Vladan Grujicic
;

.org 0 ;intialize program memory start at zero
.set EEMWE = EEMPE ;definition used in example from LECT4A
.set EEWE = EEPE ;definition used in example from LECT4A

start: 
ldi R16, HIGH(RAMEND) ;setting memory for high bytes
out SPH, R16
ldi R16, LOW(RAMEND) ;setting memory for low bytes
out SPL, R16
ldi ZH, HIGH(values<<1) ;loads upper byte from value list to Z
ldi ZL, LOW(values<<1) ;loads lower byte from value list to Z

ldi R17, 0 ;loading base values for registers 
ldi R18, 0 ;loading base values for registers 
ldi R19, 10 ;count for number of values to add up
ldi R20, 1 ;loading carry value

loop_add:
lpm R21, Z+ ;loads upper byte from Z into register R21
lpm R22, Z+ ;loads lower byte from Z into register R22
add R23, R21 ;adds the lower byte values together
adc R24, R22 ;adds the upper byte values with the carry included
brhs carry ;save carry value to new register

loop_check:
dec R19 ;decrements list amount from 10 until all values from list have been added
breq loop_store ;moves to storing loop when list has been all added
rjmp loop_add ;jumps to loop to add next value otherwise 

carry:
add R17, R20 ;adds carry sum until loop is done
brhs carry_again ;moves to second carry if carry is present

loop_again:
rjmp loop_check ;jumps to decrement loop until list is done

carry_again:
add R18, R20 ;moves first carry into this one
rjmp loop_again ;jump to check if list is done

loop_store:
ldi XH, HIGH(1024) ;loads high byte for SRAM
ldi XL, LOW(1024) ;loads low byte for SRAM
mov R25, R18 ;store byte for SRAM
call STORE_IN_SRAM ;call SRAM storage instructions

ldi XH, HIGH(1025) ;loads high byte for SRAM
ldi XL, LOW(1025) ;loads low byte for SRAM
mov R25, R17 ;store byte for SRAM
call STORE_IN_SRAM ;call SRAM storage instructions

ldi XH, HIGH(1026) ;loads high byte for SRAM
ldi XL, LOW(1026) ;loads low byte for SRAM
mov R25, R24 ;store byte for SRAM
call STORE_IN_SRAM ;call SRAM storage instructions

ldi XH, HIGH(1027) ;loads high byte for SRAM
ldi XL, LOW(1027) ;loads low byte for SRAM
mov R25, R23 ;store byte for SRAM
call STORE_IN_SRAM ;call SRAM storage instructions

ldi YH, HIGH(512) ;loads high byte for EEPROM
ldi YL, LOW(512) ;loads low byte for EEPROM
mov R25, R18 ;store byte for EEPROM
call STORE_IN_EEPROM ;call EEPROM storage instructions

ldi YH, HIGH(513) ;loads high byte for EEPROM
ldi YL, LOW(513) ;loads low byte for EEPROM
mov R25, R17 ;store byte for EEPROM
call STORE_IN_EEPROM ;call EEPROM storage instructions

ldi YH, HIGH(514) ;loads high byte for EEPROM
ldi YL, LOW(514) ;loads low byte for EEPROM
mov R25, R24 ;store byte for EEPROM
call STORE_IN_EEPROM ;call EEPROM storage instructions

ldi YH, HIGH(515) ;loads high byte for EEPROM
ldi YL, LOW(515) ;loads low byte for EEPROM
mov R25, R23 ;store byte for EEPROM
call STORE_IN_EEPROM ;call EEPROM storage instructions

end: 
//rjmp end ;jump to loop when done

STORE_IN_EEPROM: ;instructions for storing to EEPROM
SBIC EECR, EEPE
RJMP STORE_IN_EEPROM
OUT EEARH,YH
OUT EEARL,YL
OUT EEDR,R25
SBI EECR,EEMPE
SBI EECR,EEPE
RET

STORE_IN_SRAM: ;instructions for storing to SRAM
ST X, R25 ;store resulting value of cumulative addition
RET

.org 0x1EEF ;start loading values from Program Memory location 0x1EEF
values:
.dw 0x0111, 0x0222, 0x0333, 0x0444, 0x0555, 0x0666, 0x0777, 0x0888, 0x0999, 0x0111 ; Define the 10 16-bit values to store (adds to hex 0x310E)
