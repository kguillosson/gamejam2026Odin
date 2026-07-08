package main

import rl "vendor:raylib/V6"



DrawThing_GP_TXTR::proc(texture :rl.Texture2D, pos:gridPos){
    V2pos := GetCenterGP(pos)
    destRect:=rl.Rectangle{V2pos.x, V2pos.y, 64, 64}
    origRect:=rl.Rectangle{0,0, 32, 32}
    rl.DrawTexturePro(texture, origRect, destRect, rl.Vector2{32,32}, 0, rl.WHITE)
}


DrawAP:: proc(vecpos : rl.Vector2, actions :u8){
    actionrect:=rl.Rectangle{
        vecpos.x+20,
        vecpos.y-13,
        3,
        13*f32(actions)
    }
    rl.DrawRectangleRec(actionrect, rl.BLUE)
}

DrawHP :: proc(vecpos : rl.Vector2, hp :u8){
    hprect :=rl.Rectangle{
        vecpos.x-23,
        vecpos.y-13,
        3,
        26*(f32(hp)/wizard_max_hp)
    }
    rl.DrawRectangleRec(hprect, rl.RED)
}





    
