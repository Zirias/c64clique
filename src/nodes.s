.export addnode
.export permutatenodes
.exportzp numnodes
.export nodesidx

.import inputnum1
.import inputnum2
.import numtostring
.import nc_num
.import nc_string

.segment "ZPLOW": zeropage

numnodes:	.res	1	; number of total nodes
nodetmpl:	.res	1	; temporary for node low-byte
permcnt:	.res	1	; temporary counter for permutations

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
		sta	nodesidx,y
		clc
		rts

permutatenodes:
		ldx	permcnt
		cpx	numnodes
		bmi	pn_start
		rts
pn_start:	lda	permtmp,x
		cmp	permcnt
		bmi	pn_swap
		lda	#$0
		sta	permtmp,x
		inc	permcnt
		bne	permutatenodes
pn_swap:	tay
		inc	permtmp,x
		txa
		and	#$1
		bne	pn_swapi
		ldy	#$0
pn_swapi:	lda	nodesidx,x
		eor	nodesidx,y
		sta	nodesidx,x
		eor	nodesidx,y
		sta	nodesidx,y
		eor	nodesidx,x
		sta	nodesidx,x
		lda	#$0
		sta	permcnt
		clc
		rts

.bss

nodesl:		.res	$100	; low-bytes of node ids
nodesh:		.res	$100	; high-bytes of node ids
nodesidx:	.res	$100	; indexes of nodes for permutations
permtmp:	.res	$100	; temporary array for doing permutations

