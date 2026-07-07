package main

import rl "vendor:raylib/V6"
import "core:fmt"
import "core:os"

main :: proc(){


	/*---------- INIT----------*/

	rl.InitWindow(720, 720, "plz work")
	rl.SetTargetFPS(60)
	wiztexture := rl.LoadTexture("./art/test.png")
	house_texture := rl.LoadTexture("./art/house.png")
	test_wiz : wizard
	framecounter :u32

	/*----------GAMELOOP----------*/
	for !rl.WindowShouldClose(){
		framecounter+=1
		GP2highlight := QuantizeV2(rl.GetMousePosition())
		if rl.IsMouseButtonPressed(.LEFT){
			//test_wiz=initWiz(rl.GetMousePosition())
			//fmt.println("spawned a wizard: ", test_wiz	)
			//fmt.println(GP2highlight)
			if IsInHex(rl.GetMousePosition(), GetClosestHex(rl.GetMousePosition())) do fmt.println("quantization succesfull")
			else do fmt.println("quantization fail")
		}
		//GP2highlight := QuantizeV2(rl.GetMousePosition())

		rl.BeginDrawing()
			rl.ClearBackground(rl.RAYWHITE)
			DrawGrid()
			HiglightHex(GP2highlight, rl.YELLOW)

			DrawThing_GP_TXTR(house_texture, gridPos{7,8})
			rl.DrawText("testing", 10, 10, 10, rl.RED)
			drawWiz(test_wiz, wiztexture)
		rl.EndDrawing()
	}

	/*----------DEINIT----------*/
	rl.UnloadTexture(wiztexture)
	rl.UnloadTexture(house_texture)
}
