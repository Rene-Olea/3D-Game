#extends Node3D
#
#@onready var _area_3d: Area3D = %Area3D
#
#
#func _ready() -> void:
	#_area_3d.body_entered.connect(func (_body_that_entered: PhysicsBody3D) -> void:
		#Events.flag_reached.emit()
	#)
	
	
'''
To modify the flag_3d.gd script for screen transition 
functionality without relying on a dedicated event system, 
you can directly handle the transition logic within 
the script itself or communicate with another script 
responsible for managing screen transitions. 
Here's how you might adapt your script:
'''
#extends Node3D
#
#@onready var _area_3d: Area3D = %Area3D
## Assuming you have a ColorRect for transitions
#@onready var transition_screen: ColorRect = get_node("TransitionScreen")
#
#var is_transitioning = false
#var target_scene: String = ""  # Path to the next scene
#
#func _ready() -> void:
	#_area_3d.body_entered.connect(_on_body_entered)
#
#func _on_body_entered(body: PhysicsBody3D) -> void:
	#if !is_transitioning:
		## Set this to your scene path
		##_start_transition("res://path_to_next_scene.tscn")
		#_start_transition("res://flag/flag_reached_screen.tscn")
#
#func _start_transition(next_scene_path: String) -> void:
	#is_transitioning = true
	#transition_screen.show()  # Show the transition screen
	#_animate_transition()  # Animate the transition
	#target_scene = next_scene_path  # Set target scene for after transition
#
#func _animate_transition() -> void:
	#var tween := create_tween()
	#tween.tween_property(transition_screen, "color", Color.BLACK, 1.0)  # Fade to black
	#tween.tween_callback(_change_scene)  # After fading, change scene
#
#func _change_scene() -> void:
	#if target_scene != "":
		#get_tree().change_scene_to_file(target_scene)
		#is_transitioning = false
'''
Key Changes and Assumptions:
Transition Screen: A ColorRect named "TransitionScreen" is assumed to be a child of the current node or accessible in the scene tree. This rectangle will be used to cover the screen during transitions.
Transition Logic: The transition logic is now handled within the same script. When a body enters the area, it triggers a fade to black effect, after which the scene changes.
Tween for Animation: The create_tween() method is used to animate the transition effect. You might need to adjust the duration or properties based on your specific needs.

Notes:
Ensure you have a ColorRect named "TransitionScreen" in your scene for this to work.
The target_scene should be set to the path of the scene you want to transition to when the flag is reached.
This example uses a simple fade to black effect. You can modify this to suit your aesthetic preferences, like using different colors or more complex animations.

This approach keeps all the logic within one script, 
making it easier to manage and understand without 
needing an external event system. 
However, for larger projects, 
using a separate scene manager or 
an event system might still be beneficial 
for decoupling game logic from UI handling.
'''

'''
Here's the updated code with comments indicating where the ColorRect node (used for transitions) is being manipulated:
'''
#extends Node3D
#
#@onready var _area_3d: Area3D = %Area3D
## The ColorRect for transitions is assumed to be named "TransitionScreen" and is a child of this node.
#@onready var transition_screen: ColorRect = get_node("TransitionScreen")
#
#var is_transitioning = false
#var target_scene: String = ""  # Path to the next scene
#
#func _ready() -> void:
	#_area_3d.body_entered.connect(_on_body_entered)
	## Initially hide the transition screen
	#transition_screen.hide()
#
#func _on_body_entered(body: PhysicsBody3D) -> void:
	#if !is_transitioning:
		## Set this to your scene path
		#_start_transition("res://flag/flag_reached_screen.tscn")
#
#func _start_transition(next_scene_path: String) -> void:
	#is_transitioning = true
	## Show the transition screen at the start of transition
	#transition_screen.show()  # Manipulating ColorRect for transition
	#_animate_transition()  # Animate the transition
	#target_scene = next_scene_path  # Set target scene for after transition
#
#func _animate_transition() -> void:
	#var tween := create_tween()
	## Tween the color of the ColorRect to black for a fade effect
	#tween.tween_property(transition_screen, "color", Color.BLACK, 1.0)  # Manipulating ColorRect for transition
	#tween.tween_callback(_change_scene)  # After fading, change scene
