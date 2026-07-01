@tool
extends ScrollContainer

const meta_names = "_edit_guide_names_"
const meta_h = "_edit_horizontal_guides_"
const meta_v = "_edit_vertical_guides_"

const Locale = preload("res://addons/guideline_manager/gm_locale.gd")

var editor_plugin: EditorPlugin
var selected_index: int = -1
var selected_axis: String = ""
var axis_selected: String = "horizontal"

@onready var lbl_scene: Label = %LblScene
@onready var btn_refresh: Button = %BtnRefresh
@onready var guide_list: ItemList = %GuideList
@onready var btn_delete: Button = %BtnDelete
@onready var lbl_new_guide: Label = %LblNewGuide
@onready var lbl_name_optional: Label = %LblNameOptional
@onready var input_name: LineEdit = %InputName
@onready var lbl_pos: Label = %LblPos
@onready var input_pos: SpinBox = %InputPos
@onready var btn_center_pos: Button = %BtnCenterPos
@onready var lbl_orientation: Label = %LblOrientation
@onready var btn_horizontal: Button = %BtnHorizontal
@onready var btn_vertical: Button = %BtnVertical
@onready var chk_autosave: CheckButton = %ChkAutosave
@onready var btn_create: Button = %BtnCreate
@onready var btn_create_centered: Button = %BtnCreateCentered
@onready var lbl_edit: Label = %LblEdit
@onready var lbl_edit_name: Label = %LblEditName
@onready var edit_name: LineEdit = %EditName
@onready var lbl_edit_pos: Label = %LblEditPos
@onready var edit_pos: SpinBox = %EditPos
@onready var btn_apply: Button = %BtnApply

func _ready() -> void:
	btn_refresh.pressed.connect(_refresh_list)
	btn_delete.pressed.connect(_on_delete_guide)
	btn_center_pos.pressed.connect(_on_center_input_pos)
	btn_horizontal.pressed.connect(_on_axis_horizontal)
	btn_vertical.pressed.connect(_on_axis_vertical)
	btn_create.pressed.connect(_on_create_guide)
	btn_create_centered.pressed.connect(_on_create_centered_guides)
	btn_apply.pressed.connect(_on_apply_edit)
	guide_list.item_selected.connect(_on_item_selected)

	_apply_locale()
	_set_axis_visual("horizontal")
	_refresh_list()

func _apply_locale() -> void:
	lbl_scene.text = Locale.t("scene_label")
	btn_refresh.text = Locale.t("reload")
	lbl_new_guide.text = Locale.t("new_guide")
	lbl_name_optional.text = Locale.t("name_optional")
	input_name.placeholder_text = Locale.t("name_placeholder")
	lbl_pos.text = Locale.t("position_px")
	btn_center_pos.text = Locale.t("center_position")
	lbl_orientation.text = Locale.t("orientation")
	btn_horizontal.text = Locale.t("horizontal")
	btn_vertical.text = Locale.t("vertical")
	chk_autosave.text = Locale.t("auto_save")
	btn_create.text = Locale.t("create_guide")
	btn_create_centered.text = Locale.t("create_centered")
	lbl_edit.text = Locale.t("edit_selected")
	lbl_edit_name.text = Locale.t("name_label")
	edit_name.placeholder_text = Locale.t("name_edit_placeholder")
	lbl_edit_pos.text = Locale.t("position_px")
	btn_delete.text = Locale.t("delete")
	btn_apply.text = Locale.t("apply")

func _get_root() -> Node:
	return editor_plugin.get_editor_interface().get_edited_scene_root()

func _get_guides(root: Node) -> Dictionary:
	var result = {"horizontal": [], "vertical": [], "names": {}}
	if not root:
		return result
	if root.has_meta(meta_h):
		result["horizontal"] = root.get_meta(meta_h).duplicate()
	if root.has_meta(meta_v):
		result["vertical"] = root.get_meta(meta_v).duplicate()
	if root.has_meta(meta_names):
		result["names"] = root.get_meta(meta_names).duplicate()
	return result

func _commit_guides(root: Node, new_data: Dictionary, old_data: Dictionary, action_name: String) -> void:
	var undo = editor_plugin.get_undo_redo()
	undo.create_action(action_name)
	undo.add_do_method(self, "_apply_guide_data", root, new_data)
	undo.add_undo_method(self, "_apply_guide_data", root, old_data)
	undo.add_do_method(self, "_refresh_list")
	undo.add_undo_method(self, "_refresh_list")
	undo.commit_action()

func _apply_guide_data(root: Node, data: Dictionary) -> void:
	root.set_meta(meta_h, data["horizontal"])
	root.set_meta(meta_v, data["vertical"])
	root.set_meta(meta_names, data["names"])
	editor_plugin.get_editor_interface().mark_scene_as_unsaved()

func _save_if_needed() -> void:
	if chk_autosave.button_pressed:
		editor_plugin.get_editor_interface().save_scene()

