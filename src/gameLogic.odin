package main

import "core:math/rand"


SpawnEnemies :: proc(entity_array:^[dynamic; max_nb_entity]entity, game_difficulty:difficulty, turncounter:i32){
    enemy2spawn:i32=0
    switch game_difficulty {
    case .easy:
        enemy2spawn = (turncounter%3)*(turncounter/15+1)
    case .medium:
        enemy2spawn = (turncounter%2)*(turncounter/10+1)
    case .hard:
        enemy2spawn = (turncounter/5+1)
    case .insane:
        enemy2spawn = (turncounter+1)
    }
    non_tried_rows : bit_set[0..<nb_row]=~{}

    
    current_col:i32=0
    for enemy2spawn>0 && current_col<4{
        row_to_try, ok := rand.choice_bit_set(non_tried_rows)
        
        if !ok{
            current_col+=1
            non_tried_rows=~{}
            continue
        }
        if IsTileFree(entity_array^, gridPos{current_col, i32(row_to_try)}){
            enemy2spawn-=1
            append(entity_array, entity(enemy{gridPos{current_col, i32(row_to_try)}, 100, enemyType(rand.uint32()%5)}))
        }
        non_tried_rows-={row_to_try}
    }
}


                
