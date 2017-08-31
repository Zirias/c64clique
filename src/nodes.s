.export addnode

.import inputnum1
.import inputnum2

.code

addnode:
		sta	nodetmpl
		ldy	numnodes
an_search:	cpy	#$0
		beq	an_append
		dey
		lda	nodesl,y
		cmp	nodetmpl
		bne	an_search
		txa
		cmp	nodesh,y
		bne	an_search
		tya
		clc
		rts
an_append:	ldy	numnodes
		inc	numnodes
		bne	an_appendok
		rts
an_appendok:	lda	nodetmpl
		sta	nodesl,y
		txa
		sta	nodesh,y
		tya
		clc
		rts



.bss
numnodes:	.res	1
nodetmpl:	.res	1

.segment "NODES"

nodesl:		.res	$100
nodesh:		.res	$100
