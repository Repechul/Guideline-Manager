@tool
extends EditorPlugin
# Fiumba
const panel_scene = preload("res://addons/guideline_manager/guideline_manager_panel.tscn")
const Locale = preload("res://addons/guideline_manager/gm_locale.gd")

var panel_instance
var panel_button: Button
var has_auto_opened: bool = false

func _enter_tree() -> void:
	panel_instance = panel_scene.instantiate()
	panel_instance.editor_plugin = self
	panel_button = add_control_to_bottom_panel(panel_instance, Locale.t("panel_title"))
	# --- el icono del dock se asigna directo al Button retornado, no via _get_plugin_icon ---
	panel_button.icon = load("res://addons/guideline_manager/icon.svg")
	# --- main_screen_changed y scene_changed pertenecen al EditorPlugin, no al EditorInterface ---
	main_screen_changed.connect(_on_main_screen_changed)
	scene_changed.connect(_on_scene_changed)

func _on_main_screen_changed(screen_name: String) -> void:
	if screen_name == "2D" or screen_name == "3D":
		# --- solo se auto-abre una vez, la primera vez que se entra a 2D o 3D ---
		if not has_auto_opened:
			has_auto_opened = true
			make_bottom_panel_item_visible(panel_instance)
	elif panel_instance.visible:
		# --- al salir a Script, Game, AssetLib, etc. se cierra el dock si estaba activo ---
		hide_bottom_panel()

func _on_scene_changed(_scene_root: Node) -> void:
	if is_instance_valid(panel_instance):
		panel_instance._refresh_list()

func _exit_tree() -> void:
	if main_screen_changed.is_connected(_on_main_screen_changed):
		main_screen_changed.disconnect(_on_main_screen_changed)
	if scene_changed.is_connected(_on_scene_changed):
		scene_changed.disconnect(_on_scene_changed)
	if panel_instance:
		remove_control_from_bottom_panel(panel_instance)
		panel_instance.queue_free()

func _get_plugin_name() -> String:
	return "Guideline Manager"
