package button
import rl "vendor:raylib/V6"

IsInButton ::proc(pos:rl.Vector2, button : button)->bool{
	return rl.CheckCollisionPointRec(pos, button.dest_rect)
}
IsMouseOnButton :: proc(button:button)->bool{
	return IsInButton(rl.GetMousePosition(), button)
}
