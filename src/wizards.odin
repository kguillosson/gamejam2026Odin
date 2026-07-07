package main

import rl "vendor:raylib/V6"
import "core:math/rand"
import "core:fmt"

dir :: enum u8{left, right}


wizard :: struct{
    pos     :rl.Vector2,
    color   :rl.Color,
    dir     :dir
}

initWiz :: proc (pos:rl.Vector2)->wizard{
    wizpos :i32= 720*i32(pos.y)+i32(pos.x)
    wizcolor:rl.Color
    wizcolor.r=u8(rand.uint32())
    wizcolor.g=u8(rand.uint32())
    wizcolor.b=u8(rand.uint32())
    wizcolor.a=255
    return wizard{
        pos, wizcolor, .right
    }
}

drawWiz :: proc(target : wizard, texture :rl.Texture2D){
    destRect:=rl.Rectangle{target.pos.x, target.pos.y, 64, 64}
    origRect:=rl.Rectangle{0,0, 32, 32}
    angle:f32
    if target.dir==.left do origRect .width=-32 
    rl.DrawTexturePro(texture, origRect, destRect, rl.Vector2{32,32}, 0, target.color)
    //rl.DrawRectangleRec(destRect, rl.RED)
    //fmt.println(destRect)
}