func _refresh_list() -> void:
	guide_list.clear()
	selected_index = -1
	selected_axis = ""
	_update_edit_section(false)

	var root = _get_root()
	if not root:
		lbl_scene.text = Locale.t("scene_label") + " " + Locale.t("no_scene")
		_update_centered_button(null)
		return

	lbl_scene.text = Locale.t("scene_label") + " " + root.name
	var data = _get_guides(root)

	for pos in data["horizontal"]:
		var key = "H:" + str(pos)
		var lbl = data["names"].get(key, "")
		var display = "[H] %s  |  %.0fpx" % [lbl, pos] if lbl != "" else "[H]  %.0fpx" % pos
		guide_list.add_item(display)
		guide_list.set_item_metadata(guide_list.item_count - 1, {"axis": "horizontal", "pos": pos, "key": key})

	for pos in data["vertical"]:
		var key = "V:" + str(pos)
		var lbl = data["names"].get(key, "")
		var display = "[V] %s  |  %.0fpx" % [lbl, pos] if lbl != "" else "[V]  %.0fpx" % pos
		guide_list.add_item(display)
		guide_list.set_item_metadata(guide_list.item_count - 1, {"axis": "vertical", "pos": pos, "key": key})

	_update_centered_button(root)

func _update_centered_button(root: Node) -> void:
	if not root:
		btn_create_centered.visible = true
		return
	var w = float(ProjectSettings.get_setting("display/window/size/viewport_width"))
	var h = float(ProjectSettings.get_setting("display/window/size/viewport_height"))
	var data = _get_guides(root)
	btn_create_centered.visible = not (h / 2.0 in data["horizontal"] and w / 2.0 in data["vertical"])

func _on_item_selected(idx: int) -> void:
	var meta = guide_list.get_item_metadata(idx)
	selected_index = idx
	selected_axis = meta["axis"]
	edit_pos.value = meta["pos"]
	var root = _get_root()
	if root and root.has_meta(meta_names):
		edit_name.text = root.get_meta(meta_names).get(meta["key"], "")
	else:
		edit_name.text = ""
	_update_edit_section(true)

func _update_edit_section(enabled: bool) -> void:
	edit_name.editable = enabled
	edit_pos.editable = enabled
	btn_apply.disabled = not enabled
	btn_delete.disabled = not enabled

func _on_center_input_pos() -> void:
	var w = float(ProjectSettings.get_setting("display/window/size/viewport_width"))
	var h = float(ProjectSettings.get_setting("display/window/size/viewport_height"))
	input_pos.value = h / 2.0 if axis_selected == "horizontal" else w / 2.0

func _on_create_guide() -> void:
	var root = _get_root()
	if not root:
		return
	var old_data = _get_guides(root)
	var new_data = _get_guides(root)
	var pos = input_pos.value
	var name_val = input_name.text.strip_edges()
	var key = ("H:" if axis_selected == "horizontal" else "V:") + str(pos)

	if axis_selected == "horizontal":
		if pos in new_data["horizontal"]:
			return
		new_data["horizontal"].append(pos)
	else:
		if pos in new_data["vertical"]:
			return
		new_data["vertical"].append(pos)

	if name_val != "":
		new_data["names"][key] = name_val

	_commit_guides(root, new_data, old_data, Locale.t("undo_create"))
	input_name.text = ""
	_save_if_needed()

func _on_create_centered_guides() -> void:
	var root = _get_root()
	if not root:
		return
	var w = float(ProjectSettings.get_setting("display/window/size/viewport_width"))
	var h = float(ProjectSettings.get_setting("display/window/size/viewport_height"))
	var old_data = _get_guides(root)
	var new_data = _get_guides(root)

	if not h / 2.0 in new_data["horizontal"]:
		new_data["horizontal"].append(h / 2.0)
	if not w / 2.0 in new_data["vertical"]:
		new_data["vertical"].append(w / 2.0)

	_commit_guides(root, new_data, old_data, Locale.t("undo_create"))
	_save_if_needed()

func _on_delete_guide() -> void:
	if selected_index < 0:
		return
	var root = _get_root()
	if not root:
		return
	var meta = guide_list.get_item_metadata(selected_index)
	var old_data = _get_guides(root)
	var new_data = _get_guides(root)

	if meta["axis"] == "horizontal":
		new_data["horizontal"].erase(meta["pos"])
	else:
		new_data["vertical"].erase(meta["pos"])
	new_data["names"].erase(meta["key"])

	_commit_guides(root, new_data, old_data, Locale.t("undo_delete"))
	_save_if_needed()

func _on_apply_edit() -> void:
	if selected_index < 0:
		return
	var root = _get_root()
	if not root:
		return
	var meta = guide_list.get_item_metadata(selected_index)
	var old_data = _get_guides(root)
	var new_data = _get_guides(root)
	var old_pos = meta["pos"]
	var new_pos = edit_pos.value
	var new_name = edit_name.text.strip_edges()
	var old_key = meta["key"]
	var new_key = ("H:" if meta["axis"] == "horizontal" else "V:") + str(new_pos)

	if meta["axis"] == "horizontal":
		var idx = new_data["horizontal"].find(old_pos)
		if idx >= 0:
			new_data["horizontal"][idx] = new_pos
	else:
		var idx = new_data["vertical"].find(old_pos)
		if idx >= 0:
			new_data["vertical"][idx] = new_pos

	new_data["names"].erase(old_key)
	if new_name != "":
		new_data["names"][new_key] = new_name

	_commit_guides(root, new_data, old_data, Locale.t("undo_edit"))
	_save_if_needed()

func _on_axis_horizontal() -> void:
	_set_axis_visual("horizontal")

func _on_axis_vertical() -> void:
	_set_axis_visual("vertical")

func _set_axis_visual(axis: String) -> void:
	axis_selected = axis
	btn_horizontal.button_pressed = axis == "horizontal"
	btn_vertical.button_pressed = axis == "vertical"
