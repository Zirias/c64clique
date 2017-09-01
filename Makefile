C64SYS?=c64
C64AS?=ca65
C64LD?=ld65

C64ASFLAGS?=-t $(C64SYS) -g
C64LDFLAGS?=-Ln clique.lbl -m clique.map -Csrc/clique.cfg

clique_OBJS:=$(addprefix obj/,main.o input.o numconv.o nodes.o edges.o clique.o)
clique_BIN:=clique.prg

all: $(clique_BIN)

$(clique_BIN): $(clique_OBJS)
	$(C64LD) -o$@ $(C64LDFLAGS) $^

obj:
	mkdir obj

obj/%.o: src/%.s src/clique.cfg Makefile | obj
	$(C64AS) $(C64ASFLAGS) -o$@ $<

clean:
	rm -fr obj *.lbl *.map

distclean: clean
	rm -f $(clique_BIN)

.PHONY: all clean distclean

