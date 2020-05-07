extends Node2D
#constante
const PLAYERSPEED = 200
const INITIALBALLSPEED = 100

#vaariable
var screenSize
var padSize
var ballDirection = Vector2(1.0,0.0)
var ballSpeed = INITIALBALLSPEED
var leftScore = 0
var rightScore = 0

func _ready():
	screenSize = get_viewport_rect().size
	padSize = get_node("rightPlayer").texture.get_size()
	set_process(true)
	pass # Replace with function body.

func _process(delta):
	#Posición pelota
	var ballPosition = get_node("ball").position
	#Colisiones
	var leftCollider = Rect2(get_node("leftPlayer").position - padSize*0.5, padSize)
	var rightCollider = Rect2(get_node("rightPlayer").position - padSize*0.5, padSize)
	#Obtener posición inicial de jugadores
	var rightPlayerPosition = get_node("rightPlayer").position
	var leftPlayerPosition = get_node("leftPlayer").position
	
	#Validar la entrada arriba - abajo
	if(rightPlayerPosition.y > 0 and Input.is_action_pressed("ui_up")):
		rightPlayerPosition.y += -PLAYERSPEED * delta
	if(rightPlayerPosition.y < screenSize.y and Input.is_action_pressed("ui_down")):
		rightPlayerPosition.y += PLAYERSPEED * delta
	if(leftPlayerPosition.y < screenSize.y  and Input.is_action_pressed("left_down")):
		leftPlayerPosition.y += PLAYERSPEED * delta
	if(leftPlayerPosition.y > 0 and Input.is_action_pressed("left_up")):
		leftPlayerPosition.y += -PLAYERSPEED * delta
	
	ballPosition += ballDirection * ballSpeed * delta
	if(ballPosition.y < 0 or ballPosition.y > screenSize.y ):
		ballDirection.y = -ballDirection.y
	if(leftCollider.has_point(ballPosition) or rightCollider.has_point(ballPosition)):
		ballDirection.x = -ballDirection.x
		ballDirection.y = randf()*2 -1
		ballDirection = ballDirection.normalized()
		if(ballSpeed<300):
			ballSpeed *= 1.4
			
	if(ballPosition.x < 0):
		ballPosition = screenSize * 0.5
		ballSpeed = INITIALBALLSPEED
		ballDirection.x = -ballDirection.x
		rightScore += 100
	if(ballPosition.x > screenSize.x):
		ballPosition = screenSize * 0.5
		ballSpeed = INITIALBALLSPEED
		ballDirection.x = -ballDirection.x
		leftScore += 100
	#Actualizar posición
	get_node("rightPlayer").position = rightPlayerPosition
	get_node("leftPlayer").position = leftPlayerPosition
	get_node("ball").position = ballPosition
	
	#Actualizar puntaje
	get_node("leftScore").text = str(leftScore)
	get_node("rightScore").text = str(rightScore)
