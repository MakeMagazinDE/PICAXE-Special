'firefly
'2-24-07

'I/O allocation
'OUT/SERIALOUT 	pin 0		
'IN/OUT/ADC1 	pin 1	
'IN/OUT	 	pin 2 
'INput  	 	pin 3
'IN/OUT 	 	pin 4

' no more than 3 blinks

start:


random w4

led1:
b1= 4
b2= 2
b3= 1
b6= 3
gosub blink



led2:
b1= 2
b2= 1
b3= 4
b6= 3
gosub blink


led9:
b1= 1 'pwm line
b2= 4	'low line
b3= 2	'low line
b6 = 2
gosub blink2


led3:
b1= 2
b2= 4
b3= 1
b6= 2
gosub blink



led4:
b1= 1
b2= 2
b3= 4
b6=1
gosub blink

led8:
b1= 2
b2= 1
b3= 4
b6=1
gosub blink2


led11:
b1= 4
b2= 2
b3= 1
b6= 2
gosub blink


led5:
b1= 4
b2= 1
b3= 2
b6=2
gosub blink


led6:
b1= 1
b2= 4
b3= 2
b6=1
gosub blink


led7:
b1= 4
b2= 2
b3= 1
b6= 1
gosub blink2

led10:
b1= 4
b2= 2
b3= 1
b6= 2
gosub blink



goto start


blink: 'single blinking light

for b5 = 1 to b6
for b0 = 0 to  b8 step 10

pwm b1, b0, 8
low b2
input b3
next b0 

for b0 = b9 to  0 step -10

pwm b1, b0, 2
low b2
input b3
next b0
next b5 

pause 500

return

blink2: 'two lights at once

for b5 = 1 to b6
for b0 = 0 to  b8 step 10

pwm b1, b0, 2
low b2
low b3
next b0 

for b0 = b9 to  0 step -10

pwm b1, b0, 16
low b2
low b3
next b0
next b5 

pause 1500

return



end
