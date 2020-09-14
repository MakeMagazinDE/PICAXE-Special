symbol U = w1
symbol U_integer = b4
symbol U_decimals = b5

main:	
	calibadc10 w0
	U = 52378 / w0 * 2
	U_integer = U / 100
	U_decimals = U % 100
	sertxd("Spannung = ", #U_integer, ",")
	if U_decimals < 10 then
   		sertxd("0")
	endif
	sertxd(#U_decimals, "V", cr,lf)
	pause 1000
goto main
