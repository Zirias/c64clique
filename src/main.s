.import parsenums
.import inputnum1
.import inputnum2
.import addnode
.import addedge

.import __BSS_LOAD__
.import __BSS_SIZE__

.segment "LDADDR"
                .word   $c000

.segment "INIT"

		lda	#$0
		tax
bssclear:	sta	__BSS_LOAD__,x
		inx
		cpx	#<__BSS_SIZE__
		bne	bssclear

inputloop:	jsr	parsenums
		bcs	main
		lda	inputnum1
		ldx	inputnum1+1
		jsr	addnode
		bcs	error
		sta	edgefirstnode
		lda	inputnum2
		ldx	inputnum2+1
		jsr	addnode
		bcs	error
edgefirstnode	= *+1
		ldx	#$ff
		jsr	addedge
		bcc	inputloop

error:
main:
		rts

