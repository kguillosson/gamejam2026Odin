package button
import rl "vendor:raylib/V6"
import "core:strings"


button :: struct{
    orig_rect 	:rl.Rectangle, //where is rect found
    dest_rect 	:rl.Rectangle, //where the rect be drawn  
}

/*
DestroyButton :: proc(target :button){
	delete_cstring(button.label)
}*/
