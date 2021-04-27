;
; freg.asm - aggressive tests to see if Z-80's F really has 8 bits or not.
;
; Did not fall into any error cases on my TRS-80 Model I
; implying F register has a full 8 bits.
;

	org	$8000
stack:
start:	di
	call	init

; Let all possible values sit in F for over 65,000 instructions.

	ld	b,0
test1:	ld	c,b
	push	bc
	push	bc
	pop	af

	ld	b,0
hold:	exx
	ld	b,0
	djnz	$
	exx
	djnz	hold

	push	af
	pop	de
	pop	bc

	ld	a,c
	cp	e
	jp	nz,err1

	djnz	test1


; See if F bits change as we swap around.

	ld	bc,0
	push	bc
	dec	bc
	push	bc
	ex	af,af'
	pop	af		; F' = $FF
	ex	af,af'
	pop	af		; F = 0
	ex	af,af'
	push	af		; F' ($FF) on stack
	ex	af,af'
	push	af		; F (0) on stack
	pop	bc
	ld	a,c
	cp	0
	jr	nz,err2	
	pop	bc
	ld	a,c
	cp	$ff
	jr	nz,err2

	jp	done

; Routines for the TRS-80 Model I or III.

init:	ld	hl,$3c00
	push	hl
	ld	de,$3c00+1
	ld	bc,$400-1
	ld	(hl),' '
	ldir
	pop	hl
	ret

done:	ret

err1:	ld	(hl),'1'
	inc	hl
	inc	hl
	call	hex

	jr	$

err2:	ld	(hl),'2'
	inc	hl
	inc	hl
	call	hex

	jr	$

hex:	push	af
	rrca
	rrca
	rrca
	rrca
	call	hex1
	pop	af
hex1:	and	15
	cp	10
	sbc	69h
	daa
	ld	(hl),a
	inc	hl
	ret

	end	start
