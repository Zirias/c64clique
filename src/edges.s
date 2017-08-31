.export addedge

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
		
.bss

numedges:	.res	2

.segment "EDGES"

edgesa:		.res	$2000
edgesb:		.res	$2000
