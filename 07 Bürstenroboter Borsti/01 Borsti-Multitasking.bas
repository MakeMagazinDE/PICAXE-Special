symbol led_gruen  = b.4
symbol led_blau = b.1

start0: 
	high led_gruen
	pause 480
	low led_gruen
	pause 640
	goto start0 

start1: 
high led_blau
	pause 500
	low led_blau
	pause 500
	goto start1 