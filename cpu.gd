extends Node2D

onready var screen = get_node("../screen")
onready var memory = get_node("../memory")
onready var system = get_parent()

var pc = 0
var v = [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ]
var s = []
var dt = 0
var st = 0
var i = 0

func _ready():
	pc = 0x200
	pass
	
func tick(inst: int) -> int:
	var nibble = (inst & 0xF000) >> 12
	match nibble:
		0x0:
			if inst & 0x000F == 0:
				screen.clear_screen()
				pc += 2
			elif inst & 0x000F == 0xE:
				pc = s.pop_back()
			else:
				assert(false, "Invalid instruction: %x!" % inst)
		0x1:
			var addr = (inst & 0x0FFF)
			pc = addr
		0x2:
			s.push_back(pc)
			var addr = (inst & 0xFFF)
			pc = addr
		0x3:
			var reg = (inst & 0x0F00) >> 8
			var val = (inst & 0x00FF)
			if v[reg] == val:
				pc += 4
			else:
				pc += 2
		0x4:
			var reg = (inst & 0x0F00) >> 8
			var val = (inst & 0x00FF)
			if v[reg] != val:
				pc += 4
			else:
				pc += 2
		0x5:
			if (inst & 0x000F) != 0:
				assert(false, "Invalid instruction: %x!" % inst)
			else:
				var reg1 = (inst & 0x0F00) >> 8
				var reg2 = (inst & 0x00F0) >> 4
				if reg1 == reg2:
					pc += 4
				else:
					pc += 2
		0x6:
			var reg = (inst & 0x0F00) >> 8
			v[reg] = (inst & 0x00FF)
			pc += 2	
		0x7:
			var reg = (inst & 0x0F00) >> 8
			v[reg] += (inst & 0x00FF)
			pc += 2	
		0x8:
			var trailing = inst & 0x000F
			match trailing:
				0x0:
					var reg1 = (inst & 0x0F00) >> 8
					var reg2 = (inst & 0x00F0) >> 4
					v[reg1] = v[reg2]
					pc += 2
				0x1:
					var reg1 = (inst & 0x0F00) >> 8
					var reg2 = (inst & 0x00F0) >> 4
					v[reg1] |= v[reg2]
					pc += 2
				0x2:
					var reg1 = (inst & 0x0F00) >> 8
					var reg2 = (inst & 0x00F0) >> 4
					v[reg1] &= v[reg2]
					pc += 2
				0x3:
					var reg1 = (inst & 0x0F00) >> 8
					var reg2 = (inst & 0x00F0) >> 4
					v[reg1] ^= v[reg2]
					pc += 2
				0x4:
					var reg1 = (inst & 0x0F00) >> 8
					var reg2 = (inst & 0x00F0) >> 4

					var val = v[reg1] + v[reg2]

					if val > 0xFF:
						v[0xF] = 1
						v[reg1] = (val & 0xFF)
					else:
						v[0xF] = 0
						v[reg1] = val
					
					pc += 2
				0x5:
					var reg1 = (inst & 0x0F00) >> 8
					var reg2 = (inst & 0x00F0) >> 4

					if v[reg1] > v[reg2]:
						v[0xF] = 1
					else:
						v[0xF] = 0

					v[reg1] = (v[reg1] - v[reg2]) >> 54

					pc += 2
				0x6:
					var reg1 = (inst & 0x0F00) >> 8

					if (v[reg1] & (1 << 8)) == 1:
						v[0xF] = 1
					else:
						v[0xF] = 0
					
					v[reg1] /= 2
					pc += 2
				0x7:
					var reg1 = (inst & 0x0F00) >> 8
					var reg2 = (inst & 0x00F0) >> 4

					if v[reg2] > v[reg1]:
						v[0xF] = 1
					else:
						v[0xF] = 0

					v[reg1] = (v[reg2] - v[reg1]) >> 54

					pc += 2
				0xE:
					var reg1 = (inst & 0x0F00) >> 8

					if (v[reg1] & (1 << 8)) == 1:
						v[0xF] = 1
					else:
						v[0xF] = 0
					
					v[reg1] *= 2
					pc += 2
				_:
					assert(false, "Invalid instruction: %x!" % inst)
		0xA:
			i = (inst & 0x0FFF)
			pc += 2
		0xB:
			var addr = (inst & 0x0FFF)
			pc = addr + v[0]
		0xC:
			var reg = (inst & 0x0F00) >> 8
			var val = (inst & 0x00FF)

			var rand = rand_range(0x0, 0xFF)
			
			v[reg] = rand & val

			pc += 2
		0xD:
			var x = v[(inst & 0x0F00) >> 8]
			var y = v[(inst & 0x00F0) >> 4]
			var n = (inst & 0x000F)
			
			var sprite = memory.read_span(i, n)
			
			screen.draw(sprite, x, y)
			pc += 2	
		0xE:
			var trailing = (inst & 0x00FF)
			match trailing:
				0x9E:
					var reg = (inst & 0x0F00) >> 8
					if memory.read_key(v[reg] == 1):
						pc += 4
				0xA1:
					var reg = (inst & 0x0F00) >> 8
					if memory.read_key(v[reg] == 0):
						pc += 4
		0xF:
			var trailing = (inst & 0x00FF)
			match trailing:
				0x07:
					var reg = (inst & 0x0F00) >> 8
					
					v[reg] = dt

					pc += 2
				0x0A:
					for i in range(16):
						if memory.read_key(i) == 1:
							pc += 2
							break
				0x15:
					var reg = (inst & 0x0F00) >> 8
					
					dt = v[reg]

					pc += 2
				0x18:
					var reg = (inst & 0x0F00) >> 8

					st = v[reg]

					pc += 2
				0x1E:
					var reg = (inst & 0x0F00) >> 8

					i += v[reg]

					pc += 2
				0x29:
					assert(false, "UNIMPLEMENTED!")
				0x33:
					assert(false, "UNIMPLEMENTED!")
				0x55:
					for n in range(16):
						memory.write_byte(i + n, v[n])

					pc += 2
				0x65:
					for n in range(16):
						v[n] = memory.read_byte(i + n)

					pc += 2
				_:
					assert(false, "Invalid instruction: %x!" % inst)
		_:
			assert(false, "Invalid instruction: %x!" % inst)
						
	return 0
