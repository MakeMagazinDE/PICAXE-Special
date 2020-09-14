#terminal 4800

symbol I2C_ADDRESS_LM75A = %10010000 ; 1 0 0 1 A2 A1 A0 RW  ==>  A2..A0 = 000
symbol LM75A_TEMPERATURE_REG = %00   ; Adresse des Temperaturregisters im LM75

symbol temp_nk = b0       ; Nachkommastellen des Temperaturwerts
symbol temp_ganzzahl = b1 ; ganzzahliger Temperaturwert

main:
hi2csetup i2cmaster, I2C_ADDRESS_LM75A, i2cslow, i2cbyte ; I2C konfigurieren
pause 1000
sertxd("Temperatur [Grad Celsius]:", cr, lf)

prog_loop:
   hi2cin LM75A_TEMPERATURE_REG, (temp_ganzzahl, temp_nk) ; Temperatur lesen
   sertxd(#temp_ganzzahl) ; Temperatur ganzzahlig ausgeben
   sertxd(cr, lf)         ; Zeilenumbruch ausgeben
   pause 1000
goto prog_loop
