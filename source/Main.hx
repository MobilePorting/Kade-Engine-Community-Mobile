package;

import flixel.graphics.FlxGraphic;
import flixel.FlxGame;
import openfl.Assets;
import openfl.display.DisplayObject;
import openfl.display.Bitmap;
import haxe.ui.Toolkit;
import kec.objects.KadeEngineFPS;
#if FEATURE_DISCORD
import kec.backend.Discord;
#end
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;
import lime.app.Application;
#if VIDEOS
import hxvlc.util.Handle;
#end
import openfl.utils.AssetCache;

using StringTools;

class Main extends Sprite
{
	var game = {
		width: 1280, // WINDOW width
		height: 720, // WINDOW height
		initialState: Init, // initial game state
		zoom: -1.0, // game state bounds
		framerate: 60, // default framerate
		skipSplash: true, // if the default flixel splash screen should be skipped
		startFullscreen: false // if the game should start at fullscreen mode
	};

	public static var mainClassState:Class<FlxState> = Init; // yoshubs jumpscare (I am aware of *the incident*)
	public static var gameContainer:Main = null; // Main instance to access when needed.
	public static var bitmapFPS:Bitmap;
	public static var focusMusicTween:FlxTween;
	public static var focused:Bool = true;

	public var hasWifi:Bool = true;

	var oldVol:Float = 1.0;
	var newVol:Float = 0.3;

	public static var watermarks = true; // Whether to put Kade Engine literally anywhere

	// You can pretty much ignore everything from here on - your code should go in your states.
	private var curGame:FlxGame;

	public static function main():Void
	{
		// quick checks

		Lib.current.addChild(new Main());
	}

	public function new()
	{
		super();

		#if mobile
		#if android
		SUtil.doPermissionsShit();
		#end
		Sys.setCwd(SUtil.getStorageDirectory());
		#end

		mobile.kec.backend.CrashHandler.init();

		#if windows
		@:functionCode("
		#include <windows.h>
		#include <winuser.h>
		setProcessDPIAware() // allows for more crisp visuals
		DisableProcessWindowsGhosting() // lets you move the window and such if it's not responding
		")
		#end

		if (stage != null)
		{
			init();
		}
		else
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}

		setupGame();
	}

	private function setupGame():Void
	{
		#if !mobile
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		if (game.zoom == -1.0)
		{
			var ratioX:Float = stageWidth / game.width;
			var ratioY:Float = stageHeight / game.height;
			game.zoom = Math.min(ratioX, ratioY);
			game.width = Math.ceil(stageWidth / game.zoom);
			game.height = Math.ceil(stageHeight / game.zoom);
		}
		#end

		gameContainer = this;

		initHaxeUI();

		// Run this first so we can see logs.
		kec.backend.Debug.onInitProgram();

		fpsCounter = new KadeEngineFPS(10, 3, 0xFFFFFF);
		bitmapFPS = kec.backend.ImageOutline.renderImage(fpsCounter, 1, 0x000000, true);
		bitmapFPS.smoothing = true;

		game.framerate = 60;
		curGame = new Game(game.width, game.height, game.initialState, game.framerate, game.skipSplash, game.startFullscreen);

		@:privateAccess
		curGame._customSoundTray = flixel.FunkinSoundTray;
		addChild(curGame);

		FlxG.fixedTimestep = false;

		addChild(fpsCounter);
		toggleFPS(FlxG.save.data.fps);

		#if html5
		FlxG.autoPause = false;
		FlxG.mouse.visible = false;
		#end

		#if android FlxG.android.preventDefaultKeys = [BACK]; #end

		FlxG.signals.gameResized.add(function(w, h)
			if (fpsCounter != null)
				fpsCounter.positionFPS(10, 3, Math.min(w / FlxG.width, h / FlxG.height)));

		#if VIDEOS
		Handle.initAsync();
		#end

		// Finish up loading debug tools.
		Debug.onGameStart();
		Application.current.window.onFocusOut.add(onWindowFocusOut);
		Application.current.window.onFocusIn.add(onWindowFocusIn);

		MobileData.init();
	}

	public function checkInternetConnection()
	{
		Debug.logInfo('Checking Internet connection Through URL: "https://www.example.com".');
		var http = new haxe.Http("https://www.example.com");
		http.onStatus = function(status:Int)
		{
			switch status
			{
				case 200: // success
					hasWifi = true;
					Debug.logInfo('Connected.');
				default: // error
					hasWifi = false;
					Debug.logInfo('No Internet Connection.');
			}
		};

		http.onError = function(e)
		{
			hasWifi = false;
			Debug.logInfo('No Internet Connection.');
		}

		http.request();
	}

	function onWindowFocusOut()
	{
		focused = false;

		// Lower global volume when unfocused
		oldVol = FlxG.sound.volume;
		if (oldVol > 0.3)
			newVol = 0.3;
		else
		{
			if (oldVol > 0.1)
				newVol = 0.1;
			else
				newVol = 0;
		}

		if (focusMusicTween != null)
			focusMusicTween.cancel();
		focusMusicTween = FlxTween.tween(FlxG.sound, {volume: newVol}, 0.5);

		// Conserve power by lowering draw framerate when unfocuced
		// was 30 but it might cause bugs
		FlxG.drawFramerate = 60;
	}

	function onWindowFocusIn()
	{
		FlxTimer.wait(0.2, function()
		{
			focused = true;
		});

		// Lower global volume when unfocused
		// Normal global volume when focused
		if (focusMusicTween != null)
			focusMusicTween.cancel();

		focusMusicTween = FlxTween.tween(FlxG.sound, {volume: oldVol}, 0.5);

		// Bring framerate back when focused
		FlxG.drawFramerate = FlxG.save.data.fpsCap;
		gameContainer.setFPSCap(FlxG.save.data.fpsCap);
	}

	var fpsCounter:KadeEngineFPS;

	public function toggleFPS(fpsEnabled:Bool):Void
	{
		fpsCounter.visible = fpsEnabled;
	}

	public function changeFPSColor(color:FlxColor)
	{
		fpsCounter.textColor = color;
	}

	public function setFPSCap(cap:Int)
	{
		FlxG.updateFramerate = cap;
		FlxG.drawFramerate = FlxG.updateFramerate;
	}

	public function getFPSCap():Float
	{
		return openfl.Lib.current.stage.frameRate;
	}

	public function getFPS():Float
	{
		return fpsCounter.currentFPS;
	}

	function initHaxeUI():Void
	{
		Toolkit.init();
		Toolkit.theme = 'dark'; // don't be cringe
		Toolkit.autoScale = false;
	}

	// Get rid of hit test function because mouse memory ramp up during first move (-Bolo)
	@:noCompletion private override function __hitTest(x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool,
			hitObject:DisplayObject):Bool
		return true;

	@:noCompletion override private function __hitTestHitArea(x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool,
			hitObject:DisplayObject):Bool
		return true;

	@:noCompletion private override function __hitTestMask(x:Float, y:Float):Bool
		return true;
}
