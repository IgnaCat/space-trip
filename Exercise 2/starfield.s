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

/*  
erase_stars: Borra las estrellas que esten en el arreglo de estrellas
Registros predefinidos: x27->array pointer a la base, x4->cantidad de elemento del arreglo
Registros seteados:
*/   
erase_stars:
    ldur x25, [x27] //cargo la direccion de la estrella
    stur xzr, [x25] //la elimino
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

