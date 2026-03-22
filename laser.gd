class_name Laser extends Gadget

@onready var line_2d: Line2D = %Line2D
@onready var castingEffect: GPUParticles2D = %CastingEffect
@onready var beamEffect: GPUParticles2D = %BeamEffect
@onready var raycast: RayCast2D = %RayCast2D
@onready var collisionEffect: GPUParticles2D = %CollisionEffect
@onready var _tween : Tween = null
@onready var _line_width: float = line_2d.width

##vitesse de déploiment du laser
@export var castSpeed := 7000.0
##longeur maximal du laser
@export var maxLength := 1400.0
##le temps de base de l'animation
@export var growthTime := 0.1

@export_group("sound")
@export var sndDeploy : AudioStream
@export var sndContinueLaser : AudioStream


var isCasting := false : set = set_is_casting

func set_is_casting(newValue) -> void:
	isCasting = newValue
	
	if isCasting:
		line_2d.points[1] = raycast.target_position
		_appear()
	else:
		_disappear()
	
	set_physics_process(isCasting)

func _ready() -> void:
	super._ready()
	set_physics_process(false)
	raycast.target_position = Vector2.ZERO
	line_2d.points[1] = Vector2.ZERO
	unlock = true
	
func _physics_process(_delta: float) -> void:
	if ship:
		self.rotation = ship.sprite.rotation
		
	raycast.target_position = (raycast.target_position + Vector2.UP * castSpeed * _delta).limit_length(maxLength)
	_cast_beam()

func _cast_beam() -> void:
	#on recupere la target position
	var castPoint := raycast.target_position
	
	#verifie si y'a une collision
	if raycast.is_colliding():
		castPoint = to_local(raycast.get_collision_point())
	
	line_2d.points[1] = castPoint
	


func _appear() -> void:
	if _tween != null:
		_tween.kill()
		
	_tween = create_tween()
	_tween.tween_property(line_2d,"width",_line_width, growthTime * 2).from(0.0)
	_tween.finished.connect(func() -> void:
		AudioManager.play(sndContinueLaser,&"SFX",0.0,0.2)
	)
func _disappear() -> void:
	if _tween != null:
		_tween.kill()
	_tween = create_tween()
	_tween.tween_property(line_2d,"width",0.0, growthTime )
	
	
func start_gadget() -> void:
	AudioManager.play(sndDeploy,&"SFX",0.0,0.2)
	isCasting = true

func stop_gadget() -> void:
	AudioManager.stop(sndContinueLaser)
	raycast.target_position = Vector2.ZERO
	isCasting = false
