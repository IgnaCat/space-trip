/*
  Nave viaje en el tiempo
  Dibuja la cabina de una nave espacial, la cual contiene un gran vental con vista a las estrellas
  y una mesa representando el panel de control, todo viendolo en primera persona.
*/

/*
  Pseudocodigo de la estructura del script

  apps.s:
  	main: Llamados principales a las funciones de cabina y starfield.
  cabin.s:
	cabin: Llamados a las funciones para la creacion de la cabina, se realizan seteos de registros.
  graphic.s:
	circle: Dibuja un circulo.
	rectangle: Dibuja un rectangulo.
	triangle: Dibuja un triangulo.
	delay: Genera delay.
  starfield.s:
    fib: Genera pares usando fibonacci.
	init_starfield: Genera estrellas centradas en un radio.
    init_pos: Carga el arreglo de posiciones z.
    erase_stars: Borra estrellas de arreglo.
    update_pos: Actualizo las distancias en z de cada punto.
*/

/* Lista de registros:
  - Reg[x0]:
  - Reg[x1]: X
  - Reg[x2]: Y
  - Reg[x10]: Color

  ( Los demas registros son de uso variable por lo que sera detallado antes de su utilizacion )
*/

.equ SCREEN_WIDTH, 		640
.equ SCREEN_HEIGH, 		480
.equ BITS_PER_PIXEL,  	32

.data

.balign 8
.globl stars_array
.globl pos_array
.globl sign_update
.globl planet_size
.globl eje_planeta
.globl buffer_copy



stars_array:  .skip 2400  //8*600 direcciones de estrellas a guardar
pos_array: .skip 2400     //8*600 posiciones z de estrellas a guardar
sign_update: .skip 8 
planet_size: .skip 8 //tamaño planeta
eje_planeta: .skip 8 //eje planeta
buffer_copy: .skip 2457600 // para guardar colores de la pantalla

.globl main
main:
    ldr x26,=stars_array
    ldr x18,=pos_array
    
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
    
	bl cabin
    
    mov x6, 450
    ldr x5, =eje_planeta
    stur x6, [x5]
    
    ldr x15, = buffer_copy
    mov x0, x20
    bl copy_background
    
    bl signo_peligro
    ldr x28, =sign_update
    stur xzr, [x28]//inicio contador para signo peligro
    
    mov x19, x18 //base posiciones
    movz x4, 300 //cant elems
    bl init_pos  //genero las posiciones en z
    
    movz x22, 320 // Uso (x22, x21 como origen)
    movz x21, 240
    movz x23, 287 //Este es el radio
    bl init_starfield //Genero la primera tanda de estrellas
    
//Loop general
infloop:
    ldr x28, =sign_update
    bl update_danger_sign
    bl draw_planet1
    //Estrellas
    movz x4, 300 // cantidad de elemento de mi arreglo (cantidad de estrellas)
    mov x27, x26 
    bl erase_stars //borro las estrellas
    
    mov x19, x18 //copy base
    movz x4, 300 // cantidad de elemento de mi arreglo (cantidad de estrellas)
    bl update_pos //actualizo la posicion de las estrellas
    
    ldr x15, = buffer_copy
    mov x0, x20
    bl copy_background //copio colores del frame
    
    movz x22, 320 // Uso (x22, x21 como origen)
    movz x21, 240
    movz x23, 287 //Este es el radio
    bl init_starfield //pinto las estrellas
    movz x4, 400 //ACA DEFINO EL DELAY
delayr:
    bl delay
    sub x4, x4, 1
    cmp x4, 0
    b.ne delayr
      
    b infloop


//copia los colores en pantalla en memoria, hacer x0 un puntero al frame buffer, y x15 un puntero al arreglo de colores
//setea x1, x2, x3
copy_background:
	mov x2, SCREEN_HEIGH         // Y Size 
looop1:
	mov x1, SCREEN_WIDTH         // X Size
looop0:
	ldur x3,[x0]	   // x3 = color pixel en dire x0
	stur x3, [x15]
	add x0,x0,4	   // Next pixel
	add x15,x15,8	
	sub x1,x1,1	   // decrement X counter
	cbnz x1,looop0	   // If not end row jump
	sub x2,x2,1	   // Decrement Y counter
	cbnz x2,looop1	   // if not last row, jump
    ret x30


update_danger_sign:
    mov x15, x30
    ldur x4, [x28]
    cmp x4, 10 // cuando el contador sea 10 apago la pantalla
    b.eq apagar
    cmp x4, 20 // cuando sea 20 prendo la pantalla
    b.eq prender
    b sign_cont
apagar:
    bl black_display1
    b sign_cont
prender:
    stur xzr, [x28]
    bl signo_peligro
sign_cont:
    ldur x4, [x28]
    add x4, x4, 1
    stur x4, [x28]
    ret x15

signo_peligro:
    mov x16, x30
    movz x2, 153
    movz x1, 454
    mov x3, 15
    movz x10, #0xFF, lsl 16
    bl circle
    movz x1, 151
    movz x2, 443
    movz x3, 5
    movz x4, 17
    mov x10, xzr
    bl rectangle
    movz x2, 153
    movz x1, 464   
    mov x3, 3
    bl circle  
	ret x16

black_display1:
    mov x16, x30
	movz x1, 126
	movz x2, 437
	movz x3, 55
	movz x4, 35
	mov x10, xzr
	bl rectangle
	ret x16

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

    

    
    
    
    
    
    
    
    
    
    

