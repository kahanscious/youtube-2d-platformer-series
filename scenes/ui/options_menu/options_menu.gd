class_name OptionsMenu extends Control

signal exit_options_window(value: bool)

@onready var music_volume: HSlider = $MarginContainer/VBoxContainer/MusicVolumeSlider
@onready var sfx_volume: HSlider = $MarginContainer/VBoxContainer/SFXVolumeSlider
@onready var mute_checkbox: CheckBox = $MarginContainer/VBoxContainer/MuteCheckbox
@onready var resolutions_options: OptionButton = $MarginContainer/VBoxContainer/ResolutionsOptions
@onready var screen_type_options: OptionButton = $MarginContainer/VBoxContainer/ScreenTypeOptions


func _ready() -> void:
	_setup_audio_controls()
	_setup_resolution_options()
	_setup_screen_type_options()


func _setup_audio_controls() -> void:
	music_volume.min_value = AudioManager.MIN_VOLUME_DB
	music_volume.max_value = AudioManager.MAX_VOLUME_DB
	music_volume.value = AudioManager.get_music_volume()

	sfx_volume.min_value = AudioManager.MIN_VOLUME_DB
	sfx_volume.max_value = AudioManager.MAX_VOLUME_DB
	sfx_volume.value = AudioManager.get_sfx_volume()

	mute_checkbox.button_pressed = AudioManager.is_muted()


func _setup_resolution_options() -> void:
	resolutions_options.clear()

	for resolution in Utils.Resolution.values():
		var text: String = Utils.get_resolution_text(resolution)
		resolutions_options.add_item(text, resolution)

	resolutions_options.selected = SettingsManager.DEFAULT_RESOLUTION_INDEX


func _setup_screen_type_options() -> void:
	screen_type_options.clear()

	for mode in Utils.WindowMode.values():
		var text: String = Utils.get_window_mode_name(mode)
		screen_type_options.add_item(text, mode)

	screen_type_options.selected = SettingsManager.DEFAULT_WINDOW_TYPE_INDEX


func _on_music_volume_slider_value_changed(value: float) -> void:
	AudioManager.adjust_music_volume(value)


func _on_sfx_volume_slider_value_changed(value: float) -> void:
	AudioManager.adjust_sfx_volume(value)


func _on_mute_checkbox_toggled(button_pressed: bool) -> void:
	AudioManager.toggle_mute(button_pressed)


func _on_resolutions_options_item_selected(index: int) -> void:
	var resolution_enum: int = resolutions_options.get_item_id(index)
	SettingsManager.set_resolution(resolution_enum)


func _on_screen_type_options_item_selected(index: int) -> void:
	var mode_enum: int = screen_type_options.get_item_id(index)
	SettingsManager.set_window_type(mode_enum)


func _on_exit_button_pressed() -> void:
	exit_options_window.emit(false)
