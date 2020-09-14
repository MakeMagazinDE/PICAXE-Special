pullup on
pullup %01000

symbol waittime = w0

main:
	if pinC.1 = 0 then
		waittime = 2000
	elseif pinC.3 = 0 then
		waittime = 4000
	elseif pinC.4 = 0 then
		waittime = 8000
	else
		waittime = 10000
	endif

	low C.2
	pause waittime
	high C.2
	pause waittime

goto main