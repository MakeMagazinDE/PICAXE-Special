;Borsti 2.0, Programm Nr 3: Steuerung mit
;            besserer Anpassung der Geschwindigkeit
#picaxe 14M2
#com /dev/ttyUSB0
#no_data

; Definition von Namen für die Pins vom Chip
symbol blinker_rechts   = C.4  
symbol blinker_links    = B.2
symbol motor_rechts     = B.4
symbol motor_links      = C.0
symbol bremslicht       = B.1
symbol ir_eingang       = C.2

; Definition von Konstanten
symbol taste_rechts     = 52
symbol taste_links      = 51
symbol taste_vor        = 116
symbol taste_zurueck    = 117
symbol taste_geschw_re_plus  = 2
symbol taste_geschw_re_minus = 8
symbol taste_geschw_li_plus  = 0
symbol taste_geschw_li_minus = 6

; Definition von Register-Variablen
symbol ir_register      = b2
symbol geschw_rechts    = b3
symbol geschw_links     = b4

; Schalter-Variable für die Peripherie
symbol bitfeld            = b0
symbol bit_blinker_rechts = bit0
symbol bit_blinker_links  = bit1
symbol bit_motor_rechts   = bit2
symbol bit_motor_links    = bit3
symbol bit_bremslicht     = bit4

start0: ; Empfangsprogramm für das IR-Signal
  irin [100,timeout], ir_eingang, ir_register
  ; Abhängig vom ir_register setze 
  ; die Schalter für die Peripherie 
  select ir_register
  case taste_rechts    
  	bitfeld = %00000101 ; Motor re und Blinker re
  case taste_links
  	bitfeld = %00001010 ; Motor li und Blinker li
  case taste_vor
  	bitfeld = %00001100 ; beide Motoren an
  case taste_zurueck     
  	bitfeld = %00010000 ; Bremslicht an
  case taste_geschw_re_plus 
  	if geschw_rechts <= 245 then
  		geschw_rechts = geschw_rechts + 10;
  	end if	
  case taste_geschw_re_minus 
  	if geschw_rechts >= 10 then
  		geschw_rechts = geschw_rechts - 10;
  	end if	
  case taste_geschw_li_plus
  	if geschw_links <= 245 then
  		geschw_links = geschw_links + 10;
  	end if	
  case taste_geschw_li_minus 
  	if geschw_links >= 10 then
  		geschw_links = geschw_links - 10;
  	end if	
  endselect
timeout:
	pause 100  
	goto start0
		
start1: ; Steuerprogramm für den linken Motor
  pwmout motor_links, 62, 0
  geschw_links = 255
start1a:
  if bit_motor_links = 1 then	
  	pwmduty motor_links, geschw_links
  else
  	pwmduty motor_links, 0
  end if
  goto start1a	

start2: ; Steuerprogramm für den rechten Motor
  pwmout motor_rechts, 62, 0
  geschw_rechts = 255
start2a:
  if bit_motor_rechts = 1 then	
  	pwmduty motor_rechts, geschw_rechts
  else
  	pwmduty motor_rechts, 0
  end if
  goto start2a

start3: ; Steuerprogramm für den linken Blinker
  if bit_blinker_links = 1 then	
  	high blinker_links
  	pause 500
  	low blinker_links
  	pause 500
  	; kein else-Zweig, da Blinker schon aus ist.
  end if
  goto start3

start4: ; Steuerprogramm für den rechten Blinker
  if bit_blinker_rechts = 1 then	
  	high blinker_rechts
  	pause 500
  	low blinker_rechts
  	pause 500
  	; kein else-Zweig, da Blinker schon aus ist.
  end if
  goto start4

start5: ; Steuerprogramm für das Bremslicht
  bit_bremslicht = 1 ; Bremslicht an
start5a:
  if bit_bremslicht = 1 then	
  	high bremslicht
  else
  	low bremslicht
  end if
  goto start5a