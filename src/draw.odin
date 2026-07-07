package main

import rl "vendor:raylib/V6"



DrawThing_GP_TXTR::proc(texture :rl.Texture2D, pos:gridPos){
    V2pos := GetCenterGP(pos)
    destRect:=rl.Rectangle{V2pos.x, V2pos.y, 64, 64}
    origRect:=rl.Rectangle{0,0, 32, 32}
    rl.DrawTexturePro(texture, origRect, destRect, rl.Vector2{32,32}, 0, rl.WHITE)
}


