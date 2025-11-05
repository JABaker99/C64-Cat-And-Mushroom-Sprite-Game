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
        jsr DRAW_TEXT_LINES
        jsr MOVE_CAT
        

program_exit
        rts


; Description: Copy the cat sprite data from CAT_SPRITE_DATA to the sprite memory location defined by CAT_SPRITE_PIXELS.
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

; Description: It calls the individual subroutines to draw rows 5, 12, 17, and 22.
; Inputs: None
; Outputs: None
DRAW_TEXT_LINES
        jsr DRAW_ROW5
        jsr DRAW_ROW12
        jsr DRAW_ROW17
        jsr DRAW_ROW22
        rts

; Description: This subroutine draws the data from ROW5_DATA into row 5 of the screen memory.
; Inputs: 
;    -ROW5_DATA - the character data to be displayed in row 5
; Outputs: 
;    -ROW5_DATA is added to address $04C8
DRAW_ROW5
        ldx #0
DRAW_ROW5_LOOP
        lda ROW5_DATA,x
        sta $04C8,x
        inx
        cpx #40
        bne DRAW_ROW5_LOOP
        rts

; Description: This subroutine draws the data from ROW12_DATA into row 12 of the screen memory.
; Inputs: 
;    -ROW12_DATA - the character data to be displayed in row 12
; Outputs: 
;    -ROW12_DATA is added to address $05E0
DRAW_ROW12
        ldx #0
DRAW_ROW12_LOOP
        lda ROW12_DATA,x
        sta $05E0,x
        inx
        cpx #40
        bne DRAW_ROW12_LOOP
        rts

; Description: This subroutine draws the data from ROW17_DATA into row 17 of the screen memory.
; Inputs: 
;    -ROW17_DATA - the character data to be displayed in row 17
; Outputs: 
;    -ROW17_DATA is added to address $06A8
DRAW_ROW17
        ldx #0
DRAW_ROW17_LOOP
        lda ROW17_DATA,x
        sta $06A8,x
        inx
        cpx #40
        bne DRAW_ROW17_LOOP
        rts

; Description: This subroutine draws the data from ROW22_DATA into row 22 of the screen memory.
; Inputs:
;    -ROW22_DATA - the character data to be displayed in row 22
; Outputs: 
;    -ROW22_DATA is added to address $0770
DRAW_ROW22
        ldx #0
DRAW_ROW22_LOOP
        lda ROW22_DATA,x
        sta $0770,x
        inx
        cpx #40
        bne DRAW_ROW22_LOOP
        rts

; Description: This subroutine continuously moves the cat sprite down the screen by incrementing its Y-coordinate.
; Inputs: None
; Outputs: Updates the Y-coordinate of the cat sprite to move it down.
MOVE_CAT
MOVE_LOOP
        lda $D001
        clc
        adc #5
        sta $D001

        jsr CHECK_COLLISION
        
        jsr WAIT_QUARTER_SECOND
        
        lda $D001
        cmp #245
        bcc MOVE_LOOP

        lda #$20
        sta $D001
        jsr WAIT_QUARTER_SECOND
        jmp MOVE_LOOP
        rts

; Description: When a collision is detected between the cat sprite and the background text. It changes the cat sprite's color to red (by modifying the VIC-II register $D027).
; Inputs: None
; Outputs: 
;    - Sprites color is changed to red
CHECK_COLLISION
        lda $D01F
        and #$01
        bne COLLISION_DETECTED

        lda #$01
        sta $D027

        rts

COLLISION_DETECTED
        lda #$02
        sta $D027

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