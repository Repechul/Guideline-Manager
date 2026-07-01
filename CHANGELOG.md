# Changelog

## Guideline Manager

### Fixed
- The bottom dock now shows its own icon (`icon.svg`) next to the tab title. It is assigned directly to the `Button` returned by `add_control_to_bottom_panel()`, since `_get_plugin_icon()` only affects main-screen plugins and had no effect here. The now-unused `_get_plugin_icon()` override was removed.
- The panel content now refreshes automatically when the edited scene changes, using the `EditorPlugin.scene_changed` signal. The previous approach (listening to `child_entered_tree` on the main screen container) did not reliably fire on scene switches and was removed.
- The dock no longer forces itself open across every main screen (2D, 3D, Script, Game). It now opens automatically only the first time the editor enters the 2D or 3D screen, and closes itself automatically when switching to Script, Game, or any other main screen (only if it was the currently active bottom panel, so it never closes an unrelated panel like Output or Debugger).
