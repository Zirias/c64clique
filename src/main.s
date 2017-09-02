.import parsenums
.import inputnum1
.import inputnum2
.import addnode
.import permutatenodes
.import addedge
.import buildclique
.import printclique

.import __ZPLOW_LOAD__
.import __ZPLOW_SIZE__
.import __ZPHIGH_LOAD__
.import __ZPHIGH_SIZE__

.segment "LDADDR"
                .word   $c000

.segment "ZPLOW": zeropage

bordercol:	.res	1

.segment "INIT"

		; clear zp segments
		lda	#$0
		ldx	#<__ZPLOW_SIZE__
zpc_low:	sta	__ZPLOW_LOAD__,x
		dex
		bpl	zpc_low
		ldx	#<__ZPHIGH_SIZE__
zpc_high:	sta	__ZPHIGH_LOAD__,x
		dex
		bpl	zpc_high

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

