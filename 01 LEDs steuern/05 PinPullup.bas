pullup on
pullup %01000

main:
	let b0 = pinC.3
	sertxd ("Der Wert von Pin C.3 ist ", #b0, 13, 10)
	pause 500
goto main