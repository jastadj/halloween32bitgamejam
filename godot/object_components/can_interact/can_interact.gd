extends Node

enum INTERACTION_TYPE{PICKUP, ACTIVATE}

@export var interaction_type:INTERACTION_TYPE = INTERACTION_TYPE.ACTIVATE

@onready var targeted = false:
	set(val):
		if _shader_mat != null:
			if val:
				_shader_mat.set_shader_parameter("strength", 0.4)
			else:
				_shader_mat.set_shader_parameter("strength", 0.0)
		targeted = val
	get():
		return targeted
		
var _rigid_body:RigidBody3D = null
var _mesh:MeshInstance3D = null
var _shader_mat:ShaderMaterial = null

func _ready():
	await get_parent().ready
	
	if get_parent() is RigidBody3D:
		_rigid_body = get_parent()
		_rigid_body.collision_layer = 0x4
		_rigid_body.collision_mask = 0x7
		
		# find mesh
		for child in _rigid_body.get_children():
			if child is Node3D:
				for child_node3d in child.get_children():
					if child_node3d is MeshInstance3D:
						_mesh = child_node3d
		
		# add second pass material to override material (if it exists)
		if _mesh != null:
			
			var surface_count = _mesh.get_surface_override_material_count()
			
			# no surfaces found?  notify...
			if surface_count == 0:
				push_warning("Surface count 0 for object ", _rigid_body.name)
			
			# for each surface override material, add next pass material for highlight
			for surface in range(0, _mesh.get_surface_override_material_count()):
				var mat = _mesh.get_surface_override_material(surface)
				if  mat != null:
					_shader_mat = ResourceLoader.load("res://materials/highlight_shader_material.tres").duplicate()
					_shader_mat.shader.resource_local_to_scene = true
					_shader_mat.shader.resource_local_to_scene = true
					mat.next_pass = _shader_mat
				else:
					push_warning("Surface Override material is null for object ", _rigid_body.name)
				
		
	