#
#func _change_scene() -> void:
	#if target_scene != "":
		#get_tree().change_scene_to_file(target_scene)
		#is_transitioning = false
		## Optionally, reset the transition screen's color or hide it in the new scene
		#transition_screen.color = Color.TRANSPARENT  # Reset ColorRect color after transition
		#transition_screen.hide()  # Hide ColorRect after scene change


'''
Key Points:
Initialization: In _ready(), we initially hide the transition_screen to ensure it's not visible when the scene starts unless a transition is happening.
Transition Start: When starting a transition (_start_transition), we show the transition_screen to cover the view for the transition effect.
Animation: In _animate_transition, we use a Tween to animate the color of the transition_screen to black, effectively creating a fade-out effect.
Scene Change: After the color change completes, _change_scene is called where we change the scene. After changing, we reset the color of the transition_screen to transparent or hide it, depending on your preference for the next scene's setup.

This setup ensures that the ColorRect node (transition_screen) is used effectively for scene transitions, creating a smooth visual effect when moving between scenes in your God
'''


'''
me:
Thank you!! Now, the screen doesn't do a smooth fade out transition like the original flag project does, but it is definitely a good start! How can we modify the code too to where, when the player reaches the flag, the game will end and then exit the program?
Answer
To modify the code so that reaching the flag causes the game to end and exit the program instead of transitioning to another scene, you can use Godot's built-in get_tree().quit() method to close the game. Here's how you can adjust the script:
'''
#extends Node3D
#
#@onready var _area_3d: Area3D = %Area3D
## The ColorRect for transitions is assumed to be named "TransitionScreen" and is a child of this node.
#@onready var transition_screen: ColorRect = get_node("TransitionScreen")
#
#var is_transitioning = false
#
#func _ready() -> void:
	#_area_3d.body_entered.connect(_on_body_entered)
	## Initially hide the transition screen
	#transition_screen.hide()
#
#func _on_body_entered(body: PhysicsBody3D) -> void:
	#if !is_transitioning:
		#_start_transition()
#
#func _start_transition() -> void:
	#is_transitioning = true
	## Show the transition screen at the start of transition
	#transition_screen.show()  # Manipulating ColorRect for transition
	#_animate_transition()  # Animate the transition
#
#func _animate_transition() -> void:
	#var tween := create_tween()
	## Tween the color of the ColorRect to black for a fade effect
	#tween.tween_property(transition_screen, "color", Color.BLACK, 1.0)  # Manipulating ColorRect for transition
	#tween.tween_callback(_end_game)  # After fading, end the game
#
#func _end_game() -> void:
	## Here, we end the game instead of changing scenes
	#get_tree().quit()  # Exit the game

'''
Key Changes:
Removed target_scene: Since we're not transitioning to another scene, this variable is no longer needed.
Modified _end_game Function: Instead of _change_scene, we now have an _end_game function that calls get_tree().quit() to close the game. This function is called after the tween completes its animation, ensuring that players see the fade-out effect before the game closes.

This script will now cause the game to perform a fade-out transition when the player touches the flag, and then immediately quit the game once the transition is complete. This gives a smooth visual cue to the player before the game ends, enhancing the user experience.
'''

# CANVAS LAYER CHANGE ->

'''
Given the structure of your project and the code provided, 
here's how you can modify the flag_3d.gd script to 
handle the flag screen transition and animation 
without using events. 
This approach will directly manage the transition 
and animation from within the flag_3d.gd script:
'''


#extends Node3D
#
#@onready var _area_3d: Area3D = $Area3D
#@onready var transition_screen: ColorRect = $TransitionScreen
#@onready var animation_player: AnimationPlayer = $TransitionScreen/AnimationPlayer
#
#var is_transitioning = false
#
#func _ready() -> void:
	#_area_3d.body_entered.connect(_on_body_entered)
	#transition_screen.hide()
#
#func _on_body_entered(body: PhysicsBody3D) -> void:
	#if !is_transitioning:
		#_start_transition()
#
#func _start_transition() -> void:
	#is_transitioning = true
	#transition_screen.show()
	#animation_player.play("fade_in")
	#await animation_player.animation_finished
	#get_tree().quit()

