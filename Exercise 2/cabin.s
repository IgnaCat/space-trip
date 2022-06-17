/*
  Cabina: Funciones para la creacion de la misma.
*/
/*
  Pseudocodigo de la estructura del script

  cabin.s:
    cabin: Llamados a funciones de graphic.s para la creacion del panel principal, ventanas, etc.
*/


.equ SCREEN_WIDTH, 		640
.equ SCREEN_HEIGH, 		480
.equ BITS_PER_PIXEL,  	32
.globl cabin

cabin:
	mov x16, x30
/* 
Dibuja ventana circular principal
Registros predefinidos: x1:R, x21:Y, x22:X, x10: Color
*/
	mov x1, 240
	mov x2, 320
	mov x3, 310	
	movz x10, 0x18, lsl 16
	movk x10, 0x2E3D, lsl 00
	bl circle
	mov x3, 295	
	movz x10, 0x48, lsl 16
	movz x10, 0x6C7B, lsl 00
	bl circle
	mov x3, 287
	mov x10, 0x000000
	bl circle
	
	mov x1, 530		
	mov x2, 200
	mov x3, 140
	movz x10, 0x25, lsl 16
	movk x10, 0x2338, lsl 00
	bl circle	
	mov x2, 440
	bl circle

/* 
Circulos o partes del mismo para la cracion de la mesa principal
Registros: x1:Y, x2:X, x3:R, x10: Color
*/
	mov x1, 495		
	mov x2, 140
	mov x3, 80
	movz x10, 0x18, lsl 16
	movk x10, 0x2E3D, lsl 00	
	bl circle
	mov x1, 495	
	mov x2, 160
	mov x3, 80
	movz x10, 0x4A, lsl 16
	movz x10, 0x6F78, lsl 00
	bl circle
		
	mov x1, 495		
	mov x2, 500
	mov x3, 80
	movz x10, 0x18, lsl 16
	movk x10, 0x2E3D, lsl 00
	bl circle	
	mov x1, 495		
	mov x2, 480
	mov x3, 80
	movz x10, 0x4A, lsl 16
	movz x10, 0x6F78, lsl 00
	bl circle
	

/* 
Dibuja rectangulo principal para mesa del panel de control
Registros predefinidos: x1: X, x2: Y, x3: Width, x4: Height, x10: Color
*/
	movz x1, 212
	movz x2, 380
	movz x3, 220
	movz x4, 100
	movz x10, 0x4A, lsl 16
	movz x10, 0x6F78, lsl 00
	bl rectangle

	add x1, x1, 220
	movz x2, 420
	movz x3, 100
	movz x4, 60
	movz x10, 0x4A, lsl 16
	movz x10, 0x6F78, lsl 00

	sub x1, x1, 320
	movz x2, 420
	movz x3, 100
	movz x4, 60
	movz x10, 0x4A, lsl 16
	movz x10, 0x6F78, lsl 00

	

/* 
Triangulos para mesa principal
(Usamos la diagonal del triangulo para detalles del panel)
*/
	mov x5, 100 // altura
	mov x3, 212 // posicion esquina X
	mov x4, 380 // posicion esquina Y
	movz x11, 0x4A, lsl 16
	movz x11, 0x6F78, lsl 00
	bl triangulo

	mov x5, 160 // altura
	mov x3, 432 // posicion esquina X
	mov x4, 380 // posicion esquina Y
	movz x11, 0x4A, lsl 16
	movz x11, 0x6F78, lsl 00
	bl triangulo


