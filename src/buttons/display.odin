package button

import rl "vendor:raylib/V6"

button_height :f32:50
button_width_margin:f32:20
//button_width_factor :f32:12
font_size:i32:20

DrawButton :: proc(input : button, active:bool, ATLAS :rl.Texture2D){
	color :rl.Color
	if active do color = rl.WHITE
	else do color = rl.GRAY
	rl.DrawTexturePro(ATLAS, input.orig_rect, input.dest_rect, {0,0}, 0, color)
}
/*
DrawButtonOld :: proc(input : button){
	
	txt_width :=f32(rl.MeasureText(input.label, font_size))
	button_rect :=rl.Rectangle{
		height = button_height,
		width = txt_width+2*button_width_margin
	}
	
	button_rect.x = input.pos.x-button_rect.width/2
	button_rect.y = input.pos.y-button_rect.height/2
	rl.DrawRectangleRec(button_rect, input.color1)
	rl.DrawText(input.label, i32(input.pos.x-txt_width/2), i32(input.pos.y-button_rect.height/4), font_size, input.color2)
}
*/
