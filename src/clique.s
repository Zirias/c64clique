.export buildclique
.export printclique

.importzp numnodes
.import printnode
.import nodesidx
.import edgeexists
.import numtostring
.import nc_num
.import nc_string

.segment "ZPHIGH": zeropage

cliquesize:	.res	1
newsize:	.res	1
nodepos:	.res	1
cliquepos:	.res	1

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

printclique:
		lda	#$0
		sta	cliquepos
		sta	nc_num+1
		lda	cliquesize
		sta	nc_num
		jsr	numtostring
		lda	#<nc_string
		ldy	#>nc_string
		jsr	$ab1e
		lda	#' '
		jsr	$f1ca
		lda	#'['
		jsr	$f1ca
pc_loop:	ldx	cliquepos
		lda	clique,x
		tax
		jsr	printnode
		inc	cliquepos
		ldx	cliquepos
		cpx	cliquesize
		beq	pc_done
		lda	#','
		jsr	$f1ca
		bcc	pc_loop
pc_done:	lda	#']'
		jsr	$f1ca
		lda	#$d
		jmp	$f1ca

.bss

clique:		.res	$100
newclique:	.res	$100