/* 
Retangulos del panel
Usados para hacer botones, pantallas (displays), etc
Registros: x1: X, x2: Y, x3: Width, x4: Height, x10: Color
*/
	movz x1, 201
	movz x2, 446
	movz x3, 19
	movz x4, 19
	movz x10, 0x1B, lsl 16
	movz x10, 0x323E, lsl 00
	bl rectangle
	movz x1, 223
	movz x2, 446
	movz x3, 19
	movz x4, 19
	movz x10, 0x1B, lsl 16
	movz x10, 0x323E, lsl 00
	bl rectangle
	movz x1, 245
	movz x2, 446
	movz x3, 19
	movz x4, 19
	movz x10, 0x1B, lsl 16
	movz x10, 0x323E, lsl 00
	bl rectangle
	movz x1, 267
	movz x2, 446
	movz x3, 19
	movz x4, 19
	movz x10, 0x1B, lsl 16
	movz x10, 0x323E, lsl 00
	bl rectangle

	// Display 1
	movz x1, 121
	movz x2, 432
	movz x3, 65
	movz x4, 45
	movz x10, 0x25, lsl 16
	movk x10, 0x2338, lsl 00
	bl rectangle
	movz x1, 126
	movz x2, 437
	movz x3, 55
	movz x4, 35
	movz x10, 0x0000, lsl 16
	bl rectangle

	// Display 2
	movz x1, 220
	movz x2, 385
	movz x3, 32
	movz x4, 42
	movz x10, 0x25, lsl 16
	movk x10, 0x2338, lsl 00
	bl rectangle
	movz x1, 222
	movz x2, 387
	movz x3, 28
	movz x4, 38
	movz x10, 0x4E, lsl 16
	movk x10, 0x8462, lsl 00
	bl rectangle

	// Display 3
	movz x1, 257
	movz x2, 385
	movz x3, 96
	movz x4, 42
	movz x10, 0x25, lsl 16
	movk x10, 0x2338, lsl 00
	bl rectangle
	movz x1, 259
	movz x2, 387
	movz x3, 92
	movz x4, 38
	movz x10, 0x4E, lsl 16
	movk x10, 0x8462, lsl 00
	bl rectangle


	// Rectangle LEDs between buttons and displays
	movz x1, 226
	movz x2, 431
	movz x3, 10
	movz x4, 7
	movz x10, 0x5E, lsl 16	
	movk x10, 0xA949, lsl 00
	bl rectangle	//Green led
	movz x1, 240
	movz x2, 431
	movz x3, 10
	movz x4, 7
	movz x10, 0x5E, lsl 16
	movk x10, 0xA949, lsl 00
	bl rectangle	//Green led
	movz x1, 254
	movz x2, 431
	movz x3, 10
	movz x4, 7
	movz x10, 0xFB, lsl 16
	movk x10, 0xC030, lsl 00
	bl rectangle	//Yellow led
	movz x1, 268
	movz x2, 431
	movz x3, 10
	movz x4, 7
	movz x10, 0xFB, lsl 16
	movk x10, 0xC030, lsl 00
	bl rectangle	//Yellow led
	movz x1, 282
	movz x2, 431
	movz x3, 10
	movz x4, 7
	movz x10, 0x5E, lsl 16
	movk x10, 0xA949, lsl 00
	bl rectangle	//Green led
	movz x1, 296
	movz x2, 431
	movz x3, 10
	movz x4, 7
	movz x10, 0xC1, lsl 16
	movk x10, 0xD1D0, lsl 00
	bl rectangle	//White led
	movz x1, 310
	movz x2, 431
	movz x3, 10
	movz x4, 7
	movz x10, 0xC1, lsl 16
	movk x10, 0xD1D0, lsl 00
	bl rectangle	//White led
	movz x1, 324
	movz x2, 431
	movz x3, 10
	movz x4, 7
	movz x10, 0xFB, lsl 16
	movk x10, 0xC030, lsl 00
	bl rectangle	//Yellow led
	movz x1, 338
	movz x2, 431
	movz x3, 10
	movz x4, 7
	movz x10, 0x5E, lsl 16
	movk x10, 0xA949, lsl 00
	bl rectangle	//Green led


	
