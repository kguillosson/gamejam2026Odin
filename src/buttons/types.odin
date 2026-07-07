package button
import rl "vendor:raylib"


button :: struct{
    pos 		:rl.Vector2 // this is the center of the button 
    bytebuffer 	:[16]byte   //last byte stores the length of the label, label is 15char max, please no utf8, everything will break
    color1 		:rl.Color 	//color of the button bcg
    color2		:rl.Color 	//color of text and outline
}
InitButton :: proc(pos:rl.Vector2, label : string, c1, c2 :rl.Color)->(new_button:button){
	assert (len(label) <16, "label too big, couldn't fit in button")
	new_button.pos = pos
	new_button.color1 = c1
	new_button.color2 = c2
	new_button.bytebuffer[15] = byte(len(label))
	for idx :=0; idx<len(button); idx+=1 do new_button.bytebuffer[idx] = string[i]
	return
}