symbol led        = b.4
symbol ir_eingang = c.3

pwmout led, 62, 0

main: 
	irin ir_eingang, b0
	debug
	let b0 = b0 * 8
	pwmduty led, b0 
goto main 