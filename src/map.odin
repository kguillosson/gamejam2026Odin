package main

import rl "vendor:raylib/V6"
import "core:fmt"
import "core:math/rand"
import "core:math"
W:f32:48                //width of a hex tile
S:f32:26                //side of a hex tile

gridPos :: [2]i32



corners ::enum{
    t   =0,
    tr  =1,
    br  =2,
    b   =3,
    bl  =4,
    tl  =5,
}
@(rodata) corner_disp :=[corners]rl.Vector2{
    .t={0, -S},
    .tr={W/2, -S/2},
    .br={W/2, S/2},
    .b={0, S},
    .bl={-W/2, S/2},
    .tl={-W/2, -S/2}
}

neigbors :: enum{
    rt  =0,
    r   =1,
    rb  =2,
    lb  =3,
    l   =4,
    lt  =5,
}


@(rodata) neigbor_disp_even :=[neigbors]gridPos{
    .rt  ={0,-1},
    .r   ={1,0},
    .rb  ={0,+1},
    .lb  ={-1,+1},
    .l   ={-1,0},
    .lt  ={-1,-1}
}
@(rodata) neigbor_disp_odd :=[neigbors]gridPos{
    .rt  ={+1,-1},
    .r   ={1,0},
    .rb  ={+1,+1},
    .lb  ={0,+1},
    .l   ={-1,0},
    .lt  ={0,-1}
}
GetNeigbor :: proc(pos :gridPos, dir :neigbors)->gridPos{
    if pos.y%2==0 do return pos+neigbor_disp_even[dir]
    else do return pos+neigbor_disp_odd[dir]
}

tileTypes :: enum u8{
    desert=0,
    eau=1,
    foret=2,
    montagne=3,
    plage=4,
    prairie=5,
    swamp=6
}


DrawTile :: proc (tileatlas :rl.Texture2D, tiletype : tileTypes, col, row:i32){
    destpos := GetCenteri32s(col, row)
    origRect:=rl.Rectangle{f32(tiletype)*48,0, 48, 52}
    destRect:=rl.Rectangle{destpos.x, destpos.y, 48, 52}
    rl.DrawTexturePro(tileatlas, origRect, destRect, rl.Vector2{24, 26}, 0, rl.WHITE)

}




IsInHex :: proc(vecpos :rl.Vector2, gridpos :gridPos)->bool{
    center:=GetCenterGP(gridpos)
    c1:=center+corner_disp[.tl]*1.05
    for corner in corners{
        c2 :=center+corner_disp[corner]*1.05
        //fmt.println(center, c1, c2)
        if rl.CheckCollisionPointTriangle(vecpos, center, c1, c2) do return true
        c1=c2
    }
    return false
}

GetClosestHex::proc(input :rl.Vector2)->(output:gridPos){
    //this will return the hex of center closest to input
    row_guess := i32(input.y/(1.5*S))
    if row_guess>15{
        output = {-2, -2}
        return
    }
    if row_guess%2==0 do output=gridPos{i32(input.x/W), row_guess}
    else do output=gridPos{i32(input.x/W-0.5), row_guess}
    if !IsInHex(input, output){
        V2_from_center := input-GetCenterGP(output)
        
        if V2_from_center.x>0 do output=GetNeigbor(output, .rt)
        else do output = GetNeigbor(output, .lt)

    }
    return
}
QuantizeV2::proc(input:rl.Vector2)->(output:rl.Vector2){
    output = GetCenterGP(GetClosestHex(input))
    return
}

GetCenterGP::proc(input:gridPos)->(output:rl.Vector2){
    output.y = (1+1.5*f32(input.y)) * S
    output.x = (0.5+0.5*f32(input.y%2)+f32(input.x)) * W
    return
}


GetCenteri32s::proc(c, r:i32)->(output:rl.Vector2){
    output = GetCenterGP(gridPos{c, r})
    return
}

DrawGrid::proc(tileatlas :rl.Texture2D, array_tiles : [nb_tiles]tileTypes){
    //this will tile a given rectangle with hexagons.
    //at base, the rectangle will be {0,0,720,720}, the param is to be used in case of a camera
    idx:i32=0
    for row:i32=0; row<16; row+=1 {
        for col:i32=0; col<15; col+=1{
            DrawTile(tileatlas, array_tiles[idx], col, row)
            //fmt.println(row, col, idx)
            idx+=1

            //DrawHex(GetCenteri32s(col, row))
        }
    }


}

DrawHex::proc(center:rl.Vector2, scale:f32=1){
    rl.DrawPolyLines(center, 6, S*scale, 90, rl.BLACK)
}
HiglightHex::proc(center:rl.Vector2, color:rl.Color, scale:f32=1){
    color:=color
    color.a = 100
    rl.DrawPoly(center, 6, S*scale, 90, color)
}




IsTileFree::proc(entity_array :[dynamic;max_nb_entity]entity, pos : gridPos) ->bool{
    for thing in entity_array do if pos ==GetPos(thing) do return false
    return true
}

IsTileOccupied::proc(entity_array :[dynamic;max_nb_entity]entity, pos : gridPos) ->(bool, u8){
    for thing, index in entity_array do if pos ==GetPos(thing) do return true, u8(index)
    return false, 0
}

IsHighlighted::proc(highligted_tiles :[dynamic; max_nb_highlight]gridPos, pos:gridPos)->bool{
    for tile in highligted_tiles do if pos == tile do return true
    return false
}

HighlightAccessible :: proc(highligted_tiles:^[dynamic; max_nb_highlight]gridPos,
                            entity_array    :[dynamic; max_nb_entity]entity,
                            target_tile     :gridPos){
    for dir in neigbors{
        pos2try:=GetNeigbor(target_tile, dir)
        if IsTileFree(entity_array, pos2try){
            if len(highligted_tiles)<max_nb_highlight do append(highligted_tiles, pos2try)
            else do fmt.println("too many highlighted tiles")
        }
    }
}

SetupMap :: proc(tile_array: ^[nb_tiles]tileTypes){
    idx:=0
    
    for row:=0; row<nb_row; row+=1{
        for col:=0; col<nb_col; col+=1{
            if col==14{
                tile_array[idx] = .eau
            }else if col==13{
                if rand.uint32()%2==0 do tile_array[idx] = .eau
                else do tile_array[idx] = .plage
            }else if col==12{
                tile_array[idx]=.plage
            }else if col<2{
                tile_array[idx]=float2class({0,0.1,0,0.45,0.45})
            }else if col<4{
                tile_array[idx]=float2class({0.1,0.2,0.1,0.3,0.3})
            }else if col<7{
                tile_array[idx]=float2class({0.2,0.2,0.2,0.2,0.2})
            }else if col<9{
                tile_array[idx]=float2class({0.3,0.3,0.2,0.1,0.1})
            }else if col<12{
                tile_array[idx]=float2class({0.4,0.2,0.4,0,0})
            }

            idx+=1
        }
    }
}

float2class :: proc(probas :[5]f32)->(output:tileTypes){
    sum:f32=0
    for proba in probas do sum+= proba
    if math.abs(sum-1)>1e-5 {
        fmt.println("probas didn't sum to 1")
        return .eau
    }
    classes :=[5]tileTypes{.foret, .montagne, .prairie, .desert, .swamp}
    val:=rand.float32()
    idx:=0
    for ; idx<5 && val>probas[idx]; idx+=1 do val-=probas[idx]
    return classes[idx]



}
