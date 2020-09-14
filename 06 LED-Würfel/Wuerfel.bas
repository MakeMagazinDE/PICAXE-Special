; Cube LEDs:
; LED1      LED6
; LED3 LED7 LED4
; LED5      LED2
symbol CUBE_AXIS1 = C.4  ; LED1, LED2
symbol CUBE_AXIS2 = C.0  ; LED5, LED6
symbol CUBE_AXIS3 = C.2  ; HIGH = LED3, LED4. LOW = LED7
symbol TOUCHPIN = C.1
symbol rollOutCounter = b0
symbol cnt = b1
symbol ledOffCounter = w2
symbol touchValue = w3
symbol randomValue = w4
symbol cubeValue = w5
symbol touchDetected = w6
symbol powerDownModeCounter = w7
symbol CUBE_ROLLOUT = 50 ; number of additional cycles for rollout of cube
symbol LED_OFF_COUNT = 300 ; counter until switching off LEDs 
symbol POWERDOWN_COUNT = 5000 ; counter until activating powerdown mode

cubeValue = 6
gosub showCubeValue
ledOffCounter = LED_OFF_COUNT
powerDownModeCounter = POWERDOWN_COUNT
touch16 TOUCHPIN, touchDetected ; read initial touch value when "untouched"
randomValue = touchDetected ; use first touch value as seed for random
for cnt = 1 to 10
   touch16 TOUCHPIN, touchValue ; read initial touch value when "untouched"
   touchDetected = touchDetected + touchValue / 2 ; mean value with previous value
next cnt
touchDetected = touchDetected + 100 ; set level for "touch detected"
cubeValue = 1
gosub showCubeValue
pause 500
cubeValue = 0
gosub showCubeValue

main:
touch16 TOUCHPIN, touchValue
if touchValue > touchDetected then
   ledOffCounter = LED_OFF_COUNT
   powerDownModeCounter = POWERDOWN_COUNT
   rollOutCounter = CUBE_ROLLOUT
   do
      RANDOM randomValue
      cubeValue = randomValue % 6 + 1 ; modulo
      gosub showCubeValue
      touch16 TOUCHPIN, touchValue
      if touchValue > touchDetected then
         rollOutCounter = CUBE_ROLLOUT
      else
         dec rollOutCounter
      endif
   loop while rollOutCounter > 0
else
   if ledOffCounter > 0 then
      dec ledOffCounter
      if ledOffCounter = 0 then
         cubeValue = 0
         gosub showCubeValue
      endif
   else
      if powerDownModeCounter > 0 then
         dec powerDownModeCounter
         if powerDownModeCounter = 0 then
            for cnt = 1 to 3
               cubeValue = 1
               gosub showCubeValue
               pause 250
               cubeValue = 0
               gosub showCubeValue
               pause 250
            next cnt
         endif
      else
         nap 7 ; sleep for 2,3 seconds
      endif
   endif
endif
goto main


showCubeValue:
   select case cubeValue
      case 0
         gosub cube_0
      case 1
         gosub cube_1
      case 2
         gosub cube_2
      case 3
         gosub cube_3
      case 4
         gosub cube_4
      case 5
         gosub cube_5
      case 6
         gosub cube_6
   endselect
return

cube_0:
low CUBE_AXIS1
low CUBE_AXIS2
input CUBE_AXIS3
return

cube_1:
low CUBE_AXIS1
low CUBE_AXIS2
low CUBE_AXIS3
return

cube_2:
high CUBE_AXIS1
low CUBE_AXIS2
input CUBE_AXIS3
return

cube_3:
high CUBE_AXIS1
low CUBE_AXIS2
low CUBE_AXIS3
return

cube_4:
high CUBE_AXIS1
high CUBE_AXIS2
input CUBE_AXIS3
return

cube_5:
high CUBE_AXIS1
high CUBE_AXIS2
low CUBE_AXIS3
return

cube_6:
high CUBE_AXIS1
high CUBE_AXIS2
high CUBE_AXIS3
return