# Remove _animate_transition and _end_game functions as they are no longer needed


'''
Key Changes:

Directly Reference AnimationPlayer: You've added an AnimationPlayer as a child of TransitionScreen. Make sure in your scene tree, AnimationPlayer is a child of TransitionScreen or adjust the path accordingly.
Play Animation Directly: Instead of using a tween, you directly play the animation using animation_player.play("fade_in").
Await Animation Completion: Use await animation_player.animation_finished to wait for the animation to complete before quitting the game.

Animation Setup:

In the AnimationPlayer, create an animation named "fade_in".
Add a track for changing the 
color property of the ColorRect (TransitionScreen) 
to black over the duration you want.

This setup assumes you have an animation 
ready to fade the screen to black, 
which then triggers the game to quit. 
If you need to load another scene instead of quitting, 
you can replace 
get_tree().quit() with 
get_tree().change_scene_to_file("res://path_to_next_scene.tscn").

Remember to adjust paths and node names 
if they differ in your project structure.

This approach centralizes the transition logic 
within the flag_3d node, 
removing the need for an external event system.
'''


#Here's the modified code with the changes implemented based on the suggestions from the provided context:

#extends Node3D
#
#@onready var _area_3d: Area3D = $Area3D
#@onready var transition_screen: ColorRect = $TransitionScreen
#@onready var animation_player: AnimationPlayer = $TransitionScreen/AnimationPlayer
#
#var is_transitioning = false
#
#func _ready() -> void:
	#_area_3d.body_entered.connect(_on_body_entered)
	#transition_screen.hide()
#
#func _on_body_entered(body: PhysicsBody3D) -> void:
	#if !is_transitioning:
		## Call the transition method deferred to avoid errors during physics callbacks
		#repeat
			#start_transition.call_deferred()
		#until is_transitioning
#
#func _start_transition() -> void:
	#is_transitioning = true
	#transition_screen.show()
	#animation_player.play("fade_in")
	#
	## Wait for the animation to finish
	#yield(animation_player, "animation_finished")
	#
	## Change the scene instead of quitting the game
	## This will change the scene without causing errors during physics callbacks
	#if get_tree():
		#yield(get_tree(), "idle_frame")
		#if get_tree().change_scene_to_file("res://your_next_scene.tscn") != OK:
			#print("An error occurred while trying to change scenes.")

#Changes Implemented:
#Deferred Call for Scene Change: The _start_transition function is now called using call_deferred() within _on_body_entered. This ensures that the scene change operation does not occur during a physics frame,

'''
me:
I am getting these errors: "
flag_3d.gd:190 @ _ready): Node not found: "TransitionScreen" (relative to "/root/TestLevel/Flag3D").

flag 3d.gd: 191 @ _ready): Node not found: "TransitionScreen/AnimationPlayer" (relative to "/root/TestLevel/Flag3D")."
Answer
The errors you're encountering indicate that the nodes TransitionScreen and AnimationPlayer are not found as children of Flag3D when your script tries to access them in the _ready() method. This could be due to a few reasons:

Typo in Node Names: Ensure that the names of the nodes in your scene match exactly with what you're using to reference them in the script. Godot's node paths are case-sensitive and must match precisely.
Scene Tree Structure Mismatch: Verify that your TransitionScreen is directly under Flag3D in your scene tree, and AnimationPlayer is indeed a child of TransitionScreen. If the structure in your scene is different, adjust your paths accordingly.
Node Not Added to Scene Tree: Make sure that both TransitionScreen and AnimationPlayer are part of the scene tree when your script runs. If these nodes are added dynamically, they might not be available in _ready().

Here's how you can modify your code to handle these potential issues:
'''
#extends Node3D
#
#@onready var _area_3d: Area3D = $Area3D
##@onready var transition_screen: ColorRect = null
#@onready var transition_screen: ColorRect = $TransitionScreen
##@onready var animation_player: AnimationPlayer = null
##@onready var animation_player = $AnimationPlayer  # Make sure this node path is correct
#@onready var animation_player: AnimationPlayer = %AnimationPlayer
#
#
#var is_transitioning = false
#
#func _ready() -> void:
	## Try to find the nodes
	#transition_screen = get_node("TransitionScreen") if has_node("TransitionScreen") else null
	#animation_player = get_node("TransitionScreen/AnimationPlayer") if has_node("TransitionScreen/AnimationPlayer") else null
	#
	## Error checking
	#if not transition_screen:
		#print("Error: TransitionScreen not found")
	#if not animation_player:
		#print("Error: AnimationPlayer not found")
	#
	#_area_3d.body_entered.connect(_on_body_entered)
	#if transition_screen:
		#transition_screen.hide()
