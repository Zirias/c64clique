.import parsenums
.import inputnum1
.import inputnum2
.import addnode
.import permutatenodes
.import addedge
.import buildclique
.importzp cliquesize
.import numtostring
.import nc_num
.import nc_string

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
		jsr	buildclique
testnextperm:	jsr	permutatenodes
		bcs	outputresult
		jsr	buildclique
		bvc	testnextperm

outputresult:
		lda	cliquesize
		sta	nc_num
		jsr	numtostring
		lda	#<nc_string
		ldy	#>nc_string
		jsr	$ab1e
error:
		rts

