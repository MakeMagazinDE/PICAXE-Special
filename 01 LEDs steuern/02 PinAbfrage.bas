main:
	if pinC.3 = 1 then blink
goto main

blink:
	low C.2
	pause 1000
	high C.2
goto main