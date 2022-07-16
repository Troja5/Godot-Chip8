extends Node2D

var program = [
	0x00, 0xe0, 0xa2, 0x2a, 0x60, 0x0c, 0x61, 0x08, 0xd0, 0x1e, 0x70, 0x09, 0xa2, 0x39, 0xd0, 0x1e,
	0xa2, 0x48, 0x70, 0x08, 0xd0, 0x1e, 0x70, 0x04, 0xa2, 0x57, 0xd0, 0x1e, 0x70, 0x08, 0xa2, 0x66,
	0xd0, 0x1e, 0x70, 0x08, 0xa2, 0x75, 0xd0, 0x1e, 0x12, 0x28, 0xff, 0x00, 0xff, 0x00, 0x3c, 0x00,
	0x3c, 0x00, 0x3c, 0x00, 0x3c, 0x00, 0xff, 0x00, 0xff, 0xff, 0x00, 0xff, 0x00, 0x38, 0x00, 0x3f,
	0x00, 0x3f, 0x00, 0x38, 0x00, 0xff, 0x00, 0xff, 0x80, 0x00, 0xe0, 0x00, 0xe0, 0x00, 0x80, 0x00,
	0x80, 0x00, 0xe0, 0x00, 0xe0, 0x00, 0x80, 0xf8, 0x00, 0xfc, 0x00, 0x3e, 0x00, 0x3f, 0x00, 0x3b,
	0x00, 0x39, 0x00, 0xf8, 0x00, 0xf8, 0x03, 0x00, 0x07, 0x00, 0x0f, 0x00, 0xbf, 0x00, 0xfb, 0x00,
	0xf3, 0x00, 0xe3, 0x00, 0x43, 0xe0, 0x00, 0xe0, 0x00, 0x80, 0x00, 0x80, 0x00, 0x80, 0x00, 0x80,
	0x00, 0xe0, 0x00, 0xe0,
]

onready var screen = get_node("screen")	
onready var memory = get_node("memory")		
onready var cpu = get_node("cpu")

func _ready():	
	memory.load_data(0x200, program)
	screen.init_screen()
	
func _process(delta):
	read_input()
	cycle()
	screen.display_screen()
	

func cycle():
	var inst = memory.read_word(cpu.pc)
	cpu.tick(inst)

func read_input():
	memory.write_key(0x0, Input.is_action_pressed("0"))
	memory.write_key(0x1, Input.is_action_pressed("1"))
	memory.write_key(0x2, Input.is_action_pressed("2"))
	memory.write_key(0x3, Input.is_action_pressed("3"))
	memory.write_key(0x4, Input.is_action_pressed("4"))
	memory.write_key(0x5, Input.is_action_pressed("5"))
	memory.write_key(0x6, Input.is_action_pressed("6"))
	memory.write_key(0x7, Input.is_action_pressed("7"))
	memory.write_key(0x8, Input.is_action_pressed("8"))
	memory.write_key(0x9, Input.is_action_pressed("9"))
	memory.write_key(0xA, Input.is_action_pressed("A"))
	memory.write_key(0xB, Input.is_action_pressed("B"))
	memory.write_key(0xC, Input.is_action_pressed("C"))
	memory.write_key(0xD, Input.is_action_pressed("D"))
	memory.write_key(0xE, Input.is_action_pressed("E"))
	memory.write_key(0xF, Input.is_action_pressed("F"))
	