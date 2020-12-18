pullup on
pullup %00011010

symbol waittime = w0

main:
	if pinC.1 = 0 then
		waittime = 200
	elseif pinC.3 = 0 then
		waittime = 400
	elseif pinC.4 = 0 then
		waittime = 800
	else
		waittime = 1000
	endif

	low C.2
	pause waittime
	high C.2
	pause waittime

goto main
