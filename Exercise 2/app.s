/*
  Nave viaje en el tiempo
  Dibuja la cabina de una nave espacial, la cual contiene un gran vental con vista a las estrellas
  y una mesa representando el panel de control, todo viendolo en primera persona.
*/

/*
  Pseudocodigo de la estructura del script

  apps.s:
  	main: Llamados principales a las funciones de cabina y starfield.
    copy_background: Copia los colores en pantalla en memoria (subframe).
    update_danger_sign: Animacion signo de peligro.
    signo_peligro: Dibuja signo peligro.
    update_leds: Animacion botones/leds.
    red_leds: Dibuja todos los leds en rojo de abajo de las pantallas.
    change_leds: Cambia los colores de los leds en la esquina inferior derecha.
    red_trio: Cambia los colores de los leds inferiores.
    yellow_led: Dibuja el led en rojo.
    display_animation: Animacion en la pantalla/display del panel.
    draw_rect: Dibuja linea azul en el display.
    draw_shadow: Restura color que habia en el fondo.
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
.globl leds_update
.globl planet_size
.globl eje_planeta
.globl buffer_copy
.globl rectangle_array


rectangle_array:  .skip 800 //100 direcciones de estrellas a guardar
stars_array:  .skip 2400  //600 direcciones de estrellas a guardar
pos_array: .skip 2400     //600 posiciones z de estrellas a guardar
sign_update: .skip 8 
leds_update: .skip 8
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
    
    mov x6, 350
    ldr x5, =eje_planeta
    stur x6, [x5]
    
    ldr x15, = buffer_copy
    mov x0, x20
    bl copy_background
    
    bl signo_peligro
    ldr x28, =sign_update
    stur xzr, [x28]//inicio contador para signo peligro

    bl red_leds
	ldr x25, =leds_update
    stur xzr, [x25]//inicio contador para leds
    
    mov x19, x18 //base posiciones
    movz x4, 300 //cant elems
    bl init_pos  //genero las posiciones en z
    
    movz x22, 320 // Uso (x22, x21 como origen)
    movz x21, 240
    movz x23, 287 //Este es el radio
    bl init_starfield //Genero la primera tanda de estrellas

	mov x29, #258	//Posicion X de barrra de carga en display 3
	
    
//Loop general de la animacion.

infloop:
    ldr x28, =sign_update
    bl update_danger_sign

    ldr x25, =leds_update
	bl update_leds

    add x29, x29, #2
	ldr x24,=rectangle_array
    bl display_animation

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

/*
Copia los colores en pantalla en memoria, hacer x0 un puntero al frame buffer, y x15 un puntero al arreglo de colores
Setea x1, x2, x3
*/

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
    cmp x4, 10    // cuando el contador sea 10 apago la pantalla
    b.eq apagar
    cmp x4, 20    // cuando sea 20 prendo la pantalla
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

update_leds:
    mov x14, x30
    ldur x8, [x25]
    cmp x8, 10    // cuando el contador sea 10 restauro leds
    b.eq restaurar_leds
    cmp x8, 20    // cuando sea 20 prendo leds rojos
    b.eq prender_leds
    b leds_cont
restaurar_leds:
	// funs en cabin.s
    bl create_leds   // Creo leds abajo de displays
	bl left_leds
	bl red_trio   // Pongo los leds de las esquinas del led trio en rojo
	bl red_yellow_led   // Pongo led amarillo en rojo
    b leds_cont
prender_leds:
    stur xzr, [x25]
    bl red_leds   // Leds abajo display en rojo
	bl change_leds   // Cambio los colores de los leds izquierdos
	bl led_trio   // Led trio del medio en rojo
	bl yellow_led   // Led en amarillo
leds_cont:
    ldur x8, [x25]
    add x8, x8, 1
    stur x8, [x25]
    ret x14

