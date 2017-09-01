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
		ora	#>edgesb
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
		lda	numedges+1
		sta	edgepos+1
		lda	numedges
		sta	edgepos
ee_loop:	dec	edgepos
		lda	edgepos
		sta	ee_cpx1l
		sta	ee_cpx2l
		sta	ee_cpy1l
		sta	ee_cpy2l
		cmp	#$ff
		bne	ee_check
		dec	edgepos+1
		bpl	ee_check
		clc
		rts
ee_check:	lda	edgepos+1
		ora	#>edgesa
		sta	ee_cpx1h
		sta	ee_cpy2h
		ora	#>edgesb
		sta	ee_cpx2h
		sta	ee_cpy1h
ee_cpx1l	= *+1
ee_cpx1h	= *+2
		cpx	$ffff
		bne	ee_check2
ee_cpy1l	= *+1
ee_cpy1h	= *+2
		cpy	$ffff
		beq	ee_found
ee_cpx2l	= *+1
ee_cpx2h	= *+2
ee_check2:	cpx	$ffff
		bne	ee_loop
ee_cpy2l	= *+1
ee_cpy2h	= *+2
		cpy	$ffff
		bne	ee_loop
ee_found:	sec
		rts
		
.bss

numedges:	.res	2
edgepos:	.res	2

.segment "EDGESA"

edgesa:		.res	$2000

.segment "EDGESB"

edgesb:		.res	$2000

