SYMBOL OLED_WIDTH	= 128
SYMBOL OLED_MAX_X	= OLED_WIDTH - 1 ; 127
SYMBOL OLED_HEIGHT = 64
SYMBOL OLED_HEIGHT_LINES	= OLED_HEIGHT / 8 ; 8
SYMBOL OLED_MAX_Y	= OLED_HEIGHT_LINES - 1 ; 7
SYMBOL SSD1306_SETCONTRAST = 0x81
SYMBOL SSD1306_DISPLAYALLON_RESUME = 0xA4
SYMBOL SSD1306_DISPLAYALLON  = 0xA5
SYMBOL SSD1306_NORMALDISPLAY = 0xA6
SYMBOL SSD1306_INVERTDISPLAY = 0xA7
SYMBOL SSD1306_DISPLAYOFF = 0xAE
SYMBOL SSD1306_DISPLAYON = 0xAF	
SYMBOL SSD1306_SETDISPLAYOFFSET = 0xD3
SYMBOL SSD1306_SETCOMPINS = 0xDA	
SYMBOL SSD1306_SETVCOMDETECT = 0xDB	
SYMBOL SSD1306_SETDISPLAYCLOCKDIV = 0xD5
SYMBOL SSD1306_SETPRECHARGE = 0xD9
SYMBOL SSD1306_SETMULTIPLEX = 0xA8	
SYMBOL SSD1306_SETLOWCOLUMN = 0x00
SYMBOL SSD1306_SETHIGHCOLUMN = 0x10
SYMBOL SSD1306_SETSTARTLINE = 0x40
SYMBOL SSD1306_MEMORYMODE = 0x20
SYMBOL SSD1306_COLUMNADDR = 0x21
SYMBOL SSD1306_PAGEADDR = 0x22	; Page 0-7 represents line 0 - 7
SYMBOL SSD1306_COMSCANINC = 0xC0
SYMBOL SSD1306_COMSCANDEC = 0xC8
SYMBOL SSD1306_SEGREMAP = 0xA0 | 1
SYMBOL SSD1306_CHARGEPUMP = 0x8D
SYMBOL SSD1306_EXTERNALVCC = 0x1
SYMBOL SSD1306_SWITCHCAPVCC = 0x2

SYMBOL SSD1306_ADDR  = 0x3C * 2 ; OLED I2C address (0x78)

symbol PICAXE_SPEED = m32
symbol I2C_SPEED = i2cfast_32
symbol DELAY = 1000*8

symbol oled_x1 = b0
symbol oled_y1 = b1
symbol oled_x2 = b2
symbol oled_y2 = b3
symbol counter = b4
symbol tempVarWord = w4

#define OLED_DATA(d) hi2cout (0x40, d)

#macro i2c_enable_oled 
hi2csetup i2cmaster, SSD1306_ADDR, I2C_SPEED, i2cbyte
#endmacro

#macro OLED_CURSOR(x,y) ; x = column 0-127, y = line 0-7
oled_y1 = y
oled_x1 = x
oled_y2 = OLED_MAX_Y
oled_x2 = OLED_MAX_X
gosub oledWindow
#endmacro

#macro OLED_WINDOW(x1,y1,x2,y2) ; x1=start column, y1=start line
                                ; x2=end column,y2= end line
oled_y1 = y1
oled_x1 = x1
oled_y2 = y2
oled_x2 = x2
gosub oledWindow
#endmacro

;----------------------------------------------------------------

setfreq PICAXE_SPEED
gosub oledInit
gosub oledClearDisplay

main:

   OLED_CURSOR(0, 0)
   OLED_DATA(0xFF)
   for counter = 1 to 62
      OLED_DATA(0x01)
   next counter
   OLED_DATA(0xFF)

   OLED_CURSOR(0, 1)
   OLED_DATA(0xFF)
   for counter = 1 to 62
      OLED_DATA(0x80)
   next counter
   OLED_DATA(0xFF)

   pause DELAY
   
   OLED_WINDOW(10, 3, 25, 4)
   for counter = 1 to 32
      OLED_DATA(0xFF)
   next counter

goto main

;-----------------------------------------------------------------

oledInit:
   i2c_enable_oled
   hi2cout (0, SSD1306_DISPLAYOFF)            ; 0xAE
   hi2cout (0, SSD1306_SETDISPLAYCLOCKDIV)    ; 0xD5
   hi2cout (0, 0x80)                          ; the suggested ratio 0x80
   hi2cout (0, SSD1306_SETMULTIPLEX)          ; 0xA8
   hi2cout (0, 0x3F)
   hi2cout (0, SSD1306_SETDISPLAYOFFSET)      ; 0xD3
   hi2cout (0, 0x0)                           ; no offset
   hi2cout (0, SSD1306_SETSTARTLINE)          ; line #0
   hi2cout (0, SSD1306_CHARGEPUMP)            ; 0x8D
   hi2cout (0, 0x14)     						    ; INTERNAL VCC
   hi2cout (0, SSD1306_MEMORYMODE)            ; 0x20
   hi2cout (0, 0x00)                          ; Horiz mode. 0x0 act like ks0108
   hi2cout (0, SSD1306_SEGREMAP)
   hi2cout (0, SSD1306_COMSCANDEC)
   hi2cout (0, SSD1306_SETCOMPINS)            ; 0xDA
   hi2cout (0, 0x12)
   hi2cout (0, SSD1306_SETCONTRAST)           ; 0x81
   hi2cout (0, 0xCF)						          ; INTERNAL VCC
   hi2cout (0, SSD1306_SETPRECHARGE)          ; 0xD9
   hi2cout (0, 0xF1)						          ; INTERNAL VCC
   hi2cout (0, SSD1306_SETVCOMDETECT)         ; 0xDB
   hi2cout (0, 0x40)
   hi2cout (0, SSD1306_DISPLAYALLON_RESUME)   ; 0xA4
   hi2cout (0, SSD1306_DISPLAYON)         	 ; 0xAF	
return

oledClearDisplay:
   hi2cout (0, SSD1306_PAGEADDR)
   hi2cout (0, 0) ; set row 0
   hi2cout (0, OLED_MAX_Y) ; 7
   hi2cout (0, SSD1306_COLUMNADDR)
   hi2cout (0, 0) ; set column 0
   hi2cout (0, OLED_MAX_X) ; 127
   for tempVarWord = 1 to 32 ; 1024/32
   hi2cout (0x40, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
   next tempVarWord
return

oledWindow:
   hi2cout (0, SSD1306_PAGEADDR)
   hi2cout (0, oled_y1) ; set row
   hi2cout (0, oled_y2)
   hi2cout (0, SSD1306_COLUMNADDR)
   hi2cout (0, oled_x1) ; set column
   hi2cout (0, oled_x2)
return