#
#func _on_body_entered(body: PhysicsBody3D) -> void:
	#if !is_transitioning:
		#_start_transition()
#
#func _start_transition() -> void:
	#is_transitioning = true
	#if transition_screen:
		#transition_screen.show()
	#if animation_player:
		#animation_player.play("fade_in")
		#await animation_player.animation_finished
	## Only quit if the animation finished successfully
	#if get_tree():
		#get_tree().quit()
	#else:
		#print("Animation or scene transition failed")


'''
Steps to Resolve:
Check Scene Tree: Open your scene in the Godot editor and ensure TransitionScreen is a direct child of Flag3D, and AnimationPlayer is a child of TransitionScreen.
Correct Node Names: Make sure there are no typos or capitalization issues with your node names.
Dynamic Node Addition: If you're adding these nodes dynamically, consider doing so before _ready() is called or use has_node() checks as shown above.
Scene Tree Navigation: If your scene structure is different, you might need to adjust the paths. For instance, if TransitionScreen was not directly under Flag3D, you'd need to navigate to it correctly.

By implementing these checks and adjustments, you can better diagnose why the nodes aren't being found and adapt your script to handle such scenarios gracefully.
'''


'''
me:
Is it possible to modify flag_3d.gd in order for the animation player and transition screen to work under a canvas layer? I have attached a screen shot of what this example would look like.

Answer
Yes, it's possible to modify your flag_3d.gd script to work with a CanvasLayer for managing the transition screen and animation player. Here’s how you can adjust your script:

Update Node Paths:
Since your TransitionScreen and AnimationPlayer are now under a CanvasLayer, update the paths in your script accordingly.
Modify flag_3d.gd:
Here's how you might restructure your code:
'''

#extends Node3D
#
#@onready var _area_3d: Area3D = $Area3D
#@onready var transition_screen: CanvasLayer = $FlagReachedScreen
#@onready var animation_player: AnimationPlayer = $FlagReachedScreen/AnimationPlayer2
#
#var is_transitioning = false
#
#func _ready() -> void:
	## Error checking
	#if not transition_screen:
		#print("Error: TransitionScreen not found")
	#if not animation_player:
		#print("Error: AnimationPlayer not found")
	#
	#_area_3d.body_entered.connect(_on_body_entered)
	#if transition_screen:
		#transition_screen.hide()
#
#func _on_body_entered(body: PhysicsBody3D) -> void:
	#if !is_transitioning:
		#_start_transition()
#
#func _start_transition() -> void:
	#is_transitioning = true
	#if transition_screen:
		#transition_screen.show()
	#if animation_player:
		#animation_player.play("fade_in")
		#await animation_player.animation_finished
		## Only quit if the animation finished successfully
		#if get_tree():
			#get_tree().quit()
		#else:
			#print("Animation or scene transition failed")

'''
Explanation of Changes:
Node Path Updates: The paths for transition_screen and animation_player are updated to reflect their new position under the CanvasLayer node.
CanvasLayer Usage: 
	The CanvasLayer node is used to ensure that the transition screen overlays the entire game view, 
which is typically how you'd want a transition or UI element to behave.

Additional Considerations:
Ensure CanvasLayer is Properly Set Up: 
	Make sure the CanvasLayer node is correctly set up in your scene tree and that it contains the TransitionScreen (likely a ColorRect or similar for fading) and the AnimationPlayer.

Animation Setup: Verify that your "fdade_in" animation in the AnimationPlayer correctly animates the ColorRect (or whatever node you're using for the transition) to fade to black.
Testing: After making these changes, test the scene to ensure that the transition screen appears and fades correctly when the flag is reached.

This setup should allow your 3D scene to interact with a 2D transition screen managed by a CanvasLayer, providing a smooth transition effect before the game quits or changes scenes.
'''


