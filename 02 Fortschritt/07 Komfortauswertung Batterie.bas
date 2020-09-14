symbol U = w3

main:
  readadc C.1,b5
  pause 1000
  U = b5 * 100 / 51
  bintoascii U,b4,b3,b2,b1,b0
  sertxd ("Spannung = ",b2,",",b1,b0," Volt",13,10)
  pause 1000
goto main