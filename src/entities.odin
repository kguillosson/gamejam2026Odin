package main

import rl "vendor:raylib/V6"

//dir :: enum u8{left, right}

entity ::union{
    wizard,
    building,
    enemy,
}

buildingType :: enum u8{
    castle,
    farm,
    tower,
    village,
    temple
}

building ::struct{
    pos     :gridPos,
    hp      :u8,
    type    :buildingType
    
}
wizard_max_hp:f32:100
wizType :: enum{
    blue,
    red,
    black,
    demon,
    green
}

wizard :: struct{
    pos     :gridPos,
    actions :u8, //nb of moves left
    hp      :u8,
    type    :wizType
}

enemyType :: enum{
    urssaf,
    cochon,
    diable,
    squelette,
    soupeur
}

enemy :: struct{
    pos     :gridPos,
    hp      :u8,
    type    :enemyType
}


initWiz :: proc (pos:gridPos, type : wizType)->wizard{

    return wizard{
        pos, 2, 100, type
    }
}


DrawEntity :: proc(target : entity, ATLAS : rl.Texture2D){
    //draw the entity based on type 
    vecpos :=GetCenterGP(GetPos(target))
    destRect:=rl.Rectangle{
        vecpos.x, vecpos.y, 48, 52
    }
    origRect:=rl.Rectangle{
         width = 48, height = 52 
    }
    switch elem in target{
        case building:
            origRect.y=0
            origRect.x = f32(elem.type)*48
        case wizard:
            origRect.y=52
            origRect.x = f32(elem.type)*48
        case enemy:
            origRect.y=104 
            origRect.x = f32(elem.type)*48
    }
    rl.DrawTexturePro(ATLAS, origRect, destRect, rl.Vector2{24, 26}, 0, rl.WHITE)
    wiz, ok := target.(wizard)
    if ok do DrawAP(vecpos, wiz.actions)
    DrawHP(vecpos, GetHP(target))
}

/*

DrawEntity :: proc(target : entity, texture:rl.Texture2D){
    #partial switch thing in target{
        case wizard:
            drawWiz(thing, texture)
    }
}

drawWiz :: proc(target : wizard, texture :rl.Texture2D){
    vecpos := GetCenterGP(target.pos)
    destRect:=rl.Rectangle{vecpos.x, vecpos.y, 64, 64}
    origRect:=rl.Rectangle{0,0, 32, 32}
    rl.DrawTexturePro(texture, origRect, destRect, rl.Vector2{32,32}, 0, target.color)
    actionrect:=rl.Rectangle{
        vecpos.x+22,
        vecpos.y-13,
        3,
        13*f32(target.actions)
    }
    rl.DrawRectangleRec(actionrect, rl.BLUE)
    hprect :=rl.Rectangle{
        vecpos.x-13,
        vecpos.y-13,
        3,
        26*(f32(target.hp)/wizard_max_hp)
    }
    rl.DrawRectangleRec(hprect, rl.BLUE)
}*/


CanAct :: proc(input : entity)->bool{
    switch thing in input {
    case wizard:
        return thing.actions>0
    case building:
        return false
    case enemy:
        return false
    }
    return false
}
GetPos :: proc(input : entity)->gridPos{
    switch thing in input {
    case wizard:
        return thing.pos
    case building:
        return thing.pos
    case enemy:
        return thing.pos
    }
    return gridPos{-100, -100}
}

GetHP :: proc(input : entity)->u8{
    switch thing in input {
    case wizard:
        return thing.hp
    case building:
        return thing.hp
    case enemy:
        return thing.hp
    }
    return 255
}
GetAP :: proc(input : entity)->u8{
    wiz, ok := input.(wizard)
    if ok do return wiz.actions
    return 255
}
