/*
  Cabina: Funciones para la creacion de la misma.
*/
/*
  Pseudocodigo de la estructura del script

  cabin.s:
    circle: Dibuja un circulo.
	rectangle: Dibuja un rectangulo.
	triangle: Dibuja un triangulo.
    fib: Genera pares usando fibonacci.
	starfield: Dibuja estrellas.

    (*** Detalle de las funciones mas abajo ***)
*/

.equ SCREEN_WIDTH, 		640
.equ SCREEN_HEIGH, 		480
.equ BITS_PER_PIXEL,  	32
.globl circle
.globl rectangle
.globl fib
.globl starfield
.globl triangulo

/*
  Funcion circle: Dibuja un circulo de radio R en posicion (x,y).
  Registros predefinidos: x1:Y, x2:X, x3:R
  Registros seteados: 
*/

circle:
		
	//Top left coords
	sub x4, x1, x3 	//i = y-R
	sub x5, x2, x3 	//j	= x-R

	//Bottom right coords
	add x11, x1, x3 	//x11 = y+R
	add x12, x2, x3 	//x12 = x+R	

circle_next_row:		//x0 = x20 +  4*[X + (Y*640)]
	sub x5, x2, x3
	mov x6, SCREEN_WIDTH
	mul x6, x6, x4
	add x6, x6, x5
	lsl x6, x6, #2
	add x0, x20, x6


circle_draw_row:		//IF (i-y)^2 + (j-x)^2 <= R^2	 THEN	draw_pixel(j,i)
	sub x7, x4, x1		//x7 = i - y
	mul x7, x7, x7		//x7 = (i-y)^2
	sub x13, x5, x2 	//x13 = j - x
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
  Funcion Starfield: Dibuja estrellas dentro de un circulo centrado en (x22, x21) de radio x23, y por encima de la fila x24.
  Si (x1, x2) cumple que (x1-x22)^2 + (x2-x21)^2 <= R^2 dibuja una estrella ahi.
  Registros usados: x1, x2, x3, x4, x5, x6, x7, x8, x9, x14, x15, x22, x23, x24.
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
	
	movz x3, 1
	movz x4, 1
	bl rectangle
	sub x14, x14, 1
	cbnz x14, pos_estrella
	ret x15

