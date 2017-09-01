.export buildclique
.export cliquesize

.import numnodes
.import printnode
.import nodesidx
.import edgeexists

.code

buildclique:
		ldx	#$0
		stx	newsize
		stx	nodepos
		stx	cliquepos
bc_loop:	lda	nodesidx,x
		tay
		ldx	cliquepos
		cpx	newsize
		bpl	bc_append
bc_check:	lda	newclique,x
		tax
		jsr	edgeexists
		bcc	bc_trynext
		inc	cliquepos
		ldx	cliquepos
		cpx	newsize
		bne	bc_check
bc_append:	ldx	nodepos
		lda	nodesidx,x
		ldx	newsize
		inc	newsize
		sta	newclique,x
bc_trynext:	inc	nodepos
		ldx	nodepos
		cpx	numnodes
		bne	bc_next
		ldx	cliquesize
		cpx	newsize
		bpl	bc_done
		ldx	#$0
bc_copy:	lda	newclique,x
		sta	clique,x
		inx
		cpx	newsize
		bne	bc_copy
		stx	cliquesize
bc_done:	rts
bc_next:	ldy	#$0
		sty	cliquepos
		beq	bc_loop

.bss

cliquesize:	.res	1
newsize:	.res	1
nodepos:	.res	1
cliquepos:	.res	1
clique:		.res	$100
newclique:	.res	$100