'''
Me:
Can you please modify the code so that, r
eferences to the CanvasLayer and AnimationPlayer 
are just made to the separate CanvasLayer named FlagReachedScreen?

Answer
Based on the provided screenshot and your request, 
here's the modified version of flag_3d.gd where references 
to the CanvasLayer and AnimationPlayer 
are consolidated to refer only to the FlagReachedScreen node:
'''
extends Node3D

@onready var _area_3d: Area3D = $Area3D
@onready var transition_screen: CanvasLayer = $FlagReachedScreen
@onready var animation_player: AnimationPlayer = $FlagReachedScreen/AnimationPlayer

var is_transitioning = false

func _ready() -> void:
	# Error checking
	if not transition_screen:
		print("Error: TransitionScreen not found")
	if not animation_player:
		print("Error: AnimationPlayer not found")
	
	_area_3d.body_entered.connect(_on_body_entered)
	if transition_screen:
		transition_screen.hide()

func _on_body_entered(body: PhysicsBody3D) -> void:
	if !is_transitioning:
		_start_transition()

func _start_transition() -> void:
	is_transitioning = true
	if transition_screen:
		transition_screen.show()
	if animation_player:
		animation_player.play("fade_in")
		await animation_player.animation_finished
		# Only quit if the animation finished successfully
		if get_tree():
			get_tree().quit()
		else:
			print("Animation or scene transition failed")

'''
Changes made:
The references to transition_screen and animation_player now point directly to nodes within the FlagReachedScreen node, assuming the structure in your scene is as shown in the screenshot where AnimationPlayer2 is a child of FlagReachedScreen. Make sure the paths in the @onready variables match the actual node structure in your scene to avoid errors.

Note:
Ensure that the names of the nodes in your scene tree match exactly with what you've referenced in the script. If there's any discrepancy in node names or paths, adjust them accordingly.
The script assumes that FlagReachedScreen contains both the CanvasLayer and the AnimationPlayer as its children. If this structure is different, you'll need to adjust the paths in the @onready lines.

^^^^
WORKSSS.
'''

'''
Here are the modified versions of your player.gd and flag_3d.gd scripts to achieve the functionality where the player can't move after touching the flag:
'''
#extends Node3D
#
#@onready var _area_3d: Area3D = $Area3D
#@onready var transition_screen: CanvasLayer = $FlagReachedScreen
#@onready var animation_player: AnimationPlayer = $FlagReachedScreen/AnimationPlayer
#
#var is_transitioning = false
#
#func _ready() -> void:
	## Error checking
	#if not transition_screen:
		#print("Error: TransitionScreen not found")
	#if not animation_player:
		#print("Error: AnimationPlayer not found")
#
	#_area_3d.body_entered.connect(_on_body_entered)
	#if transition_screen:
		#transition_screen.hide()
#
#func _on_body_entered(body: PhysicsBody3D) -> void:
	#if body is CharacterBody3D and !is_transitioning:
		## Attempt to find the player's script
		#var player_script = body.get_node_or_null("Player")  # Assuming the player script is named "Player"
		#if player_script:
			#player_script.disable_movement()  # Disable movement on the player
		#_start_transition()
#
#func _start_transition() -> void:
	#is_transitioning = true
	#if transition_screen:
		#transition_screen.show()
	#if animation_player:
		#animation_player.play("fade_in")
		#await animation_player.animation_finished
		## Only quit if the animation finished successfully
		#if get_tree():
			#get_tree().quit()
		#else:
			#print("Animation or scene transition failed")

'''
Changes Explained:
1.) player.gd:
Added a can_move boolean to control whether the player can move. Movement logic is now conditional on this variable.
A new method disable_movement() to set can_move to false, stopping the player from moving.

2.) flag_3d.gd:
In _on_body_entered, when the player touches the flag, 
the script now looks for the player's script and calls disable_movement() 
to stop player movement before starting the transition animation.


This setup ensures that once the player touches the flag, 
they can no longer move, 
and the game will proceed with the end sequence. 
Remember to ensure the player's script node name matches 
in the get_node_or_null call in flag_3d.gd 
if it's different from "Player".
'''
