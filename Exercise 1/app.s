/*
  Nave viaje en el tiempo
  Dibuja la cabina de una nave espacial, la cual contiene un gran vental con vista a las estrellas
  y una mesa representando el panel de control.
*/

/*
  Pseudocodigo de la estructura del script

  apps.s:
  	main: Llamados principales a las funciones de cabina y strafield
  cabin.s:
	rectangle: Dibuja un rectangulo.
	triangle: Dibuja un triangulo.
	circle: Dibuja un circulo.
  starfield.s:
	cuad: Dibuja un rectangulo.
	strafield: Dibuja estrellas.
	fib: Genera pares usando fibonacci.
*/

/* Lista de registros:
  - x0:
  - x1: X
  - x2: Y
  - x3:
  - x4:
  - x5:
  - x6:
  - x7:
  - x8:
  - x9:
  - x10: Color

*/

/* Tareas relacionadas con los estandares
  - Redefinir circulo usando x1:X, x2:Y
  - Redefinir triangulo. Sacar el sp.
  - Complentar todo siguiendo los comentarios agregados
  - Agregar archivos para trabajar por separado
*/

.equ SCREEN_WIDTH, 		640
.equ SCREEN_HEIGH, 		480
.equ BITS_PER_PIXEL,  	32


.globl main
main:
	mov x20, x0
	movz x10, 0x0C, lsl 16
	movz x10, 0x191E, lsl 00 // Color de fondo
	movz x11, 0xFF, lsl 16
	movk x11, 0xFFFF, lsl 00 // Color Estrellas

	mov x2, SCREEN_HEIGH         // Y Size 
loop1:
	mov x1, SCREEN_WIDTH         // X Size
loop0:
	stur w10,[x0]	   // Set color of pixel N
	add x0,x0,4	   // Next pixel
	sub x1,x1,1	   // decrement X counter
	cbnz x1,loop0	   // If not end row jump
	sub x2,x2,1	   // Decrement Y counter
	cbnz x2,loop1	   // if not last row, jump
    
