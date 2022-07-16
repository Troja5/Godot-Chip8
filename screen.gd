extends Sprite

var WIDTH = 64
var HEIGHT = 32

onready var screen_data = Image.new()
onready var image_texture = ImageTexture.new()

func init_screen():
	screen_data.create(WIDTH, HEIGHT, false, Image.FORMAT_RGB8)
	screen_data.fill(Color.black)
	
func display_screen():
	image_texture.create_from_image(screen_data, 1)
	self.texture = image_texture
	
func clear_screen():
	screen_data.fill(Color.black)

func set_pixel(x, y, color):
	if color == 1:
		screen_data.set_pixel(x, y, Color.white)
	else:
		screen_data.set_pixel(x, y, Color.black)

func get_pixel(x, y):
	if (screen_data.get_pixel(x, y) == Color.white):
		return 1
	else:
		return 0
	
func unpack_byte(byte):
	var pixels = []
	
	for col in range(8):
		var mask = 0x80 >> col
		var pixel = byte & mask != 0
		pixels.append(int(pixel))
			
	return pixels
	
func unpack_sprite(sprite):
	var pixels = []
	
	for byte in sprite:
		pixels.append_array(unpack_byte(byte))
		
	return pixels

func draw(sprite: PoolByteArray, x: int, y: int):
	var col = 0
	screen_data.lock()
	
	for sprite_y in sprite.size():
		var pixels = unpack_byte(sprite[sprite_y])
		
		for sprite_x in pixels.size():
			var screen_x = (x + sprite_x) % WIDTH
			var screen_y = (y + sprite_y) % HEIGHT
			
			var curr = get_pixel(screen_x, screen_y)
			col |= curr & pixels[sprite_x]
			set_pixel(screen_x, screen_y, curr ^ pixels[sprite_x])
		
	screen_data.unlock()
