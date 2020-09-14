servo C.1, 154
main:
  servopos C.1, 154		`Mitte
  pause 2000
  servopos C.1, 232		`rechts
  pause 2000
  servopos C.1, 76 		`links
  pause 2000
goto main