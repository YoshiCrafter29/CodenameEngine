package funkin.cutscenes;

#if VIDEO_CUTSCENES
import vlc.bitmap.VlcBitmap;
import flixel.util.FlxTimer;
import funkin.options.PlayerSettings;
import openfl.events.Event;
import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;

class MP4Handler
{
	public var finishCallback:Void->Void;
	public var stateCallback:FlxState;

	public var bitmap:VlcBitmap;

	public var sprite:FlxSprite;
	public var canvasWidth:Null<Int> = null;
	public var canvasHeight:Null<Int> = null;
	public var fillScreen:Bool;
	public var skippable:Bool = true;

	public function new()
	{
		// FlxG.autoPause = false;
	}

	public function playMP4(path:String, ?repeat:Bool = false, ?outputTo:FlxSprite = null, ?isWindow:Bool = false, ?isFullscreen:Bool = false,
			?midSong:Bool = false):Void
	{
		if (!midSong)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.stop();
			}
		}

		bitmap = new VlcBitmap();

		if (FlxG.stage.stageHeight / 9 < FlxG.stage.stageWidth / 16)
		{
			bitmap.set_width(FlxG.stage.stageHeight * (16 / 9));
			bitmap.set_height(FlxG.stage.stageHeight);
		}
		else
		{
			bitmap.set_width(FlxG.stage.stageWidth);
			bitmap.set_height(FlxG.stage.stageWidth / (16 / 9));
		}

		bitmap.onVideoReady = onVLCVideoReady;
		bitmap.onComplete = onVLCComplete;
		bitmap.onError = onVLCError;

		FlxG.stage.addEventListener(Event.ENTER_FRAME, update);

		if (repeat)
			bitmap.repeat = -1;
		else
			bitmap.repeat = 0;

		// bitmap.inWindow = isWindow;
		// bitmap.fullscreen = isFullscreen;

		FlxG.addChildBelowMouse(bitmap);
		bitmap.play(checkFile(path));

		if (outputTo != null)
		{
			// lol this is bad kek
			bitmap.alpha = 0;

			sprite = outputTo;
		}
	}

	function checkFile(fileName:String):String
	{
		var pDir = "";
		var appDir = "file:///" + Sys.getCwd() + "/";

		if (fileName.indexOf(":") == -1) // Not a path
			pDir = appDir;
		else if (fileName.indexOf("file://") == -1 || fileName.indexOf("http") == -1) // C:, D: etc? ..missing "file:///" ?
			pDir = "file:///";

		return pDir + fileName;
	}

	/////////////////////////////////////////////////////////////////////////////////////

	function onVLCVideoReady()
	{
		trace("video loaded!");

		if (sprite != null)
		{
			sprite.loadGraphic(bitmap.bitmapData);
			if (canvasWidth != null && canvasHeight != null)
			{
				sprite.setGraphicSize(canvasWidth, canvasHeight);
				sprite.updateHitbox();

				var r = (fillScreen ? Math.max : Math.min)(sprite.scale.x, sprite.scale.y);
				sprite.scale.set(r, r); // lol
			}
		}
	}

	public function onVLCComplete()
	{
		bitmap.stop();

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			if (finishCallback != null)
			{
				finishCallback();
			}
			else if (stateCallback != null)
			{
				FlxG.switchState(stateCallback);
			}

			bitmap.dispose();

			if (FlxG.game.contains(bitmap))
			{
				FlxG.game.removeChild(bitmap);
			}
		});
	}

	public function kill()
	{
		bitmap.stop();

		if (finishCallback != null)
		{
			finishCallback();
		}

		bitmap.visible = false;
	}

	function onVLCError()
	{
		if (finishCallback != null)
		{
			finishCallback();
		}
		else if (stateCallback != null)
		{
			FlxG.switchState(stateCallback);
		}
	}

	function update(e:Event)
	{
		if (PlayerSettings.player1.controls.ACCEPT && skippable)
		{
			if (bitmap.isPlaying)
			{
				onVLCComplete();
			}
		}

		bitmap.volume = FlxG.sound.volume + 0.3; // shitty volume fix. then make it louder.

		if (FlxG.sound.volume <= 0.1 || FlxG.sound.muted)
			bitmap.volume = 0;
	}
}
#end
