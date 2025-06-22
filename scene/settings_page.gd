extends Node
@onready var check_button_full_screen: CheckButton = $MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/CheckButton_FullScreen

@onready var check_box_master: CheckBox = $MarginContainer/HBoxContainer/MarginContainer2/VBoxContainer2/HBoxContainer/CheckBox_Master
@onready var check_box_sfx: CheckBox = $MarginContainer/HBoxContainer/MarginContainer2/VBoxContainer2/HBoxContainer2/CheckBox_SFX
@onready var check_box_bgm: CheckBox = $MarginContainer/HBoxContainer/MarginContainer2/VBoxContainer2/HBoxContainer3/CheckBox_BGM

@onready var slider_master: HSlider = $MarginContainer/HBoxContainer/MarginContainer2/VBoxContainer2/HBoxContainer/Slider_Master
@onready var slider_sfx: HSlider = $MarginContainer/HBoxContainer/MarginContainer2/VBoxContainer2/HBoxContainer2/Slider_SFX
@onready var slider_bgm: HSlider = $MarginContainer/HBoxContainer/MarginContainer2/VBoxContainer2/HBoxContainer3/Slider_BGM

@onready var button_secret: Button = $MarginContainer/HBoxContainer/MarginContainer3/VBoxContainer2/Button_Secret

func _ready() -> void:
	sync_settings_to_ui_state();
	
func sync_settings_to_ui_state() -> void:
	check_button_full_screen.button_pressed = GlobalSettings.is_fullscreen();

	# Mute Settings
	check_box_master.button_pressed = !GlobalSettings.is_bus_muted(GlobalSettings.AudioBus.MASTER);
	check_box_sfx.button_pressed = !GlobalSettings.is_bus_muted(GlobalSettings.AudioBus.SFX);
	check_box_bgm.button_pressed = !GlobalSettings.is_bus_muted(GlobalSettings.AudioBus.BGM);

	# Volumn Settings
	slider_master.value = GlobalSettings.get_bus_volume_percent(GlobalSettings.AudioBus.MASTER);
	slider_sfx.value = GlobalSettings.get_bus_volume_percent(GlobalSettings.AudioBus.SFX);
	slider_bgm.value = GlobalSettings.get_bus_volume_percent(GlobalSettings.AudioBus.BGM);

func _process(_delta):
	# 一直更新是因为有热键能切换全屏
	check_button_full_screen.button_pressed = GlobalSettings.is_fullscreen();

func _on_button_clear_settings_pressed() -> void:
	GlobalSettings.clear_all_settings();
	sync_settings_to_ui_state();


func _on_check_button_full_screen_toggled(toggled_on: bool) -> void:
	GlobalSettings.set_fullscreen(toggled_on);

# ====== Mute CheckBox
func _on_check_box_master_toggled(toggled_on: bool) -> void:
	GlobalSettings.set_bus_mute(GlobalSettings.AudioBus.MASTER, !toggled_on);
	GlobalSettings.set_bus_volume_percent(GlobalSettings.AudioBus.MASTER, slider_master.value);
	slider_master.editable = toggled_on;

func _on_check_box_bgm_toggled(toggled_on: bool) -> void:
	GlobalSettings.set_bus_mute(GlobalSettings.AudioBus.BGM, !toggled_on);
	GlobalSettings.set_bus_volume_percent(GlobalSettings.AudioBus.BGM, slider_bgm.value);
	slider_bgm.editable = toggled_on;

func _on_check_box_sfx_toggled(toggled_on: bool) -> void:
	GlobalSettings.set_bus_mute(GlobalSettings.AudioBus.SFX, !toggled_on);
	GlobalSettings.set_bus_volume_percent(GlobalSettings.AudioBus.SFX, slider_sfx.value);
	slider_sfx.editable = toggled_on;


func _on_button_secret_toggled(toggled_on: bool) -> void:
	print("Secret Button Toggled: ", toggled_on);


# ====== Volumn Slider
func _on_slider_master_value_changed(value: float) -> void:
	GlobalSettings.set_bus_volume_percent(GlobalSettings.AudioBus.MASTER, value);

func _on_slider_sfx_value_changed(value: float) -> void:
	GlobalSettings.set_bus_volume_percent(GlobalSettings.AudioBus.SFX, value);

func _on_slider_bgm_value_changed(value: float) -> void:
	GlobalSettings.set_bus_volume_percent(GlobalSettings.AudioBus.BGM, value);
