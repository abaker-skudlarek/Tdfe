extends VBoxContainer

signal file_chosen(file_path: String)
@onready var option_button: OptionButton = $FileBrowser/OptionButton


func get_files_in_dir(dir_path: String) -> Array:
	var dir := DirAccess.open(dir_path)
	var files_found := []
	if dir:
		dir.list_dir_begin()
		var file_name := dir.get_next()
		while file_name != "":
			if !dir.current_is_dir() and file_name.get_extension() == "yaml":
				files_found.append(file_name)
			file_name = dir.get_next()
	else:
		printerr("An error ocurred when trying to acces the path " + dir_path)

	return files_found


func _on_browse_button_pressed() -> void:
	$FolderBrowserWindow.visible = true


func _on_folder_browser_window_dir_selected(dir: String) -> void:
	$FolderBrowser/LineEdit.text = dir
	var files: Array = get_files_in_dir(dir)
	if option_button.has_selectable_items():
		option_button.clear()
	option_button.add_item("")
	for file: String in files:
		option_button.add_item(file)


func _on_option_button_item_selected(index:int) -> void:
	var file_path: String = $FolderBrowser/LineEdit.text + "/" + option_button.get_item_text(index)
	file_chosen.emit(file_path)