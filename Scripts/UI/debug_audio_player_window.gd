extends Control
class_name DebugAudioPlayerWindow


class NumericSlider:
	var spin_box: SpinBox
	var slider: Slider
	var is_sliding: bool
	
	func _init(spin_box: SpinBox, slider: Slider) -> void:
		self.spin_box = spin_box
		self.slider = slider
		
		slider.drag_started.connect(func(): is_sliding = true)
		slider.drag_ended.connect(func(value_changed: bool): is_sliding = false)
		
		slider.value = inverse_lerp(spin_box.min_value, spin_box.max_value, spin_box.value)
		
		spin_box.value_changed.connect(func(value: float):
			if !is_sliding:
				slider.value = inverse_lerp(spin_box.min_value, spin_box.max_value, value)
		)
		
		slider.value_changed.connect(func(value: float):
			if is_sliding:
				spin_box.value = lerp(spin_box.min_value, spin_box.max_value, value)
		)

const IMPORT_STR_LENGTH: int = 7
const NO_AUDIO_STREAM_INDEX: int = 0

var current_audio_player: AudioStreamPlayer
var is_changing_audio_player_vars: bool
var custom_audio_stream_indicator_index: int = -1

@onready var audio_players: Array[AudioStreamPlayer]
var cached_audios: Array[int] = [0, 0, 0]
var default_streams: Array[String] = ["", "", ""]
var default_volumes: Array[float] = [0, 0, 0]
var default_pitches: Array[float] = [0, 0, 0]
var default_mix_targets: Array[AudioStreamPlayer.MixTarget] = [0, 0, 0]

@onready var stream_option_button: OptionButton = $VBoxContainer/Stream/Stream_OptionButton
var volume_numeric_slider: NumericSlider
var pitch_numeric_slider: NumericSlider


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	audio_players = [AudioManager.get_node("BGMPlayer"),
					 AudioManager.get_node("BGSPlayer"),
					 $SEAudioStreamPlayer
					]
	
	add_files_to_stream_options_button("res://", true)
	
	volume_numeric_slider = NumericSlider.new($VBoxContainer/Volume/Volume_SpinBox, $VBoxContainer/Volume/Volume_Slider)
	pitch_numeric_slider = NumericSlider.new($VBoxContainer/Pitch/Pitch_SpinBox, $VBoxContainer/Pitch/Pitch_Slider)
	
	volume_numeric_slider.spin_box.value_changed.connect(func(value: float): current_audio_player.volume_db = value)
	pitch_numeric_slider.spin_box.value_changed.connect(func(value: float): current_audio_player.pitch_scale = value)

	# Conecta um sinal one shot, pois a conexão de sinais para os audio triggers
	# serão feitos manualmente da primeira vez já que a cena carregará antes de
	# ir para a cena raiz (SceneManager.scene_root) pelo SceneManager
	SceneManager.scene_root.child_entered_tree.connect(func(node):
		SceneManager.scene_root.child_entered_tree.connect(on_scene_root_child_entered_tree)
	, ConnectFlags.CONNECT_ONE_SHOT)
	
	# Conecta os sinais ao último nó da raiz, pois ainda não deu tempo deles
	# serem transferidos para a SceneManager.scene_root pelo SceneManager
	start_connect_trigger_signal_to_audio_triggers(get_tree().get_root().get_child(get_tree().get_root().get_child_count() - 1))
	
	current_audio_player = audio_players[$VBoxContainer/Header/TabBar.current_tab]

func add_files_to_stream_options_button(directory: String, first_path: bool = false):
	for dir_file in DirAccess.get_files_at(directory):
		if dir_file.ends_with(".ogg.import") || \
		   dir_file.ends_with(".wav.import") || \
		   dir_file.ends_with(".mp3.import"):
			stream_option_button.add_item(directory + "/" + dir_file.left(dir_file.length() - IMPORT_STR_LENGTH))
	for dir_dir in DirAccess.get_directories_at(directory):
		if first_path:
			add_files_to_stream_options_button(directory + dir_dir)
		else:
			add_files_to_stream_options_button(directory + "/" + dir_dir)

func refresh_fields() -> void:
	stream_option_button.select(cached_audios[$VBoxContainer/Header/TabBar.current_tab])
	volume_numeric_slider.spin_box.value = current_audio_player.volume_db
	pitch_numeric_slider.spin_box.value = current_audio_player.pitch_scale
	$VBoxContainer/MixTarget/MixTarget_OptionButton.select(current_audio_player.mix_target)

