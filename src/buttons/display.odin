package button

import rl "vendor:raylib"

button_height :f32:56
button_width_factor :f32:24
font_size:i32:20

DrawButton :: proc(input : button){
	str := string(button.bytebuffer[:button.bytebuffer[15]])
	text_width := rl.MeasureText(str, font_size)
}