red_leds:
	mov x17, x30
	// Rectangle LEDs between buttons and displays
    // Los seteamos todos en color rojo
	movz x1, 226
	movz x2, 431
	movz x3, 10
	movz x4, 7
	movz x10, #0xFF, lsl 16
	bl rectangle	//Green led
	movz x1, 240
	movz x2, 431
	movz x3, 10
	movz x4, 7
	bl rectangle	//Green led
	movz x1, 254
	movz x2, 431
	movz x3, 10
	movz x4, 7
	bl rectangle	//Yellow led
	movz x1, 268
	movz x2, 431
	movz x3, 10
	movz x4, 7
	bl rectangle	//Yellow led
	movz x1, 282
	movz x2, 431
	movz x3, 10
	movz x4, 7
	bl rectangle	//Green led
	movz x1, 296
	movz x2, 431
	movz x3, 10
	movz x4, 7
	bl rectangle	//White led
	movz x1, 310
	movz x2, 431
	movz x3, 10
	movz x4, 7
	bl rectangle	//White led
	movz x1, 324
	movz x2, 431
	movz x3, 10
	movz x4, 7
	bl rectangle	//Yellow led
	movz x1, 338
	movz x2, 431
	movz x3, 10
	movz x4, 7
	bl rectangle	//Green led

	ret x17

change_leds:
	mov x17, x30
	//Little circle, grey (ring), grey (inside circle)
	mov x1, 466		
	mov x2, 525
	mov x3, 9
	movz x10, 0x34, lsl 16
	movk x10, 0x3A45, lsl 00
	bl circle
	mov x1, 466		
	mov x2, 525
	mov x3, 7
	movz x10, 0x80, lsl 16 
	movk x10, 0x8080, lsl 00
	bl circle
	//Little circle, dark-grey (ring), red (inside circle)
	mov x1, 446		
	mov x2, 525
	mov x3, 9	
	movz x10, 0x34, lsl 16
	movk x10, 0x3A45, lsl 00
	bl circle		
	mov x1, 446		
	mov x2, 525
	mov x3, 7
	movz x10, 0xFF, lsl 16
	bl circle

	ret x17

red_trio: 
	mov x15, x30
	mov x1, 466		
	mov x2, 308
	mov x3, 8
	movz x10, #0xFF, lsl 16
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
	movz x10, #0xFF, lsl 16
	bl circle

	ret x15

red_yellow_led:
	mov x15, x30
	mov x1, 456		
	mov x2, 395
	mov x3, 7
	movz x10, #0xFF, lsl 16
	bl circle

	ret x15
	
/*
Animacion de linea de carga de display, avanza su posicion en eje x y restaura el color de fondo.
*/
display_animation:
	mov x15, x30
	mov x27, x24	// x27 = rectangle_array[0]
	
	mov x7, #348	//tope X
	sub x7, x7, x29
	cbz x7, if_rect_limit
	mov x12, x29
	b if_not_rect_limit
if_rect_limit:
	mov x29, 260
    mov x12, x29
if_not_rect_limit:
	movz x1, 396
	movz x2, 4
	movz x3, 20
	movz x4, 0x1B, lsl 16
	movk x4, 0xF3F9, lsl 00
	bl draw_rect

	movz x9, 100
	mov x27, x26	// x27 = rectangle_array[0]
	bl draw_shadow

	ret x15

/*
Dibuja linea azul en el display y guarda posiciones del pixel en rectangle_array.
*/
draw_rect: // x12: X, x1: Y, x2: W, x3: H, x4: Color
	
loop_fila: 
	mov	   x5, SCREEN_WIDTH
	mul    x5, x1, x5
	add    x5, x5, x12
	lsl	   x5, x5, #2
	add    x5, x5, x20
	mov    x6, x2
	stur x5, [x27]		// Guardo la posicion del pixel que se va a pintar en x27
	ldr x13, [x5]		// x13 = color del pixel en la direccion x5
	add x27, x27, #8	// Siguiente posicion del rectangle_array
loop_col: 
		stur w4, [x5]
		add x5, x5, #4
		sub x6, x6, #1
		cbnz x6, loop_col
	add x1, x1, #1
	sub x3, x3, #1
	cbnz x3, loop_fila
	ret

/*
Borra linea gruesa azul y setea color del fondo de la pantalla
*/
draw_shadow:
    mov x17, x30
	ldr x25, [x24]
	movz x10, 0x4E, lsl 16
	movk x10, 0x8462, lsl 00
	stur w10, [x25]
	add x24, x24, #8
	sub x9, x9, #1
	cbnz x9, draw_shadow
	ret x17
