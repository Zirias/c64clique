.export parsenums
.export inputnum1
.export inputnum2

.import nc_string
.import nc_num
.import stringtonum

CHROUT		= $ffd2
GETIN		= $ffe4
MAXLINE		= 11

.code

parsenums:
		ldx	#0
		stx	$cc
		stx	il_curidx
inputloop:	jsr	GETIN
		beq	inputloop
il_curidx	= *+1
		ldx	#$ff
		cmp	#$d
		beq	convertnums
		cpx	#MAXLINE
		bpl	convertnums
		sta	linebuf,x
		jsr	CHROUT
		inx
		stx	il_curidx
		bne	inputloop

convertnums:	dec	$cc
		lda	#$20
		jsr	CHROUT
		lda	#$d
		jsr	CHROUT
		lda	#$0
		sta	linebuf,x
		tax
cv_next1:	lda	linebuf,x
		beq	cv_error
		cmp	#$30
		bmi	cv_convfirst
		cmp	#$3a
		bpl	cv_convfirst
		sta	nc_string,x
		inx
		cpx	#$6
		beq	cv_error
		bne	cv_next1
cv_convfirst:	cmp	#$20
		bne	cv_error
		lda	#$0
		sta	nc_string,x
		inx
		stx	cv_idx2
		jsr	stringtonum
		lda	nc_num
		sta	inputnum1
		lda	nc_num+1
		sta	inputnum1+1
cv_idx2		= *+1
		ldx	#$ff
		ldy	#$0
cv_next2:	lda	linebuf,x
		beq	cv_convsecond
		cmp	#$30
		bmi	cv_error
		cmp	#$3a
		bpl	cv_error
		sta	nc_string,y
		iny
		inx
		bne	cv_next2
cv_convsecond:	lda	#$0
		sta	nc_string,y
		jsr	stringtonum
		lda	nc_num
		sta	inputnum2
		lda	nc_num+1
		sta	inputnum2+1
		clc
		rts
cv_error:	sec
		rts

.bss

linebuf:	.res	MAXLINE + 1
inputnum1:	.res	2
inputnum2:	.res	2

