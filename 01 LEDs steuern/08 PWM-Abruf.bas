pullup on
pullup %11010

symbol duty = w0

do
	if pinC.1 = 0 then
		duty = 0
	elseif pinC.3 = 0 then
		duty = 119
	elseif pinC.4 = 0 then
		duty = 239
	else
		duty = 399
	endif

	pwmout C.2, 99, duty

loop