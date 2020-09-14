symbol U = w1

fvrsetup FVR4096
adcconfig %011

main:
   readadc10 C.1, w0
   U = w0 * 4
   debug
goto main