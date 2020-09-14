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
   if temp_ganzzahl >= 128 then      ; auf negative Temperatur pruefen
      temp_ganzzahl = -temp_ganzzahl ; Temperatur negieren
      sertxd("-")                    ; Minuszeichen ausgeben
      if temp_nk >= 128 then         ; auf Nachkommastelle pruefen
         temp_ganzzahl = temp_ganzzahl - 1 ; wenn ja, vom Ganzzahlwert 1 abziehen
      endif
   else
      sertxd("+")                    ; Pluszeichen ausgeben
   endif
   sertxd(#temp_ganzzahl)            ; Temperatur ganzzahlig ausgeben
   if temp_nk >= 128 then            ; auf Nachkommastelle pruefen
      sertxd(",5")                   ; Nachkommastelle ausgeben fuer ,5 Grad
   else
      sertxd(",0")                   ; Nachkommastelle ausgeben fuer ,0 Grad
   endif
   sertxd(cr, lf)                    ; Zeilenumbruch ausgeben
   pause 1000
goto prog_loop