/* 
Circulos para el panel
Usados para hacer botones
Registros: x1: X, x2: Y, x3: R
*/
	mov x1, 455		
	mov x2, 210
	mov x3, 8
	movz x10, 0x4D, lsl 16
	movk x10, 0xB131, lsl 00
	bl circle	
	mov x1, 455		
	mov x2, 232
	mov x3, 8
	movz x10, 0xFF, lsl 16
	bl circle
	mov x1, 455		
	mov x2, 254
	mov x3, 8	
	movz x10, 0xFF, lsl 16
	bl circle
	mov x1, 455		
	mov x2, 276
	mov x3, 8
	movz x10, 0xFF, lsl 16
	bl circle

	//Little circle, white (ring), grey (inside circle) #1
	mov x1, 395		
	mov x2, 375
	mov x3, 12
	movz x10, 0xFF, lsl 16
	movk x10, 0xFFFF, lsl 00	
	bl circle
	mov x1, 395		
	mov x2, 375
	mov x3, 10
	movz x10, 0x4C, lsl 16
	movk x10, 0x4B4B, lsl 00
	bl circle
	//Little circle, white (ring), grey (inside circle) #2
	mov x1, 423		
	mov x2, 375
	mov x3, 12	
	movz x10, 0xFF, lsl 16
	movk x10, 0xFFFF, lsl 00
	bl circle
	mov x1, 423		
	mov x2, 375
	mov x3, 10
	movz x10, 0x4C, lsl 16
	movk x10, 0x4B4B, lsl 00	
	bl circle
	//Little circle, white (ring), grey (inside circle) #3
	mov x1, 442		
	mov x2, 500
	mov x3, 7	
	movz x10, 0xFF, lsl 16
	movk x10, 0xFFFF, lsl 00
	bl circle
	mov x1, 442		
	mov x2, 500
	mov x3, 6
	movz x10, 0x4C, lsl 16
	movk x10, 0x4B4B, lsl 00
	bl circle
	//Little circle, grey (ring), yellow (inside circle)
	mov x1, 456		
	mov x2, 395
	mov x3, 9
	movz x10, 0x44, lsl 16
	movk x10, 0x5253, lsl 00
	bl circle
	mov x1, 456		
	mov x2, 395
	mov x3, 7
	movz x10, 0xFB, lsl 16
	movk x10, 0xC030, lsl 00
	bl circle
	//Little circle, grey (ring), red (inside circle)
	mov x1, 466		
	mov x2, 525
	mov x3, 9
	movz x10, 0x34, lsl 16
	movk x10, 0x3A45, lsl 00
	bl circle
	mov x1, 466		
	mov x2, 525
	mov x3, 7
	movz x10, 0xFF, lsl 16
	bl circle
	//Little circle, dark-grey (ring), grey (inside circle)
	mov x1, 446		
	mov x2, 525
	mov x3, 9	
	movz x10, 0x34, lsl 16
	movk x10, 0x3A45, lsl 00
	bl circle		
	mov x1, 446		
	mov x2, 525
	mov x3, 7
	movz x10, 0x80, lsl 16 
	movk x10, 0x8080, lsl 00
	bl circle

	//Big circle, white (ring), grey (inside circle)
	mov x1, 458		
	mov x2, 450
	mov x3, 19
	movz x10, 0xFF, lsl 16
	movk x10, 0xFFFF, lsl 00
	bl circle
	mov x1, 458		
	mov x2, 450
	mov x3, 13
	movz x10, 0x4C, lsl 16
	movk x10, 0x4B4B, lsl 00	
	bl circle

	//Circle display
	mov x1, 412		
	mov x2, 420
	mov x3, 27	
	movz x10, 0x34, lsl 16
	movk x10, 0x3A45, lsl 00
	bl circle

	movz x10, 0xA000, lsl 00
	mov x3, 25	
	bl circle
	movz x10, 0xF000, lsl 00
	mov x3, 23	
	bl circle
    movz x10, 0xA000, lsl 00
	mov x3, 21	
	bl circle
    movz x10, 0xF000, lsl 00
	mov x3, 19	
	bl circle
	movz x10, 0xA000, lsl 00
	mov x3, 17	
	bl circle
	movz x10, 0xF000, lsl 00
	mov x3, 15	
	bl circle
	movz x10, 0xA000, lsl 00
	mov x3, 13	
	bl circle
	movz x10, 0xF000, lsl 00
	mov x3, 11	
	bl circle
	movz x10, 0xA000, lsl 00
	mov x3, 9	
	bl circle
	movz x10, 0xF000, lsl 00
	mov x3, 7	
	bl circle
	movz x10, 0xA000, lsl 00
	mov x3, 5	
	bl circle
	movz x10, 0xF000, lsl 00
	mov x3, 3	
	bl circle

	//points in circle display

	movz x1, 412
	movz x2, 425
	movz x3, 2
	movz x4, 2
    movz x10, #0x5000
	bl rectangle
	movz x1, 415
	movz x2, 420
	movz x3, 2
	movz x4, 2
	bl rectangle
	movz x1, 420
	movz x2, 430
	movz x3, 2
	movz x4, 2
	bl rectangle
	movz x1, 430
	movz x2, 425
	movz x3, 2
	movz x4, 2
	bl rectangle

	// Bottom white circle trio
	mov x1, 466		
	mov x2, 308
	mov x3, 8
	movz x10, 0xFF, lsl 16
	movk x10, 0xFFFF, lsl 00
	bl circle
	mov x1, 466		
	mov x2, 328
	mov x3, 8
	movz x10, 0xFF, lsl 16
	movk x10, 0xFFFF, lsl 00
	bl circle
	mov x1, 466		
	mov x2, 348
	mov x3, 8	
	movz x10, 0xFF, lsl 16
	movk x10, 0xFFFF, lsl 00
	bl circle

    ret x16

