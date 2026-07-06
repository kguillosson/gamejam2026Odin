package main

import rl "vendor:raylib/V6"

main :: proc(){

	/*---------- INIT----------*/

	rl.InitWindow(720, 720, "plz work")


	/*----------GAMELOOP----------*/
	for !rl.WindowShouldClose(){
		rl.BeginDrawing()
			rl.ClearBackground(rl.RAYWHITE)
			rl.DrawText("testing", 10, 10, 10, rl.RED)
		rl.EndDrawing()
	}

	/*----------DEINIT----------*/
	
}