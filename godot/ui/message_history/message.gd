class_name Message
extends Label

# how many ms need to pass to start to fade the message
const start_fade_ms:int = 750
# how long does it take to fade the message from full to 0 in ms
const fade_time_ms:int = 1000
# how long should this message stay alive in mus
const life_time_ms:int = start_fade_ms + fade_time_ms + 500

var born:int = 0

func _init(msg:String):
	text = msg
	born = Time.get_ticks_msec()
	print(born, ":", msg)

func _process(_delta):

	var time = Time.get_ticks_msec()
	if time - born >= start_fade_ms:
		if (time - born) <= (start_fade_ms + fade_time_ms):
			modulate.a = lerp(1.0, 0.0, float(time-born-start_fade_ms) / float(fade_time_ms))
		else:
			modulate.a = 0.0
	if time - born >= life_time_ms:
		queue_free()
