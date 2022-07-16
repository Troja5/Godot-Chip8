extends Node2D

var FONT_SPRITES = [
	0xF0, 0x90, 0x90, 0x90, 0xF0,  # 0
	0x20, 0x60, 0x20, 0x20, 0x70,  # 1
	0xF0, 0x10, 0xF0, 0x80, 0xF0,  # 2
	0xF0, 0x10, 0xF0, 0x10, 0xF0,  # 3
	0x90, 0x90, 0xF0, 0x10, 0x10,  # 4
	0xF0, 0x80, 0xF0, 0x10, 0xF0,  # 5
	0xF0, 0x80, 0xF0, 0x90, 0xF0,  # 6
	0xF0, 0x10, 0x20, 0x40, 0x40,  # 7
	0xF0, 0x90, 0xF0, 0x90, 0xF0,  # 8
	0xF0, 0x90, 0xF0, 0x10, 0xF0,  # 9
	0xF0, 0x90, 0xF0, 0x90, 0x90,  # A
	0xE0, 0x90, 0xE0, 0x90, 0xE0,  # B
	0xF0, 0x80, 0x80, 0x80, 0xF0,  # C
	0xE0, 0x90, 0x90, 0x90, 0xE0,  # D
	0xF0, 0x80, 0xF0, 0x80, 0xF0,  # E
	0xF0, 0x80, 0xF0, 0x80, 0x80,  # F
]
var FONT_ADDRESS = 0x50
var FONT_LENGTH = 0x5

var memory: PoolByteArray;
var keyboard = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
var size: int  = 0x1000

func _ready() -> void:
	memory.resize(size)
	for i in memory.size():
		memory[i] = 0
	load_data(FONT_ADDRESS, FONT_SPRITES)
	
func load_data(addr: int, data: Array) -> void:
	assert(addr >= 0 && addr < memory.size(), "Attempting to write data at invalid address %d!" % addr)
	assert(data != null, "Attempting to load invalid data!")
	for i in data.size():
		self.write_byte(addr + i, data[i])
	print(memory.subarray(0x200, 0x250))
	
func read_byte(addr: int) -> int:
	assert(addr >= 0 && addr < memory.size(), "Attempting to read byte at invalid address %d!" % addr)
	return memory[addr]
	
func read_word(addr: int) -> int:
	var high = read_byte(addr) << 8
	var low = read_byte(addr + 1)
	return high + low 
	
func read_span(addr: int, length: int) -> PoolByteArray:
	assert(addr >= 0 && addr + length < memory.size(), "Attempting to read span of length %d at invalid address %d!" % [length, addr])
	return memory.subarray(addr, addr + length)

func write_byte(addr: int, val: int) -> void:
	assert(addr >= 0 && addr < memory.size(), "Attempting to write byte at invalid address %d!" % addr)
	assert(val <= 0xFF, "Attempting to write a value larger than a byte (%d) at address %d!" % [val, addr])
	memory[addr] = val

func read_key(idx: int) -> int:
	assert(idx >= 0 && idx < 16, "Attempting to read invalid key! %x" % idx)
	return keyboard[idx]
	
func write_key(idx: int, val: bool) -> void:
	assert(idx >= 0 && idx < 16, "Attempting to read invalid key! %x" % idx)
	keyboard[idx] = int(val)
