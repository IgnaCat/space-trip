/*
  Starfield: Funciones relacionadas con la animacion de las estrellas.
*/
/*
  Pseudocodigo de la estructura del script

  starfield.s:
    fib: Genera pares usando fibonacci.
	init_starfield: Genera estrellas centradas en un radio.
    init_pos: Carga el arreglo de posiciones z.
    erase_stars: Borra estrellas de arreglo.
    update_pos: Actualizo las distancias en z de cada punto

    (*** Detalle de las funciones mas abajo ***)
*/

.equ SCREEN_WIDTH, 		640
.equ SCREEN_HEIGH, 		480
.equ BITS_PER_PIXEL,  	32
.equ UPDATE, 65000 //for delay
.globl fib
.globl init_starfield
.globl init_pos
.globl erase_stars
.globl update_pos
.globl draw_planet1
.globl cutted_circle


draw_planet1:
    ldr x28, =sign_update
    ldur x15, [x28]
    cmp x15, 5
    b.eq planet_cont0
    cmp x15, 15
    b.eq planet_cont0
    ret x30
planet_cont0:    
    mov x15, x30
    movz x10, 0x9F, lsl 16
	movk x10, 0x4000, lsl 00
	ldr x4, =planet_size
	ldr x5, =eje_planeta
		
	ldur x3, [x4]
	cmp x3, 200    //SIZE LIMIT
	b.ne planet_cont1
	movz x3, 199
planet_cont1:	
	add x3, x3, 1
	stur x3, [x4]
	
	ldur x22, [x5]
	cmp x22, 650   //x axis limit
	b.ne planet_cont2
	movz x22, 649
planet_cont2:
	add x22, x22, 1
	stur x22, [x5]
	
	mov x21, 50		
	mov x8, 287
	mov x23, 240		
	mov x24, 320
	bl cutted_circle
    ret x15


/*
  Funcion cutted_circle: Dibuja un circulo de radio R en posicion (x,y) dentro de otro circulo
  Registros predefinidos: x3:R1, x21:Y1, x22:X1, x8:R2, x23:Y2, x24:X2, 	
  Registros seteados: 
*/

cutted_circle:
		
	//Top left coords
	sub x4, x21, x3 	//i = y-R
	sub x5, x22, x3 	//j	= x-R

	//Bottom right coords
	add x11, x21, x3 	//x11 = y+R
	add x12, x22, x3 	//x12 = x+R	

cutted_circle_next_row:		//x0 = x20 +  4*[j + (i*640)]
	sub x5, x22, x3
	mov x6, SCREEN_WIDTH
	mul x6, x6, x4
	add x6, x6, x5
	lsl x6, x6, #2
	add x0, x20, x6


cutted_circle_draw_row:		//IF (i-y1)^2 + (j-x1)^2 <= R1^2	 THEN	draw_pixel(j,i)
	sub x7, x4, x21		//x7 = i - y1
	mul x7, x7, x7		//x7 = (i-y1)^2
	sub x13, x5, x22 	//x13 = j - x1
	mul x13, x13, x13	//x13 = (j-x1)^2
	add x7, x7, x13		//x7 = (i-y1)^2 + (j-x1)^2 
	mul x9, x3, x3		//x9 = R1^2
	
	cmp x5, x12
	b.gt cutted_cir_continue_next_row 

	cmp x7, x9 //compare for original circle 1
	b.gt cutted_cir_next_pixel
	
    sub x7, x4, x23		//x7 = i - y2
	mul x7, x7, x7		//x7 = (i-y2)^2
	sub x13, x5, x24 	//x13 = j - x2
	mul x13, x13, x13	//x13 = (j-x2)^2
	add x7, x7, x13		//x7 = (i-y2)^2 + (j-x2)^2 
	mul x9, x8, x8		//x9 = R2^2
	
	cmp x7, x9
	b.gt cutted_cir_next_pixel //compare for external circle 2
	
	stur w10, [x0]		//Draw actual pixel
	
	b cutted_cir_next_pixel

cutted_cir_continue_next_row:
	add x4, x4, #1
	cmp x4, x11
	b.le cutted_circle_next_row
	ret

cutted_cir_next_pixel:
	add x5, x5, #1		//x5 = j + 1		
	add x0, x0, #4		//fb next pixel
	b cutted_circle_draw_row    
    
    

/*
  Funcion fib: Generador de pares (x1,x2) usando la secuencia de fibonacci, semilla en x9 (mayor a 15 para mas dispersion).
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
  Sub-funcion de rectangulo, setea ancho=largo=1 y color blanco
*/
estrella: 
    mov x16, x30 //guardo direccion de salto
    movz x3, 1
    movz x4, 1
    movz x10, 0xFF, lsl 16
	movk x10, 0xFFFF, lsl 00
	bl rectangle
	sub x5, x5, #4
	ret x16

