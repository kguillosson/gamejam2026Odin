package main

import rl "vendor:raylib/V6"
import "core:fmt"
import "core:os"
import "core:math/rand"

//consts
nb_tiles :: 240




main :: proc(){


	/*---------- INIT----------*/

	//Variables
	array_tiles:[nb_tiles]tileTypes
	for idx:=0; idx<nb_tiles; idx+=1 do array_tiles[idx] = tileTypes(rand.uint32()%7)
	tiles2Highlight :[20]gridPos
	nb_tiles2highlight:u32=0


	//launch RL
	rl.InitWindow(720, 720, "plz work")
	rl.SetTargetFPS(60)
	//load textures
	wiztexture := rl.LoadTexture("./art/test.png")
	house_texture := rl.LoadTexture("./art/house.png")
	TILE_ATLAS := rl.LoadTexture("./art/tile_atlas.png")


	test_wiz : wizard
	framecounter :u32


	/*----------GAMELOOP----------*/
	for !rl.WindowShouldClose(){
		framecounter+=1
		GP2highlight := QuantizeV2(rl.GetMousePosition())
		hovered_hex :=GetClosestHex(rl.GetMousePosition())
		if rl.IsMouseButtonPressed(.LEFT){
			//test_wiz=initWiz(rl.GetMousePosition())
			//fmt.println("spawned a wizard: ", test_wiz	)
			//fmt.println(GP2highlight)
			for dir in neigbors{
				assert(nb_tiles2highlight<20, "bro highlighted too much shit")
				tiles2Highlight[nb_tiles2highlight] = GetNeigbor(hovered_hex, dir)
				nb_tiles2highlight+=1
			}
			if IsInHex(rl.GetMousePosition(), GetClosestHex(rl.GetMousePosition())) do fmt.println("quantization succesfull")
			else do fmt.println("quantization fail")
		}
		if !rl.IsMouseButtonDown(.LEFT) do nb_tiles2highlight=0
		//GP2highlight := QuantizeV2(rl.GetMousePosition())

		rl.BeginDrawing()
			rl.ClearBackground(rl.RAYWHITE)
			DrawGrid(TILE_ATLAS, array_tiles)
			HiglightHex(GP2highlight, rl.YELLOW)
			for idx:u32=0; idx <nb_tiles2highlight; idx+=1 do HiglightHex(GetCenterGP(tiles2Highlight[idx]), rl.RED)

			DrawThing_GP_TXTR(house_texture, gridPos{7,8})
			rl.DrawFPS(10, 10)
			drawWiz(test_wiz, wiztexture)
		rl.EndDrawing()
	}

	/*----------DEINIT----------*/
	rl.UnloadTexture(wiztexture)
	rl.UnloadTexture(house_texture)
	rl.UnloadTexture(TILE_ATLAS)
}
