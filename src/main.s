.import parsenums
.import inputnum1
.import inputnum2
.import addnode
.import permutatenodes
.import addedge
.import buildclique
.import printclique

.import __BSS_LOAD__
.import __BSS_SIZE__

.segment "LDADDR"
                .word   $c000

.segment "INIT"

		; clear bss
		lda	#$0
		tax
		ldy	#>__BSS_LOAD__
		sty	bc_page
		ldy	#>__BSS_SIZE__
bc_page		= *+2
bc_loop:	sta	__BSS_LOAD__,x
		inx
		beq	bc_nextpage
		cpy	#$0
		bne	bc_loop
		cpx	#<__BSS_SIZE__
		bne	bc_loop
		jmp	main
bc_nextpage:	dey
		inc	bc_page
		bne	bc_loop

.code

main:

inputloop:	jsr	parsenums
		bcs	findclique
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

findclique:
		sei
		lda	#$5
		sta	$1
		lda	$d020
		sta	bordercol
		jsr	buildclique
testnextperm:	inc	$d020
		jsr	permutatenodes
		bcs	outputresult
		jsr	buildclique
		bvc	testnextperm

outputresult:
		lda	#$7
		sta	$1
		cli
		lda	bordercol
		sta	$d020
		jsr	printclique
error:
		rts

.bss

bordercol:	.res	1
