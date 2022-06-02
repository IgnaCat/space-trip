
.equ SCREEN_WIDTH, 		640
.equ SCREEN_HEIGH, 		480
.equ BITS_PER_PIXEL,  	32


.globl main
main:
	mov x20, x0
	movz x10, 0x25, lsl 16
	movk x10, 0x7090, lsl 00

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


	movz x10, 0x19, lsl 16
	movk x10, 0x508E, lsl 00
	mov x1, 310	
	mov x21, 240		
	mov x22, 320
	bl circle
	b draw_new_circle
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


draw_new_circle:
	movz x10, 0x80, lsl 16
	movz x10, 0xB3C9, lsl 00
	mov x1, 295	
	mov x21, 240		
	mov x22, 320
	bl circle
	movz x10, 0x00, lsl 16
	mov x1, 287	
	mov x21, 240		
	mov x22, 320
	bl circle

done:

InfLoop: 
	b InfLoop
