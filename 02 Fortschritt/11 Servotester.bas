symbol messwert = b0
symbol pulse = b1
servo C.1, 154
main:
  readadc C.4, messwert
  pulse = messwert * 6 / 10 + 76
  servopos C.1, pulse
goto main