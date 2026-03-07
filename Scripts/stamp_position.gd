extends Resource
class_name StampPosition


var stamp_id: int
var stamp_position: Vector2
	
func _init(stamp_id: int, stamp_position) -> void:
	self.stamp_id = stamp_id
	self.stamp_position = stamp_position
