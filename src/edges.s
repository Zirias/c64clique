.export addedge
.export edgeexists

.code

addedge:
		tay
		lda	numedges
		bne	ae_numok
		lda	#$20
		cmp	numedges+1
		beq	ae_error
		lda	numedges
ae_numok:	sta	ae_destal
		sta	ae_destbl
		lda	numedges+1
		ora	#>edgesa
		sta	ae_destah
		eor	#$e0
		sta	ae_destbh
ae_destal	= *+1
ae_destah	= *+2
		sty	$ffff
ae_destbl	= *+1
ae_destbh	= *+2
		stx	$ffff
		inc	numedges
		bne	ae_ok
		inc	numedges+1
ae_ok:		clc
ae_error:	rts

edgeexists:
		stx	eevala
		sty	eevalb
		lda	numedges+1
		ora	#>edgesa
		sta	ee_ldea
		eor	#(>edgesa ^ >edgesb)
		sta	ee_ldeb
		ldx	numedges
ee_loop:	dex
		cpx	#$ff
		bne	ee_check
		ldy	ee_ldea
		dey
		cpy	#>edgesa
		bpl	ee_nextpage
		clc
		rts
ee_nextpage:	sty	ee_ldea
		dec	ee_ldeb
ee_ldea		= *+2
ee_check:	lda	$ff00,x
		cmp	eevala
		beq	ee_check2
		cmp	eevalb
		bne	ee_loop
ee_ldeb		= *+2
ee_check2:	lda	$ff00,x
		cmp	eevala
		beq	ee_found
		cmp	eevalb
		bne	ee_loop
ee_found:	sec
		rts

.bss

numedges:	.res	2
eevala:		.res	1
eevalb:		.res	1

.segment "EDGESA"

edgesa:		.res	$2000

.segment "EDGESB"

edgesb:		.res	$2000

