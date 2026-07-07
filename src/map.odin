package main

import rl "vendor:raylib/V6"
import "core:fmt"

W:f32:48                //width of a hex tile
S:f32:27.712812921102   //side of a hex tile

gridPos :: struct{x:i32, y:i32}

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
IsInHex :: proc(vecpos :rl.Vector2, gridpos :gridPos)->bool{
    center:=GetCenterGP(gridpos)
    c1:=center+corner_disp[.tl]
    for corner in corners{
        c2 :=center+corner_disp[corner]
        fmt.println(center, c1, c2)
        if rl.CheckCollisionPointTriangle(vecpos, center, c1, c2) do return true
        c1=c2
    }
    return false
}

GetClosestHex::proc(input :rl.Vector2)->(output:gridPos){
    //this will return the hex of center closest to input
    row_guess := i32(input.y/(1.5*S))
    col_guess :i32
    if row_guess%2==0 do output=gridPos{i32(input.x/W), row_guess}
    else do output=gridPos{i32(input.x/W-0.5), row_guess}
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


GetCenteri32s::proc(r, c:i32)->(output:rl.Vector2){
    output = GetCenterGP(gridPos{r, c})
    return
}

DrawGrid::proc(){
    //this will tile a given rectangle with hexagons.
    //at base, the rectangle will be {0,0,720,720}, the param is to be used in case of a camera
    nb_hex:i32:15
    for row:i32=0; row<16; row+=1 {
        for col:i32=0; col<16; col+=1{
            DrawHex(GetCenteri32s(col, row))
        }
    }


}

DrawHex::proc(center:rl.Vector2, scale:f32=1){
    rl.DrawPolyLines(center, 6, S*scale, 90, rl.BLACK)
}
HiglightHex::proc(center:rl.Vector2, color:rl.Color, scale:f32=1){
    rl.DrawPoly(center, 6, S*scale, 90, color)
}