func get_stream_option_button_index(audio_path: String) -> int:
	for i in stream_option_button.item_count:
		if stream_option_button.get_item_text(i) == audio_path:
			return i
	return NO_AUDIO_STREAM_INDEX

func start_connect_trigger_signal_to_audio_triggers(node: Node) -> void:
	if node is AudioTrigger:
		node.triggered_audio.connect(on_audio_trigger_triggered)
	connect_trigger_signal_to_audio_triggers_recursively(node)

func connect_trigger_signal_to_audio_triggers_recursively(from_node: Node) -> void:
	for child in from_node.get_children():
		if child is AudioTrigger:
			child.triggered_audio.connect(on_audio_trigger_triggered)
		connect_trigger_signal_to_audio_triggers_recursively(child)

func play_audio_if_was_playing(path: String) -> void:
	var was_playing: bool = current_audio_player.playing
	if path.begins_with("res://"):
		current_audio_player.stream = load(path)
	elif path.ends_with(".mp3"):
		current_audio_player.stream = AudioStreamMP3.load_from_file(path)
	elif path.ends_with(".ogg"):
		current_audio_player.stream = AudioStreamOggVorbis.load_from_file(path)
	elif path.ends_with(".wav"):
		current_audio_player.stream = AudioStreamWAV.load_from_file(path)
	current_audio_player.playing = was_playing


func on_scene_root_child_entered_tree(node: Node) -> void:
	start_connect_trigger_signal_to_audio_triggers(node)

func on_audio_trigger_triggered(audio_player_type: AudioTrigger.AudioPlayerType) -> void:
	default_streams[audio_player_type] = audio_players[audio_player_type].stream.resource_path
	default_volumes[audio_player_type] = audio_players[audio_player_type].volume_db
	default_pitches[audio_player_type] = audio_players[audio_player_type].pitch_scale
	default_mix_targets[audio_player_type] = audio_players[audio_player_type].mix_target
	
	cached_audios[audio_player_type] = get_stream_option_button_index(default_streams[audio_player_type])

	refresh_fields()

func _on_tab_bar_tab_changed(tab: int) -> void:
	current_audio_player = audio_players[tab]
	refresh_fields()

func _on_stream_option_button_item_selected(index: int) -> void:
	if  index > NO_AUDIO_STREAM_INDEX:
		if custom_audio_stream_indicator_index == -1 || index != custom_audio_stream_indicator_index:
			var sound_path: String = stream_option_button.get_item_text(index)
			play_audio_if_was_playing(sound_path)
			cached_audios[$VBoxContainer/Header/TabBar.current_tab] = index
	else:
		cached_audios[$VBoxContainer/Header/TabBar.current_tab] = index

func _on_stream_file_file_dialog_file_selected(path: String) -> void:
	if custom_audio_stream_indicator_index == -1:
		stream_option_button.add_item("--- Externos ---")
		custom_audio_stream_indicator_index = stream_option_button.item_count - 1
	stream_option_button.add_item(path)
	stream_option_button.select(stream_option_button.item_count - 1)
	cached_audios[$VBoxContainer/Header/TabBar.current_tab] = stream_option_button.item_count - 1
	play_audio_if_was_playing(path)

func _on_mix_target_option_button_item_selected(index: int) -> void:
	current_audio_player.mix_target = index

func _on_play_button_pressed() -> void:
	current_audio_player.play()

func _on_stop_button_pressed() -> void:
	current_audio_player.stop()

func _on_default_button_pressed() -> void:
	var current_tab: int = $VBoxContainer/Header/TabBar.current_tab
	
	cached_audios[current_tab] = get_stream_option_button_index(default_streams[current_tab])
	current_audio_player.volume_db = default_volumes[current_tab]
	current_audio_player.pitch_scale = default_pitches[current_tab]
	current_audio_player.mix_target = default_mix_targets[current_tab]
	play_audio_if_was_playing(default_streams[current_tab])
	
	refresh_fields()

func _on_stream_file_button_pressed() -> void:
	$StreamFile_FileDialog.popup_file_dialog()

func _on_close_written_button_pressed() -> void:
	hide()

func _on_close_button_pressed() -> void:
	hide()
