
all: $(foreach page,D0 D8 E0 E8 F0 F8,rom-$(page).mem)

rom-%.mem: rom-%.bin
	./mem_convert "$<" "$@.tmp"
	mv "$@.tmp" "$@"
