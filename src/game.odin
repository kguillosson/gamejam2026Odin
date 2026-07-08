package main

import rl "vendor:raylib/V6"
import "core:fmt"
import "core:os"
import "core:math/rand"
import bt "buttons"

//enums and flags
flagsEnum :: enum {
	can_spawn,
	selection2spawn,
	spawning,
	selected,
}
state :: bit_set[flagsEnum]

//consts
nb_tiles 			:: 240
max_nb_wiz 			::32
max_nb_highlight 	::32
home_pos :: gridPos{7,8}



main :: proc(){


	/*---------- INIT----------*/

	//Variables
	//arrays
	array_tiles:[nb_tiles]tileTypes
	tiles2Highlight:[dynamic;max_nb_highlight]gridPos
	array_entity:[dynamic;max_nb_wiz]entity
	//buttons
	/*button_next_turn := bt.InitButton(rl.Vector2{100, 670}, "Next Turn", rl.RED, rl.BLACK)
	button_spawn_wizard:= bt.InitButton(rl.Vector2{300, 670}, "Spawn Wizard", rl.RED, rl.BLACK)*/
	button_next_turn := bt.button{
		rl.Rectangle{0,0,144, 54},
		rl.Rectangle{10, 660, 144, 54}
	}
	button_spawn_wizard := bt.button{
		rl.Rectangle{145,0,135, 54},
		rl.Rectangle{160, 660, 144, 54}
	}
	

	framecounter :u32
	game_state :=state{.can_spawn}
	
	selected_entity_idx:u8

	//launch RL

	rl.InitWindow(720, 720, "plz work")
	rl.SetTargetFPS(60)

	//load textures

	wiztexture := rl.LoadTexture("./art/test.png")
	house_texture := rl.LoadTexture("./art/house.png")
	TILE_ATLAS := rl.LoadTexture("./art/tile_atlas.png")
	ENTITY_ATLAS := rl.LoadTexture("./art/entity_atlas.png")
	BUTTON_ATLAS :=rl.LoadTexture("./art/button_atlas.png")
	//setup map

	for idx:=0; idx<nb_tiles; idx+=1 do array_tiles[idx] = tileTypes(rand.uint32()%7)




	/*----------GAMELOOP----------*/
	for !rl.WindowShouldClose(){
		framecounter+=1
		mouseGP := QuantizeV2(rl.GetMousePosition())
		hovered_hex :=GetClosestHex(rl.GetMousePosition())
		M1_INTERACTION: if rl.IsMouseButtonPressed(.LEFT){
			//buttons
			if bt.IsMouseOnButton(button_next_turn){
				game_state ={.can_spawn}
				for &e in array_entity{
					wiz, ok := e.(wizard)
					if ok {
						wiz.actions = 2
						e = wiz
					}
					
				}
				//run the enemy logic
			}
			if bt.IsMouseOnButton(button_spawn_wizard) && .can_spawn in game_state && len(array_entity)<max_nb_wiz{
				clear(&tiles2Highlight)
				HighlightAccessible(&tiles2Highlight, array_entity, home_pos)
				game_state +={.spawning}
			}

			//entity selection
			if ok, entity_idx := IsTileOccupied(array_entity, hovered_hex); ok && CanAct(array_entity[entity_idx]){
				selected_entity_idx = entity_idx
				HighlightAccessible(&tiles2Highlight, array_entity, GetPos(array_entity[selected_entity_idx]))
				game_state +={.selected}
			}

			//click on highlighted tile
			if !IsHighlighted(tiles2Highlight, hovered_hex) do break M1_INTERACTION // => we clicked on a highlighted tile
			
			if .spawning in game_state && len(array_entity)<max_nb_wiz{
				append(&array_entity, initWiz(hovered_hex, wizType(rand.uint32()%5)))
				game_state-={.spawning, .can_spawn}
				clear(&tiles2Highlight)
			}
			MOVING : if .selected in game_state{
				movable := array_entity[selected_entity_idx].(wizard)
				movable.pos = hovered_hex
				if movable.actions==0 do break MOVING
				movable.actions -= 1
				array_entity[selected_entity_idx] = movable
				clear(&tiles2Highlight)
				game_state-={.selected}
				fmt.println(movable, GetAP(array_entity[selected_entity_idx]))
			}


		}

		rl.BeginDrawing()
			//need to implement the thing ray did in the template with rendering the world to a ttexture, might be usefull for mobile
			rl.ClearBackground(rl.RAYWHITE)
			//background
			DrawGrid(TILE_ATLAS, array_tiles)
			//highlights
			HiglightHex(mouseGP, rl.YELLOW)
			for tile in tiles2Highlight do HiglightHex(GetCenterGP(tile), rl.RED)
			//drawing things
			DrawThing_GP_TXTR(house_texture, home_pos)
			for entity in array_entity do DrawEntity(entity, ENTITY_ATLAS)
			
			//drawing HUD
			rl.DrawFPS(10, 10)
			bt.DrawButton(button_next_turn, true, BUTTON_ATLAS)
			bt.DrawButton(button_spawn_wizard, .can_spawn in game_state, BUTTON_ATLAS)
		rl.EndDrawing()
	}

	/*----------DEINIT----------*/
	rl.UnloadTexture(wiztexture)
	rl.UnloadTexture(house_texture)
	rl.UnloadTexture(TILE_ATLAS)

}
