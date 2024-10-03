package kec.substates;

import flixel.FlxCamera;
import flixel.input.actions.FlxActionInput;
import flixel.util.FlxDestroyUtil;
import kec.backend.Controls;
import kec.backend.PlayerSettings;
import kec.backend.chart.TimingStruct;
import mobile.kec.objects.TouchPad;

class MusicBeatSubstate extends FlxSubState
{
	public static var instance:MusicBeatSubstate;

	public function new()
	{
		instance = this;
		super();
	}

	override function destroy()
	{
		/*Application.current.window.onFocusIn.remove(onWindowFocusOut);
			Application.current.window.onFocusIn.remove(onWindowFocusIn); */

		removeTouchPad();

		super.destroy();
	}

	override function create()
	{
		FlxG.mouse.enabled = true;
		super.create();
		/*Application.current.window.onFocusIn.add(onWindowFocusIn);
			Application.current.window.onFocusOut.add(onWindowFocusOut); */
	}

	private var curStep:Int = 0;
	private var curBeat:Int = 0;
	private var controls(get, never):Controls;

	inline function get_controls():Controls
		return PlayerSettings.player1.controls;

	public var touchPad:TouchPad;
	public var mobileControls:MobileControls;

	public var touchPadCamera:FlxCamera;
	public var mobileControlsCamera:FlxCamera;

	public function addTouchPad(dpadMode:String, actionMode:String):TouchPad
	{
		if (touchPad != null)
			removeTouchPad();

		touchPad = new TouchPad(dpadMode, actionMode);
		add(touchPad);

		return touchPad;
	}

	public function removeTouchPad():Void
	{
		removeTouchPadCamera();

		if (touchPad != null)
		{
			remove(touchPad);
			touchPad = FlxDestroyUtil.destroy(touchPad);
		}
	}

	public function addTouchPadCamera():Void
	{
		if (touchPad == null)
			return;

		touchPadCamera = new FlxCamera();
		FlxG.cameras.add(touchPadCamera, false);
		touchPadCamera.bgColor.alpha = 0;
		touchPad.cameras = [touchPadCamera];
	}

	public function removeTouchPadCamera():Void
	{
		if (touchPadCamera == null)
			return;

		if (touchPad != null)
			touchPad.cameras = [FlxG.camera];

		FlxG.cameras.remove(touchPadCamera);
		touchPadCamera = FlxDestroyUtil.destroy(touchPadCamera);
	}

	var oldStep:Int = 0;

	var curDecimalBeat:Float = 0;

	override function update(elapsed:Float)
	{
		curDecimalBeat = (((Conductor.songPosition / 1000))) * (Conductor.bpm / 60);
		curBeat = Math.floor(curDecimalBeat);
		curStep = Math.floor(curDecimalBeat * 4);

		if (oldStep != curStep)
		{
			stepHit();
			oldStep = curStep;
		}

		super.update(elapsed);

		var fullscreenBind = FlxKey.fromString(FlxG.save.data.fullscreenBind);

		if (FlxG.keys.anyJustPressed([fullscreenBind]))
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}
	}

	public function stepHit():Void
	{
		if (curStep % 4 == 0)
			beatHit();
	}

	public function beatHit():Void
	{
		// do literally nothing dumbass
	}
}
