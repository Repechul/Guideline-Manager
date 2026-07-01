@tool
extends RefCounted

const strings_lang = {
	"en": {
		"panel_title": "Guideline Manager",
		"scene_label": "Scene:",
		"no_scene": "No active scene",
		"reload": "Reload",
		"new_guide": "New guide",
		"name_optional": "Name (optional)",
		"name_placeholder": "E.g.: Center horizontal",
		"position_px": "Position (px)",
		"orientation": "Orientation",
		"horizontal": "Horizontal",
		"vertical": "Vertical",
		"center_position": "Center position",
		"auto_save": "Auto-save on create",
		"create_guide": "Create guide",
		"create_centered": "Create centered guides",
		"edit_selected": "Edit selected guide",
		"name_label": "Name",
		"name_edit_placeholder": "Guide name",
		"delete": "Delete selected guide",
		"apply": "Apply changes",
		"undo_create": "Create guide",
		"undo_delete": "Delete guide",
		"undo_edit": "Edit guide",
	},
	"es": {
		"panel_title": "Guideline Manager",
		"scene_label": "Escena:",
		"no_scene": "Sin escena activa",
		"reload": "Recargar",
		"new_guide": "Nueva guia",
		"name_optional": "Nombre (opcional)",
		"name_placeholder": "Ej: Centro horizontal",
		"position_px": "Posicion (px)",
		"orientation": "Orientacion",
		"horizontal": "Horizontal",
		"vertical": "Vertical",
		"center_position": "Centrar posicion",
		"auto_save": "Guardar escena al crear",
		"create_guide": "Crear guia",
		"create_centered": "Crear guias centradas al viewport",
		"edit_selected": "Editar guia seleccionada",
		"name_label": "Nombre",
		"name_edit_placeholder": "Nombre de la guia",
		"delete": "Eliminar guia seleccionada",
		"apply": "Aplicar cambios",
		"undo_create": "Crear guia",
		"undo_delete": "Eliminar guia",
		"undo_edit": "Editar guia",
	}
}

static func get_lang() -> String:
	var lang = EditorInterface.get_editor_settings().get_setting("interface/editor/editor_language")
	if str(lang).begins_with("es"):
		return "es"
	return "en"

static func t(key: String) -> String:
	var lang = get_lang()
	return strings_lang[lang].get(key, strings_lang["en"].get(key, key))
