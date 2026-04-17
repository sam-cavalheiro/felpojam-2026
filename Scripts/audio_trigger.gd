extends InGameTrigger
class_name AudioTrigger

enum AudioPlayerType { BGM, BGS }

signal triggered_audio(audio_player_type: AudioPlayerType)


@export var audio_player_type: AudioPlayerType = AudioPlayerType.BGM
@export var stream: AudioStream
@export_range(0.0, 4096.0, 0.1, "or_greater", "suffix:s") var play_start_position: float = 0.0
@export_range(-80, 24, 1.0, "suffix:dB") var volume_db: float = 0.0
@export_range(0.01, 4.0, 0.1, "or_greater") var pitch_scale: float = 1.0
@export var mix_target: = AudioStreamPlayer.MixTarget.MIX_TARGET_STEREO
@export var max_polyphony: int = 1
@export var bus: StringName = &"Master"
@export var playback_type: = AudioServer.PlaybackType.PLAYBACK_TYPE_DEFAULT


func on_trigger() -> void:
	var audio_player_path: = "BGMPlayer" if audio_player_type == AudioPlayerType.BGM else "BGSPlayer"
	var audio_player: AudioStreamPlayer = AudioManager.get_node(audio_player_path)
	audio_player.volume_db = volume_db
	audio_player.pitch_scale = pitch_scale
	audio_player.mix_target = mix_target
	audio_player.max_polyphony = max_polyphony
	
	if audio_player.stream != stream || !audio_player.playing:
		audio_player.stream = stream
		audio_player.play(play_start_position)
	
	triggered_audio.emit(audio_player_type)
