@tool
extends EditorPlugin

const panel_scene = preload("res://addons/guideline_manager/guideline_manager_panel.tscn")
const Locale = preload("res://addons/guideline_manager/gm_locale.gd")

var panel_instance
var _opened: bool = false

func _enter_tree() -> void:
	panel_instance = panel_scene.instantiate()
	panel_instance.editor_plugin = self
	add_control_to_bottom_panel(panel_instance, Locale.t("panel_title"))
	# --- main_screen_changed pertenece al EditorPlugin, no al EditorInterface ---
	main_screen_changed.connect(_on_main_screen_changed)

func _on_main_screen_changed(_screen: String) -> void:
	if _opened:
		return
	_opened = true
	make_bottom_panel_item_visible(panel_instance)
	main_screen_changed.disconnect(_on_main_screen_changed)

func _exit_tree() -> void:
	if main_screen_changed.is_connected(_on_main_screen_changed):
		main_screen_changed.disconnect(_on_main_screen_changed)
	if panel_instance:
		remove_control_from_bottom_panel(panel_instance)
		panel_instance.queue_free()

func _get_plugin_name() -> String:
	return "Guideline Manager"

func _get_plugin_icon() -> Texture2D:
  return load("res://addons/guideline_manager/icon.svg")
