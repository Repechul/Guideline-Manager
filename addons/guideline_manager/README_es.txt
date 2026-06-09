Guideline Manager - Plugin para Godot 4.x
======================================
INSTALACIÓN
-----------
1. Copia la carpeta "guideline_manager" dentro de "addons" en tu proyecto:
     res://addons/guideline_manager/plugin.cfg
     res://addons/guideline_manager/plugin.gd
     res://addons/guideline_manager/gm_locale.gd
     res://addons/guideline_manager/guideline_manager_panel.gd
     res://addons/guideline_manager/guideline_manager_panel.tscn

2. Ve a Project > Project Settings > Plugins.
3. Activa "Guide Manager".
4. Aparece como pestana "Guide Manager" en el panel inferior del editor
   (junto a Output, Depurador, Animacion, etc).
5. Expandible con Shift+F12 como cualquier dock inferior nativo.


IDIOMA
------
El plugin detecta automaticamente el idioma del editor:
- Si el editor esta en espanol (es, es_ES, etc.) muestra la UI en espanol.
- Cualquier otro idioma muestra la UI en ingles.
Se configura en Editor > Editor Settings > Interface > Editor > Editor Language.


USO
---
LISTA DE GUIAS (columna izquierda)
  Muestra todas las guias de la escena activa con prefijo [H] o [V],
  nombre (si tiene) y posicion en pixeles.
  Se actualiza automaticamente al cambiar de escena.
  Incluye scroll para listas largas.

CREAR GUIA (columna derecha, seccion superior)
  1. Escribe un nombre opcional.
  2. Ingresa la posicion en pixeles, o usa "Centrar posicion" para
     calcular automaticamente el centro del viewport segun el eje elegido
     (no crea la guia, solo rellena el campo de posicion).
  3. Selecciona Horizontal o Vertical.
  4. Activa "Guardar escena al crear" si quieres que se guarde automaticamente.
  5. Presiona "Crear guia".

CREAR GUIAS CENTRADAS
  El boton "Crear guias centradas al viewport" crea una guia horizontal
  y una vertical en el centro exacto del viewport.
  Se oculta automaticamente si ya existen ambas guias centradas.

EDITAR GUIA
  1. Selecciona una guia de la lista.
  2. Modifica nombre y/o posicion en la seccion inferior derecha.
  3. Presiona "Aplicar cambios".

ELIMINAR GUIA
  1. Selecciona una guia de la lista.
  2. Presiona "Eliminar guia seleccionada".

DESHACER / REHACER
  Todas las operaciones (crear, editar, eliminar) son compatibles con
  Ctrl+Z / Ctrl+Y del editor de Godot.


NOTAS TECNICAS
--------------
- Los nombres se guardan en metadatos del nodo raiz: _edit_guide_names_
- Las guias usan los mismos metadatos nativos de Godot:
    _edit_horizontal_guides_  /  _edit_vertical_guides_
- Compatible con Godot 4.x