/* 
Dibuja ventana circular principal
Registros predefinidos: x1:R, x21:Y, x22:X, x10: Color
*/
	movz x10, 0x18, lsl 16
	movk x10, 0x2E3D, lsl 00
	mov x3, 310	
	mov x21, 240
	mov x22, 320
	bl circle
	movz x10, 0x48, lsl 16
	movz x10, 0x6C7B, lsl 00
	mov x3, 295	
	mov x21, 240		
	mov x22, 320
	bl circle
	mov x10, 0x000000
	mov x3, 287	
	mov x21, 240		
	mov x22, 320
	bl circle

	movz x10, 0x25, lsl 16
	movk x10, 0x2338, lsl 00
	mov x3, 140	
	mov x21, 530		
	mov x22, 200
	bl circle
	movz x10, 0x25, lsl 16
	movk x10, 0x2338, lsl 00
	mov x3, 140	
	mov x21, 530		
	mov x22, 440
	bl circle

	// Table circle
	// x1:R		x21:Y	x22:X	
	movz x10, 0x18, lsl 16
	movk x10, 0x2E3D, lsl 00
	mov x3, 80	
	mov x21, 495		
	mov x22, 140
	bl circle
	movz x10, 0x4A, lsl 16
	movz x10, 0x6F78, lsl 00
	mov x3, 80	
	mov x21, 495		
	mov x22, 160
	bl circle
	

	movz x10, 0x18, lsl 16
	movk x10, 0x2E3D, lsl 00
	mov x3, 80	
	mov x21, 495		
	mov x22, 500
	bl circle
	movz x10, 0x4A, lsl 16
	movz x10, 0x6F78, lsl 00
	mov x3, 80	
	mov x21, 495		
	mov x22, 480
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

	

	// Table triangle
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


	//Rectangle on table
	// x1: X, x2: Y, x3: Width, x4: Height, x10: Color
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


	
	// Button circle
	// x1:R		x21:Y	x22:X
	movz x10, 0x4D, lsl 16
	movk x10, 0xB131, lsl 00
	mov x3, 8	
	mov x21, 455		
	mov x22, 210
	bl circle
	movz x10, 0xFF, lsl 16
	mov x3, 8	
	mov x21, 455		
	mov x22, 232
	bl circle
	movz x10, 0xFF, lsl 16
	mov x3, 8	
	mov x21, 455		
	mov x22, 254
	bl circle
	movz x10, 0xFF, lsl 16
	mov x3, 8	
	mov x21, 455		
	mov x22, 276
	bl circle

	//Little circle, white (ring), grey (inside circle) #1
	movz x10, 0xFF, lsl 16
	movk x10, 0xFFFF, lsl 00
	mov x3, 12	
	mov x21, 395		
	mov x22, 375
	bl circle
	movz x10, 0x4C, lsl 16
	movk x10, 0x4B4B, lsl 00
	mov x3, 10	
	mov x21, 395		
	mov x22, 375
	bl circle
	//Little circle, white (ring), grey (inside circle) #2
	movz x10, 0xFF, lsl 16
	movk x10, 0xFFFF, lsl 00
	mov x3, 12	
	mov x21, 423		
	mov x22, 375
	bl circle
	movz x10, 0x4C, lsl 16
	movk x10, 0x4B4B, lsl 00
	mov x3, 10	
	mov x21, 423		
	mov x22, 375
	bl circle
	//Little circle, white (ring), grey (inside circle) #3
	movz x10, 0xFF, lsl 16
	movk x10, 0xFFFF, lsl 00
	mov x3, 7	
	mov x21, 442		
	mov x22, 500
	bl circle
	movz x10, 0x4C, lsl 16
	movk x10, 0x4B4B, lsl 00
	mov x3, 6	
	mov x21, 442		
	mov x22, 500
	bl circle
	//Little circle, grey (ring), yellow (inside circle)
	movz x10, 0x44, lsl 16
	movk x10, 0x5253, lsl 00
	mov x3, 9	
	mov x21, 456		
	mov x22, 395
	bl circle
	movz x10, 0xFB, lsl 16
	movk x10, 0xC030, lsl 00
	mov x3, 7	
	mov x21, 456		
	mov x22, 395
	bl circle
	//Little circle, grey (ring), red (inside circle)
	movz x10, 0x34, lsl 16
	movk x10, 0x3A45, lsl 00
	mov x3, 9	
	mov x21, 466		
	mov x22, 525
	bl circle
	movz x10, 0xFF, lsl 16
	mov x3, 7	
	mov x21, 466		
	mov x22, 525
	bl circle
	//Little circle, dark-grey (ring), grey (inside circle)
	movz x10, 0x34, lsl 16
	movk x10, 0x3A45, lsl 00
	mov x3, 9	
	mov x21, 446		
	mov x22, 525
	bl circle
	movz x10, 0x80, lsl 16 
	movk x10, 0x8080, lsl 00
	mov x3, 7	
	mov x21, 446		
	mov x22, 525
	bl circle

	//Big circle, white (ring), grey (inside circle)
	movz x10, 0xFF, lsl 16
	movk x10, 0xFFFF, lsl 00
	mov x3, 19	
	mov x21, 458		
	mov x22, 450
	bl circle
	movz x10, 0x4C, lsl 16
	movk x10, 0x4B4B, lsl 00
	mov x3, 13	
	mov x21, 458		
	mov x22, 450
	bl circle

	

	//Circle display
	movz x10, 0x34, lsl 16
	movk x10, 0x3A45, lsl 00
	mov x3, 27	
	mov x21, 412		
	mov x22, 420
	bl circle

	// Bottom white circle trio
	movz x10, 0xFF, lsl 16
	movk x10, 0xFFFF, lsl 00
	mov x3, 8	
	mov x21, 466		
	mov x22, 308
	bl circle
	movz x10, 0xFF, lsl 16
	movk x10, 0xFFFF, lsl 00
	mov x3, 8	
	mov x21, 466		
	mov x22, 328
	bl circle
	movz x10, 0xFF, lsl 16
	movk x10, 0xFFFF, lsl 00
	mov x3, 8	
	mov x21, 466		
	mov x22, 348
	bl circle

	// Starfield
	movz x11, 0xFF, lsl 16
	movk x11, 0xFFFF, lsl 00 // Stars color
	
    mov x23, 287  // Estrellas en circulo de centro (x22, x21) radio x23 por encima de fila x24
	mov x21, 240		
	mov x22, 320
	mov x24, 380
    bl starfield

