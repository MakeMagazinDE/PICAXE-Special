#picaxe 08m2

'Assign names to pins, variables to registers,and constants.

symbol kcnt		=	b1				'Number of knocks
symbol pptr		=	b2				'Pointer to knock delay storage array
symbol tmp1		=	b6				'Reusable variable
symbol tmp2		=	b7				'Reusable variable
symbol rnd		=	w6				'Word variable : Current random number
symbol kdel		=	w5				'Word variable : Delay between last and current knock input

symbol mic		=	PinC.1			'Microphone input (can also be output)
symbol spkr		=	C.2				'Lautsprecher
symbol knock	=	C.4				'Knock motor output
symbol led		=	C.0				'Indicator LED for testing
symbol tmax 	=	1000				'Time-out value for delay - About 1.5 seconds
symbol settle	=	80				'Settling time for microphone
symbol pstart	=	$50				'Start of storage area


'This section is where the person knocks.
'The time between successive knocks is stored 
'until there is a pause of 1.5 seconds or so.

do											'Start of main loop
	kcnt = 0									'Initialise knock counter
	input 1									'Define mic as input to detect knocks
	
	do
		for kdel = 1 to tmax						'KDel is counting loops to determine time between knocks
			if mic = 1 then						'Detect HI on microphone input
				inc kcnt						'Add 1 to number of knocks
				high led						'Flash LED to help debugging
				pause settle					'Wait for oscillations to stop
				low led
				kdel = kdel + settle				'Add settle time to loop counter for accuracy
				pptr = kcnt * 2 + pstart			'kdel is a word variable so need to add 2 to pointer  
				poke pptr,word kdel				'Write the delay from last knock to storage area
				kdel = 0						'Reset kdel ready for next knock
			end if	
		next kdel	
	loop until kdel >= tmax							'If no knocks for over TMax loops then leave loop
	
	
'This section will operate sepending on the number of knocks detected.
'If there are no knocks it will exit.
'Other things happen on 13 or 20 knocks, or it will echo the knocks for any other number.
'The maximum number of knocks is 23 to fill buffer. Incorrect count after that.
	
	select case kcnt

		case 0								'Do nothing if no knocks have occurred
		
		case 13								'Piecax's favourite number
			tune 0, 7,($50,$35,$79,$35,$70,$0B,$F7,$75,$34,$77,$34,$70,$09,$F5,$70,$35,$79,$35,$70,$0B,$F7,$75,$34,$70,$32,$74,$B5,$70,$72,$74,$75)
			gosub TwoKnock						'TUNE command plays the series of bytes as notes
			tune 0, 7,($72,$74,$76,$77)
			gosub TwoKnock						'TWOKNOCK knocks twice with suitable delays between
			tune 0, 7,($72,$74,$76,$77,$3C,$72,$74,$76,$77,$3C,$70,$72,$74,$75)
			gosub TwoKnock
		
		case 20								'If 20 knocks play go into prank mode
			gosub TwoKnock
			wait 30							'Do nothing for 30 seconds
			for tmp1 = 1 to 50					'Make 50 knocks with random spacing 
				random rnd						'Generates next random word
				tmp2 = rnd + 100					'Make delay value from random value
				gosub DoKnock					'Make a knock
				pause tmp2						'Pause for the random delay number of milliseconds
			next tmp1							'Loop until 50 knocks done	

		else 									'Any other number of knocks will be echoed

		for tmp1 = 1 to kcnt						'Loop for the number of knocks
			pptr = tmp1 * 2 + pstart				'Step in twos through buffer
			peek pptr,word kdel					'Read back delay value words from buffer
			pause kdel							'Wait the delay time (in milli-seconds)
			gosub DoKnock						'Perform a knock
		next tmp1								'Loop for next knock
		pause 200
		
	endselect
		
loop


'This section contains the knocking routines

DoKnock:
	high led									'Turn on LED
	high knock									'Turn on motor
	pause 100									'Wait 100 milli-seconds was 70 before
	low knock 									'Turn off motor
	low led									'Turn off LED										
return

TwoKnock:										'More compact to do this as subroutine
	pause 580									'Two knocks with timed delays between for tune
	gosub doknock
	pause 730
	gosub doknock
	pause 730
return