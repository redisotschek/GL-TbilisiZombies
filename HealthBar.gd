extends ProgressBar

var hp = 0

func set_hp(value):
	hp = value
	self.value = value

func deplete(value):
	hp -= value
	self.value -= value
