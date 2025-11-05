; ============================
; Author: Jacob Baker
; Version: Fall 2025
; ============================

; 10 SYS (2304)

*=$0801

        BYTE    $0E, $08, $0A, $00, $9E, $20, $28,  $32, $33, $30, $34, $29, $00, $00, $00

*=$0900

CAT_SPRITE_PIXELS=$2E80
MUSHROOM_SPRITE_PIXELS=CAT_SPRITE_PIXELS+64

; address of the PRINTLINE routine in the kernel
PRINTLINE=$AB1E
PROGRAM_START

        ; clear the screen
        lda #<CLEAR_CHAR
        ldy #>CLEAR_CHAR
        jsr PRINTLINE
; start your code here

        jsr COPY_CAT_SPRITE
        

program_exit
        rts


; Description: Copy the cat sprite data from CAT_SPRITE_DATA to the sprite memory location defined by CAT_SPRITE_PIXELS
; Inputs:     
;    -CAT_SPRITE_DATA - starting address of the cat sprite bytes
; Outputs:    
;    -CAT_SPRITE_PIXELS - memory location where the cat sprite bytes are copied
COPY_CAT_SPRITE
        ldx #0
COPY_LOOP
        lda CAT_SPRITE_DATA,x
        sta CAT_SPRITE_PIXELS,x
        inx
        cpx #64
        bne COPY_LOOP

        lda #$BA
        sta $07F8

        lda #1
        sta $D027

        lda #100
        sta $D000
        lda #50
        sta $D001

        lda #%00000001
        sta $D015

        rts






; please don't change anything after this line.
; bad stuff will happen
CLEAR_CHAR
        ; the clearscreen character
        BYTE 147 
        ; carriage return & terminate the string
        BYTE 13, 00 


; internal variable for WAIT
JIFFY_COUNTER BYTE 00

; Pauses the program for approximately 1 second
WAIT_QUARTER_SECOND
        ; save stack
        php 
        pha 
        txa 
        pha
        tya 
        pha

; count up one quarter second
        lda $A2 
        adc #15 
        sta JIFFY_COUNTER

count_jiffies_loop
        lda $A2 
        cmp JIFFY_COUNTER
        bne count_jiffies_loop


; repair register state
        pla 
        tay
        pla 
        tax
        pla 
        plp 

        rts


; Screen 1 -  Screen data
ROW5_DATA
        BYTE    $7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F
ROW12_DATA
        BYTE    $53,$53,$53,$53,$53,$53,$53,$53,$53,$53,$53,$53,$53,$53,$53,$53,$53,$53,$53,$53,$53,$53,$53,$53,$53,$53,$53,$53,$53,$53,$53,$53,$53,$53,$53,$53,$53,$53,$53,$53
ROW17_DATA
        BYTE    $3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D
ROW22_DATA
        BYTE    $5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F

; sprite data
MUSHROOM_SPRITE_DATA
 BYTE $07,$FF,$E0
 BYTE $0F,$FF,$F0
 BYTE $19,$80,$18
 BYTE $30,$31,$8C
 BYTE $60,$31,$86
 BYTE $63,$00,$06
 BYTE $E3,$06,$07
 BYTE $C0,$06,$63
 BYTE $CC,$30,$63
 BYTE $CC,$30,$03
 BYTE $C1,$86,$1B
 BYTE $7F,$FF,$FE
 BYTE $1F,$FF,$F8
 BYTE $08,$00,$08
 BYTE $08,$C3,$08
 BYTE $08,$00,$08
 BYTE $08,$00,$08
 BYTE $08,$42,$08
 BYTE $08,$3C,$08
 BYTE $0C,$00,$18
 BYTE $07,$FF,$F0
 BYTE $00

CAT_SPRITE_DATA
 BYTE $70,$00,$0E
 BYTE $8C,$00,$31
 BYTE $B2,$00,$4D
 BYTE $BB,$00,$DD
 BYTE $B9,$FF,$9D
 BYTE $B7,$FF,$ED
 BYTE $AF,$FF,$F5
 BYTE $9F,$7E,$F9
 BYTE $7E,$BD,$7E
 BYTE $3D,$DB,$BC
 BYTE $7F,$FF,$FF
 BYTE $FF,$FF,$FF
 BYTE $FF,$E7,$FF
 BYTE $FF,$FF,$FF
 BYTE $FF,$FF,$FF
 BYTE $FF,$7E,$FF
 BYTE $FF,$BD,$FF
 BYTE $FF,$DB,$FF
 BYTE $7F,$E7,$FE
 BYTE $3F,$FF,$FC
 BYTE $0F,$FF,$F8
 BYTE $00