InfLoop: 
	b InfLoop


/*
  Funcion circle: Dibuja un circulo de radio R en posicion (x,y).
  Registros predefinidos: x3:R, x21:Y, x22:X	
  Registros seteados: 
*/

circle:
		
	//Top left coords
	sub x4, x21, x3 	//i = y-R
	sub x5, x22, x3 	//j	= x-R

	//Bottom right coords
	add x11, x21, x3 	//x11 = y+R
	add x12, x22, x3 	//x12 = x+R	

circle_next_row:		//x0 = x20 +  4*[X + (Y*640)]
	sub x5, x22, x3
	mov x6, SCREEN_WIDTH
	mul x6, x6, x4
	add x6, x6, x5
	lsl x6, x6, #2
	add x0, x20, x6


circle_draw_row:		//IF (i-y)^2 + (j-x)^2 <= R^2	 THEN	draw_pixel(j,i)
	sub x7, x4, x21		//x7 = i - y
	mul x7, x7, x7		//x7 = (i-y)^2
	sub x13, x5, x22 	//x13 = j - x
	mul x13, x13, x13	//x13 = (j-x)^2
	add x7, x7, x13		//x7 = (i-y)^2 + (j-x)^2 
	mul x9, x3, x3		//x9 = R^2
	
	cmp x5, x12
	b.gt cir_continue_next_row

	cmp x7, x9
	b.gt cir_next_pixel
	
	stur w10, [x0]		//Draw actual pixel
	
	b cir_next_pixel

cir_continue_next_row:
	add x4, x4, #1
	cmp x4, x11
	b.le circle_next_row
	ret

cir_next_pixel:
	add x5, x5, #1		//x5 = j + 1		
	add x0, x0, #4		//fb next pixel
	b circle_draw_row


/*
  Funcion Rectangle: Dibuja un cudrado de ancho y alto asignado en las posiciones (x,y).
  Registros predefinidos: x1: X, x2: Y, x3: Width, x4: Height, x10: Color
  Registros seteados: x5:Pixel, x6.
*/

rectangle: 
rectangle_draw_row: //x5 = x20 +  4*[X + (Y*640)]
	mov x5, SCREEN_WIDTH
	mul x5, x2, x5
	add x5, x5, x1
	lsl x5, x5, #2
	add x5, x5, x20
	mov x6, x3
rectangle_draw_col:
		stur w10, [x5]
		add x5, x5, #4
		sub x6, x6, #1
		cbnz x6, rectangle_draw_col
	add x2, x2, #1
	sub x4, x4, #1
	cbnz x4, rectangle_draw_row

	ret


/*
  Funcion Triangulo:
  Registros predefinidos: 
  Registros seteados:
*/ 

triangulo:
	sub sp, sp, 24
	stur lr, [sp]	
	stur x3, [sp, 8]
	stur x4, [sp, 16]
	
	mov x9, x3
	mov x1, x3
	mov x2, x4
	
t_loopy:
	mov x3, x9
t_loopx:
	bl setpixel
	stur w11, [x7]
	add x3, x3, 1
	cmp x3, x1
	b.le t_loopx
	sub x9, x9, 1
	add x1, x1, 1
	add x4, x4, 1
	sub x5, x5, 1
	cbnz x5, t_loopy

	ldur lr, [sp]
	ldur x3, [sp, 8]
	ldur x4, [sp, 16]
	add sp, sp, 24
	br lr
	ret