/*
Starfield: Genera estrellas centradas en un radio, segun las distancias z del arreglo y por encima de la fila x24.
mueve el eje coordenadas de cada par (x1, x2) que se genera con radio x23, para usar (x22, x21) como centro
Luego se divide el par por la distancia z guardada en memoria, y por ultimo se la suma a (x22, x21)
Guardo la direccion de cada estrella que se pinto en un arreglo.

Registros predefinidos: x21, x22, x23 //correspone al centro (x22, x21) y radio x23 en el que se genera y fila sobre la que se dibuja x24
Registros seteados: x1, x2, x3, x4, x5, x6, x7, x8, x9, x14, x15, x16, x19, x24, x27
*/
init_starfield:
    mov x9, 15 //semilla inicial
    mov x14, 300 //cantidad de estrellas
    mov x15, x30 //guardo la posicion del branch ya que llamo otra funcion 
    mov x27, x26 //copio la base del arreglo de direcciones de estrellas
    mov x19, x18 //copio la base del arreglo de posiciones z de estrellas
    mov x24, 380 
init_pos_estrella:
    bl fib          //genero un par x1,x2
    add x9, x9, 1    //aumento semilla
init_estrella_pertenece: //calculo para ver si el punto entra en el circulo de centro y radio dado
	sub x4, x2, x21		//x4 = x2 - x21
	mul x4, x4, x4		//x4 = (x2-x21)^2
	sub x5, x1, x22 	//x5 = x1 - x22
	mul x5, x5, x5	    //x5 = (x1-x22)^2
	add x6, x4, x5		//x6 = (x1-x22)^2 + (x2-x21)^2
	mul x7, x23, x23    //x7 = R^2
	
	cmp x6, x7
	b.gt init_pos_estrella   // Si no cumple, proba con la semilla siguiente
    cmp x2, x24 // Me fijo si pasa la cota en eje y propuesta en x24
	b.gt init_pos_estrella // si no cumple, probar con la semilla siguiente
	
	
	ldur x16, [x19] // x16 = distancia z
	sub x1, x1, x22 //centro con respecto a (x22, x21) cada coordenada
	sub x2, x2, x21
		
	sdiv x1, x1, x16 
	add x1, x1, x22
	
	sdiv x2, x2, x16 //divido por correspondiente z
	add x2, x2, x21 //sumo centro
	
	bl estrella //genero la estrella
    stur x5, [x27] //guardo la direccion de la estrella generada 
    add x27, x27, 8 //avanzo de posicion en mis arreglos   
    add x19, x19, 8
	sub x14, x14, 1
	cbnz x14, init_pos_estrella 
	ret x15

/*
init_pos: Carga el arreglo de posiciones z con valores distribuidos desde el 1 a la maxima distancia
Registros predefinidos: x19->array pointer a la base, x4->cantidad de elemento del arreglo
Registros seteados: x17
*/
init_pos:
    movz x17, 1 //z
bucle:
    stur x17, [x19] //guardo z
    add x19, x19, 8 //siguiente posicion 
    sub x17, x17, 1 //z = z-1
    cmp x17, 0
    b.ne conttt //si z = 0 reset
    movz x17, 15 //MAXIMA DISTANCIA INICIAL EN Z
conttt:
    sub x4, x4, 1
    cbnz x4, bucle 
    ret x30

// Borra las estrellas que esten en el arreglo de estrellas
/*
Registros predefinidos: x27->array pointer a la base, x4->cantidad de elemento del arreglo
Registros seteados:
*/   
erase_stars:
    ldur x25, [x27] //cargo la direccion de la estrella
    ldr x15, =buffer_copy
    //x25 = x20 +  4*[X + (Y*640)]
    sub x25, x25, x20 //x3 = 4*[X + (Y*640)]
    lsl x25, x25, 1 //x3 = cantidad de veces q avanzo en la copia del frame para encontrar el color q habia    
    add x15, x15, x25 //x15 = direccion con el color
    
    ldur x6, [x15]
    ldur x25, [x27]
    stur x6, [x25] //la elimino
    add x27, x27, 8 //siguiente
    sub x4, x4, 1
    cbnz x4, erase_stars
    ret x30 

/*
update_pos: Actualizo las distancias en z de cada punto
Registros predefinidos: x19->array pointer a la base, x4->cantidad de elemento del arreglo
Registros seteados: x17
*/     
update_pos:
    ldur x17, [x19] //x17 = z actual 
    sub x17, x17, 1 //z = z-1
    cmp x17, 0
    b.ne continue
    movz x17, 20// MAXIMA DISTANCIA GENERAL EN Z
continue:
    stur x17, [x19]
    add x19, x19, 8
    sub x4, x4, 1
    cbnz x4, update_pos 
    ret x30

