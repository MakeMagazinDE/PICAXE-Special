;program to control blue three blue LEDs and ELV sound module
;
;pin0 >> top LED
;pin1 >> middle LED
;pin2 >> bottom LED
;pin4 >> DIL reed relay to switch aound pin on the sound module
:
init:
;Just show that the system ist starting
low 1,2,3,4					;everything off
high 1					;set blue LED?s to high
pause 1000					;wait one second
low 1						;LED off
pause 1000					;wait for soundmodul coming up
; Test Soundmodul
high 4					;toggle pin 4 play thunder
pause 500
low 4
;Test blue LED				;toggle alle LEDs
high 0,1,2
pause 2000
low 0,1,2
b3=0						;reset w4 used as a counter      
main:
b1 = 80					;delay for flashlight
b2 = 3					;number of fashes
  for b0 = 0 to b2			;flash sequence LED 1 to 3
    high 0,1
    pause b1
    low 0,1
    pause b1
  next b0
  
  pause 3000				;wait 3 seconds
  
  for b0 = 0 to b2			;flash top LED
    high 0
    pause b1
    low 0
    pause b1
  next b0
  
  pause 3000
  
  for b0 = 0 to b2			;flash middle LED
    high 1
    pause b1
    low 1
    pause b1
  next b0
  
  pause 3000
  
  for b0 = 0 to b2			;flash bottom LED
    high 2
    pause b1
    low 2
    pause b1
  next b0
  
  Pause 3000
  
  for b0 = 0 to b2			;flash all LEDs
    high 0,1,2
    pause b1
    low 0,1,2
    pause b1
  next b0
  
  Pause 3000
  
  for b0 = 0 to b2			;flash top and bottom LEDs
    high 0,2
    pause b1
    low 0,2
    pause b1
  next b0
  
  pause 3000
  
  b3 = b3 + 1				;count 5 cycles
    if b3 = 5 then
      high 4				;toggle relay to activate thunder
      pause 500
      low 4
      high 0,1,2				;flash all LEDs
      pause 2000
      low 0,1,2
      b3 = 0
    end if
goto main					;do everything again
  