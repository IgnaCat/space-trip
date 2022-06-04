
.equ SCREEN_WIDTH, 		640
.equ SCREEN_HEIGH, 		480
.equ BITS_PER_PIXEL,  	32


.globl main
main:
	mov x20, x0
	movz x10, 0x0C, lsl 16
	movz x10, 0x191E, lsl 00 // Background color

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

	// Window circle
	// x1:R		x21:Y	x22:X	
	movz x10, 0x18, lsl 16
	movk x10, 0x2E3D, lsl 00
	mov x1, 310	
	mov x21, 240		
	mov x22, 320
	bl circle
	movz x10, 0x48, lsl 16
	movz x10, 0x6C7B, lsl 00
	mov x1, 295	
	mov x21, 240		
	mov x22, 320
	bl circle
	mov x10, 0x000000
	mov x1, 287	
	mov x21, 240		
	mov x22, 320
	bl circle

	//Rectangle Tables
	// x1: X, x2: Y, x3: Width, x4: Height, x10: Color
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
	//mov x10, 0xFF0000 // Descomentar para ver en rojo la mesa del costado
	//bl rectangle // Descomentar para ver las mesas del costado
	sub x1, x1, 320
	movz x2, 420
	movz x3, 100
	movz x4, 60
	movz x10, 0x4A, lsl 16
	movz x10, 0x6F78, lsl 00
	//mov x10, 0xFF0000
	//bl rectangle
	


InfLoop: 
	b InfLoop


circle:	// x1:R		x21:Y	x22:X		

	//C(X,Y)
		
	//Top left coords
	sub x4, x2, x1 	//i = y-R
	sub x5, x22, x1 	//j	= x-R

	//Bottom right coords
	add x11, x21, x1 	//x11 = y+R
	add x12, x22, x1 	//jx12 = x+R	

circle_next_row:		//x0 = x20 +  4*[X + (Y*640)]
	sub x5, x22, x1
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
	mul x9, x1, x1		//x9 = R^2
	
	cmp x5, x12
	b.gt cir_continue_next_row

	cmp x7, x9
	b.gt cir_next_pixel
	
	str x10, [x0]		//Draw actual pixel
	
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


rectangle: // x1: X, x2: Y, x3: Width, x4: Height, x10: Color
rectangle_draw_row: //x5 = x20 +  4*[X + (Y*640)]
	mov x5, SCREEN_WIDTH
	mul x5, x2, x5
	add x5, x5, x1
	lsl x5, x5, #2
	add x5, x5, x20
	mov x6, x3
rectangle_draw_col:
		str x10, [x5]
		add x5, x5, #4
		sub x6, x6, #1
		cbnz x6, rectangle_draw_col
	add x2, x2, #1
	sub x4, x4, #1
	cbnz x4, rectangle_draw_row

	ret



