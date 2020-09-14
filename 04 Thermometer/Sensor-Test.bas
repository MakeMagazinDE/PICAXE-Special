symbol sensor = C.4
symbol wert = b0

main:
	readtemp sensor, wert
	sertxd ("Temperatur = ", #wert, " Grad Celsius" ,13)
	pause 5000
goto main