# Guideline Manager
<br>
<div align="center">
 <img src="Guideline Manager.webp" width="1080">
 </div>
 <br>
A simple Dock editor for creating and managing viewport guide lines in Godot.

**Compatible** with Godot **4.5+** — tested on **4.7**


---

### Installation
 
 1. Copy the **"guideline_manager"** folder into "addons" in your project.
 2. Go to Project > Project Settings > Plugins.
 3. Activate "Guide Manager".
 4. Appears as a "Guide Manager" tab in the editor's bottom panel

(next to Output, Debugger, Animation, etc.).

5. Expandable with Shift+F12 like any native bottom dock.

---

### Usage

- **Guide List (Left Column)**
Displays all guides in the active scene with the prefix [H] or [V],
name (if any), and pixel position.

When changing scenes or opening a new one, click Reload in Guideline Manager to view the guides for the current scene.

---

## Create Guide (Right Column, Top Section)

1. Enter an optional name.

 2. Enter the position in pixels, or use "Center Position" to automatically calculate the viewport center based on the chosen axis (this does not create the guide, it only fills the position field).

3. Select Horizontal or Vertical.

4. Enable "Save Scene on Creation" if you want it to be saved automatically.

5. Press "Create Guide".

---

## Create Centered Guides

The "Create Guides Centered to Viewport" button creates a horizontal guide and a vertical guide at the exact center of the viewport.
It is automatically hidden if both centered guides already exist.

---

## Edit Guide

1. Select a guide from the list.

2. Modify the name and/or position in the lower right section.

3. Press "Apply Changes".

---

## Delete Guide

1. Select a guide from the list.

 2. Press "Delete Selected Guide".

## Undo / Redo

All operations (create, edit, delete) are compatible with the Godot editor's Ctrl+Z / Ctrl+Y keys.

---

### Language

The plugin automatically detects the editor's language:
- If the editor is in Spanish (es, es_ES, etc.), it displays the UI in Spanish.

- Any other language displays the UI in English.

Configure in Editor > Editor Settings > Interface > Editor > Editor Language.

---

### Technical Notes

- Names are stored in the root node's metadata: `_edit_guide_names_`
- Guides use the same native Godot metadata:

```_edit_horizontal_guides_``` / ```_edit_vertical_guides_```
