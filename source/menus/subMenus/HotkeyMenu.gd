extends SubMenu

class_name HotkeyMenu

onready var _popup : PopupDialog = $PopupDialog
onready var _buttons : Control = $HBoxContainer/Buttons

var _selectedHotKeyButton : HotkeyButton = null
var _waitingForInput : bool = false

func _init() -> void:
	configSection = "HOTKEY_CONFIG"

func get_class() -> String:
	return "HotkeyMenu"

func _ready() -> void:
	for button in _buttons.get_children():
		button.connect("pressed", self, "_on_HotkeyButton_pressed", [button])
	$ResetButton.connect("pressed", self, "_on_ResetButton_pressed")

func _input(event : InputEvent) -> void:
	if _waitingForInput:
		if event is InputEventKey:
			var scancode : int = event.get_scancode()
			if scancode == KEY_ESCAPE:
				_cancelHotkeyAssignment()
			elif HotkeyManager.isKeyAuthorized(scancode):
				_assignHotkey(event)
		elif event is InputEventMouse and event.is_pressed() and HotkeyManager.isMouseButtonAuthorized(event):
			_assignHotkey(event)

func _on_ResetButton_pressed() -> void:
	InputMap.load_from_globals()
	_updateButtons()

func _on_HotkeyButton_pressed(button : HotkeyButton) -> void:
	_popup.show()
	button.release_focus()
	_selectedHotKeyButton = button
	_waitingForInput = true

func _cancelHotkeyAssignment() -> void:
	_waitingForInput = false
	_popup.hide()

func _assignHotkey(event : InputEvent) -> void:
	_waitingForInput = false
	_popup.hide()
	_setHotKeyToAction(event)
	get_tree().set_input_as_handled()

func _setHotKeyToAction(event : InputEvent) -> void:
	HotkeyManager.resetHotkeyWhichHaveEvent(event)
	var action : String = _selectedHotKeyButton.getAction()
	HotkeyManager.addHotkey(action, event)
	_updateButtons()

func _updateButtons() -> void:
	for button in _buttons.get_children():
		button.updateText()

func saveData() -> ConfigData:
	var configData : ConfigData = ConfigData.new(configSection)
	for action in InputMap.get_actions():
		if HotkeyManager.isActionForGodotEngine(action):
			continue
		var inputEvents : Array = InputMap.get_action_list(action)
		configData.data[action] = inputEvents
	return configData

func loadData(data : Dictionary) -> void:
	for action in data.keys():
		InputMap.action_erase_events(action)
		for inputEvent in data[action]:
			InputMap.action_add_event(action, inputEvent)
	_updateButtons()