setpixel:
    sub sp, sp, 48
    stur x6, [sp, 40]
    stur x9, [sp, 32]
    stur lr, [sp, 24] 
	stur x4, [sp, 8]
	stur x3, [sp, 0]    
	
	mov x9, 640
	mul x6, x4, x9
	add x7, x6, x3
	mov x9, 4 
	mul x7, x7, x9              
	add x7, x7, x20
    
    ldur x6, [sp, 40]
    ldur x9, [sp, 32]
    ldur lr, [sp, 24]
	ldur x4, [sp, 8]
	ldur x3, [sp, 0]
	add sp, sp, 48   
	br lr


/*
  Funcion fib: Generador de pares (x1,x2) usando la secuencia de fibonacci, semilla en x9 
  			   (mayor a 15 para mas dispersion).
  Registros predefinidos: 
  Registros seteados: x3, x4, x5, x6, x7.
*/ 

fib:
    mov x12, SCREEN_WIDTH
    mov x13, SCREEN_HEIGH

    mov x7, x9 //copio la semilla por necesito hacer variaciones mas adelante
    movz x3, 0 //caso base
    movz x4, 1 //caso base
l:
    add x5, x3, x4 //suma de los anteriores
    mov x3, x4
    mov x4, x5 // reemplazos
    sub x7, x7, 1 // la idea es correr el algoritmo la cantidad de veces que diga la semilla.
    cbnz x7, l
   
    udiv x6, x3, x12 // Uso aritmetica modular para meter los puntos en la pantalla
    msub x3, x6, x12, x3 // Calculo x3 % width

    udiv x6, x4, x13
    msub x4, x6, x13, x4 // Calculo x4 % height
    
    mov x1, x3 // guardo las posiciones
    mov x2, x4
    ret x30


/*
  Funcion Cuad: Genera un cuadrado en la posicion (x1, x2) de tamaño asignado.
				El cuadrado se genera desde arriba a la izquierda para abajo a la derecha.
  Registros predefinidos: x1: X, x2: Y, x8: Tamaño
  Registros seteados: x3, x4, x5, x6, x7.
  (** Usado solo en fun starfield **)
*/

cuad:
    mov x12, SCREEN_WIDTH
    mov x13, SCREEN_HEIGH
    
    movz x6, 0
    mov x5, x2
l0:
    movz x7, 0
    mov x4, x1
l1:
	mul x3, x12, x5 // x3 = i*N
	add x3, x3, x4 // i*N + j
	add x3, x20, x3, lsl 2 // guardo en x3 la direccion
	
    stur w11,[x3]
    add x4, x4, 1
    add x7, x7, 1
    cmp x7, x8
    b.ne l1
    add x5, x5, 1 
    add x6, x6, 1
    cmp x6, x8
    b.ne l0
    ret x30

    
/*
  Funcion Starfield: Dibuja estrellas dentro de un circulo centrado en (x22, x21) de radio x23, y por encima de la fila x24.
  					 Si (x1, x2) cumple que (x1-x22)^2 + (x2-x21)^2 <= R^2 dibuja una estrella ahi.
  Registros predefinidos:
  Registros seteados: 
*/

starfield:
    mov x8, 1  //tamaño estrella
    mov x9, 15 //semilla inicial
    mov x14, 100 //cantidad de estrellas
    mov x15, x30 //guardo la posicion del branch ya que llamo otra funcion 
pos_estrella:
    bl fib
    add x9, x9, 1
estrella_pertenece:
	sub x4, x2, x21		//x4 = x2 - x21
	mul x4, x4, x4		//x4 = (x2-x21)^2
	sub x5, x1, x22 	//x5 = x1 - x22
	mul x5, x5, x5	    //x5 = (x1-x22)^2
	add x6, x4, x5		//x6 = (x1-x22)^2 + (x2-x21)^2
	mul x7, x23, x23    //x7 = R^2
	
	cmp x6, x7
	b.gt pos_estrella   // Si no cumple, proba con la semilla siguiente
	cmp x2, x24 // Me fijo si pasa la cota en eje y propuesta en x23
	b.gt pos_estrella // si no cumple, probar con la semilla siguiente
	
	
	bl cuad
	sub x14, x14, 1
	cbnz x14, pos_estrella
	ret x15
	
    
    
        
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

