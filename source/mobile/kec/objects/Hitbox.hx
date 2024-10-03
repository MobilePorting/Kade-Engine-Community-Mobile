package mobile.kec.objects;

import flixel.FlxG;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.tweens.*;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSignal;
import mobile.kec.input.MobileButtonsList;
import openfl.display.BitmapData;
import openfl.display.Shape;

/**
 * A zone with 4 hint's (A hitbox).
 * It's really easy to customize the layout.
 *
 * @author: Mihai Alexandru and Karim Akra
 */
class Hitbox extends FlxTypedSpriteGroup<TouchButton> implements MobileControls
{
	public var buttonLeft:TouchButton = new TouchButton(0, 0);
	public var buttonDown:TouchButton = new TouchButton(0, 0);
	public var buttonUp:TouchButton = new TouchButton(0, 0);
	public var buttonRight:TouchButton = new TouchButton(0, 0);

	public var instance:FlxTypedSpriteGroup<TouchButton>;
	public var onButtonDown:FlxTypedSignal<TouchButton->Void> = new FlxTypedSignal<TouchButton->Void>();
	public var onButtonUp:FlxTypedSignal<TouchButton->Void> = new FlxTypedSignal<TouchButton->Void>();

	/**
	 * Create the zone.
	 */
	public function new()
	{
		super();

		add(buttonLeft = createHint(0, 0, Std.int(FlxG.width / 4), FlxG.height, 0xFFC24B99, [HITBOX_LEFT]));
		add(buttonDown = createHint(FlxG.width / 4, 0, Std.int(FlxG.width / 4), FlxG.height, 0xFF00FFFF, [HITBOX_DOWN]));
		add(buttonUp = createHint(FlxG.width / 2, 0, Std.int(FlxG.width / 4), FlxG.height, 0xFF12FA05, [HITBOX_UP]));
		add(buttonRight = createHint((FlxG.width / 2) + (FlxG.width / 4), 0, Std.int(FlxG.width / 4), FlxG.height, 0xFFF9393F, [HITBOX_RIGHT]));

		scrollFactor.set();
		instance = this;
	}

	public function buttonJustPressed(id:MobileButtonsList):Bool
	{
		if (id == null)
			return false;

		var button:TouchButton = null;

		for (member in members)
		{
			if (member.id.contains(id))
			{
				button = member;
				break;
			}
			else
				continue;
		}

		if (button == null)
			return false;

		return button.justPressed;
	}

	public function buttonPressed(id:MobileButtonsList):Bool
	{
		if (id == null)
			return false;

		var button:TouchButton = null;

		for (member in members)
		{
			if (member.id.contains(id))
			{
				button = member;
				break;
			}
			else
				continue;
		}

		if (button == null)
			return false;

		return button.pressed;
	}

	public function buttonJustReleased(id:MobileButtonsList):Bool
	{
		if (id == null)
			return false;

		var button:TouchButton = null;

		for (member in members)
		{
			if (member.id.contains(id))
			{
				button = member;
				break;
			}
			else
				continue;
		}

		if (button == null)
			return false;

		return button.justReleased;
	}

	/**
	 * Clean up memory.
	 */
	override function destroy()
	{
		super.destroy();

		for (field in Reflect.fields(this))
			if (Std.isOfType(Reflect.field(this, field), TouchButton))
				Reflect.setField(this, field, FlxDestroyUtil.destroy(Reflect.field(this, field)));

		onButtonDown.removeAll();
		onButtonUp.removeAll();
		onButtonDown = onButtonDown = null;
	}

	private function createHint(X:Float, Y:Float, Width:Int, Height:Int, Color:Int = 0xFFFFFF, ?id:Array<MobileButtonsList>):TouchButton
	{
		var hint:TouchButton = getButtonInstance(X, Y, Width, Height);
		hint.color = Color;
		hint.id = id;
		#if FLX_DEBUG
		hint.ignoreDrawDebug = true;
		#end
		return hint;
	}

	private function getButtonInstance(x:Float = 0, y:Float = 0, ?width:Int, ?height:Int):TouchButton
	{
		var button:TouchButton = new TouchButton(x, y);
		if (width == null || height == null)
			return button;

		button.loadGraphic(createHintGraphic(width, height));

		if (FlxG.save.data.hitboxType != "Hidden")
		{
			var hintTween:FlxTween = null;
			button.onDown.callback = function()
			{
				onButtonDown.dispatch(button);
				if (hintTween != null)
					hintTween.cancel();

				hintTween = FlxTween.tween(button, {alpha: FlxG.save.data.mobileCAlpha}, FlxG.save.data.mobileCAlpha / 100, {
					ease: FlxEase.circInOut,
					onComplete: function(twn:FlxTween)
					{
						hintTween = null;
					}
				});
			}
			button.onOut.callback = button.onUp.callback = function()
			{
				onButtonUp.dispatch(button);
				if (hintTween != null)
					hintTween.cancel();

				hintTween = FlxTween.tween(button, {alpha: 0.00001}, FlxG.save.data.mobileCAlpha / 10, {
					ease: FlxEase.circInOut,
					onComplete: function(twn:FlxTween)
					{
						hintTween = null;
					}
				});
			}
		}
		else
		{
			button.onDown.callback = () -> onButtonDown.dispatch(button);
			button.onOut.callback = button.onUp.callback = () -> onButtonUp.dispatch(button);
		}

		button.statusAlphas = [];
		button.statusIndicatorType = NONE;
		button.solid = false;
		button.immovable = true;
		button.multiTouch = true;
		button.moves = false;
		button.antialiasing = FlxG.save.data.antialiasing;
		button.alpha = 0.00001;

		return button;
	}

	function createHintGraphic(Width:Int, Height:Int):FlxGraphic
	{
		var guh = FlxG.save.data.mobileCAlpha;

		if (guh >= 0.9)
			guh = guh - 0.1;

		var shape:Shape = new Shape();
		shape.graphics.beginFill(0xFFFFFF);

		if (FlxG.save.data.hitboxType == 'Gradient')
		{
			shape.graphics.lineStyle(3, 0xFFFFFF, 1);
			shape.graphics.drawRect(0, 0, Width, Height);
			shape.graphics.lineStyle(0, 0, 0);
			shape.graphics.drawRect(3, 3, Width - 6, Height - 6);
			shape.graphics.endFill();
			shape.graphics.beginGradientFill(RADIAL, [0xFFFFFF, FlxColor.TRANSPARENT], [guh, 0], [0, 255], null, null, null, 0.5);
			shape.graphics.drawRect(3, 3, Width - 6, Height - 6);
			shape.graphics.endFill();
		}
		else
		{
			shape.graphics.lineStyle(10, 0xFFFFFF, 1);
			shape.graphics.drawRect(0, 0, Width, Height);
			shape.graphics.endFill();
		}

		var bitmap:BitmapData = new BitmapData(Width, Height, true, 0);
		bitmap.draw(shape);

		return FlxG.bitmap.add(bitmap);
	}
}
