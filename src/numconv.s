.export numtostring
.export stringtonum
.export nc_string
.export nc_num


.code

stringtonum:
		ldx	#$ff
stn_strlen:	inx
		lda	nc_string,x
		bne	stn_strlen
		ldy	#$6
stn_copybcd:	dey
		dex
		bmi	stn_fillzero
		lda	nc_string,x
		and	#$f
		sta	nc_string,y
		bpl	stn_copybcd
stn_fillzero:	lda	#$0
		sta	nc_string,y
		dey
		bpl	stn_fillzero
		lda	#$0
		sta	nc_num
		sta	nc_num+1
		ldx	#$10
stn_loop:	ldy	#$7b
		clc
stn_rorloop:	lda	nc_string-$7a,y
		bcc	stn_skipbit
		ora	#$10
stn_skipbit:	lsr	a
		sta	nc_string-$7a,y
		iny
		bpl	stn_rorloop
		ror	nc_num+1
		ror	nc_num
		dex
		bne	stn_sub
		rts
stn_sub:	ldy	#$4
stn_subloop:	lda	nc_string+1,y
		cmp	#$8
		bmi	stn_nosub
		sbc	#$3
		sta	nc_string+1,y
stn_nosub:	dey
		bpl	stn_subloop
		bmi	stn_loop

numtostring:
		rts

.bss

nc_string:	.res	6
nc_num:		.res	2
