package mobile.kec.objects;

import flixel.FlxSprite;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxColor;
import haxe.io.Path;
import flixel.graphics.frames.FlxTileFrames;
import flixel.math.FlxPoint;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.FlxGraphic;
import openfl.utils.Assets;
import openfl.utils.AssetType;
import openfl.display.BitmapData;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.util.FlxSignal;
import mobile.kec.input.MobileButtonsList;

using StringTools;

/**
 * ...
 * @author: Karim Akra and Lily Ross (mcagabe19)
 */
@:access(mobile.TouchButton)
class TouchPad extends FlxTypedSpriteGroup<TouchButton> implements MobileControls
{
	public var buttonLeft:TouchButton = new TouchButton(0, 0);
	public var buttonUp:TouchButton = new TouchButton(0, 0);
	public var buttonRight:TouchButton = new TouchButton(0, 0);
	public var buttonDown:TouchButton = new TouchButton(0, 0);
	public var buttonA:TouchButton = new TouchButton(0, 0);
	public var buttonB:TouchButton = new TouchButton(0, 0);
	public var buttonC:TouchButton = new TouchButton(0, 0);
	public var buttonD:TouchButton = new TouchButton(0, 0);
	public var buttonE:TouchButton = new TouchButton(0, 0);
	public var buttonF:TouchButton = new TouchButton(0, 0);
	public var buttonG:TouchButton = new TouchButton(0, 0);
	public var buttonH:TouchButton = new TouchButton(0, 0);
	public var buttonI:TouchButton = new TouchButton(0, 0);
	public var buttonJ:TouchButton = new TouchButton(0, 0);
	public var buttonK:TouchButton = new TouchButton(0, 0);
	public var buttonL:TouchButton = new TouchButton(0, 0);
	public var buttonM:TouchButton = new TouchButton(0, 0);
	public var buttonN:TouchButton = new TouchButton(0, 0);
	public var buttonO:TouchButton = new TouchButton(0, 0);
	public var buttonP:TouchButton = new TouchButton(0, 0);
	public var buttonQ:TouchButton = new TouchButton(0, 0);
	public var buttonR:TouchButton = new TouchButton(0, 0);
	public var buttonS:TouchButton = new TouchButton(0, 0);
	public var buttonT:TouchButton = new TouchButton(0, 0);
	public var buttonU:TouchButton = new TouchButton(0, 0);
	public var buttonV:TouchButton = new TouchButton(0, 0);
	public var buttonW:TouchButton = new TouchButton(0, 0);
	public var buttonX:TouchButton = new TouchButton(0, 0);
	public var buttonY:TouchButton = new TouchButton(0, 0);
	public var buttonZ:TouchButton = new TouchButton(0, 0);

	public var instance:FlxTypedSpriteGroup<TouchButton>;
	public var onButtonDown:FlxTypedSignal<TouchButton->Void> = new FlxTypedSignal<TouchButton->Void>();
	public var onButtonUp:FlxTypedSignal<TouchButton->Void> = new FlxTypedSignal<TouchButton->Void>();

	/**
	 * Create a gamepad.
	 *
	 * @param   DPadMode     The D-Pad mode. `"LEFT_FULL"` for example.
	 * @param   ActionMode   The action buttons mode. `"A_B"` for example.
	 */
	public function new(DPad:String, Action:String)
	{
		super();

		if (DPad != "NONE")
		{
			if (!MobileData.dpadModes.exists(DPad))
				throw 'The touchPad dpadMode "$DPad" doesn\'t exists.';
			for (buttonData in MobileData.dpadModes.get(DPad).buttons)
			{
				Reflect.setField(this, buttonData.button,
					createButton(buttonData.x, buttonData.y, buttonData.graphic, CoolUtil.colorFromString(buttonData.color)));

				var button:TouchButton = Reflect.field(this, buttonData.button);
				var ids:Array<MobileButtonsList> = [];
				if (buttonData.id != null)
				{
					for (id in buttonData.id)
						if (id != null && MobileData.buttonsListIDs.exists(id))
							ids.push(MobileData.buttonsListIDs.get(id));
					button.id = ids;
				}
				add(button);
			}
		}

		if (Action != "NONE")
		{
			if (!MobileData.actionModes.exists(Action))
				throw 'The touchPad actionMode "$Action" doesn\'t exists.';
			for (buttonData in MobileData.actionModes.get(Action).buttons)
			{
				Reflect.setField(this, buttonData.button,
					createButton(buttonData.x, buttonData.y, buttonData.graphic, CoolUtil.colorFromString(buttonData.color)));

				var button:TouchButton = Reflect.field(this, buttonData.button);
				var ids:Array<MobileButtonsList> = [];
				if (buttonData.id != null)
				{
					for (id in buttonData.id)
						if (id != null && MobileData.buttonsListIDs.exists(id))
							ids.push(MobileData.buttonsListIDs.get(id));
					button.id = ids;
				}
				add(button);
			}
		}

		alpha = FlxG.save.data.mobileCAlpha;
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

	override public function destroy()
	{
		super.destroy();

		for (field in Reflect.fields(this))
			if (Std.isOfType(Reflect.field(this, field), TouchButton))
				Reflect.setField(this, field, FlxDestroyUtil.destroy(Reflect.field(this, field)));

		onButtonDown.removeAll();
		onButtonUp.removeAll();
		onButtonDown = onButtonDown = null;
	}

	private function createButton(X:Float, Y:Float, Graphic:String, ?Color:FlxColor = 0xFFFFFF):TouchButton
	{
		var button = getButtonInstance(X, Y, Graphic.toUpperCase());
		button.color = Color;
		button.parentAlpha = this.alpha;
		return button;
	}

	private function getButtonInstance(x:Float = 0, y:Float = 0, ?labelGraphic:String):TouchButton
	{
		var button:TouchButton = new TouchButton(x, y);
		if (labelGraphic != null)
		{
			button.label = new FlxSprite();
			button.loadGraphic(Paths.image('touchpad/bg', "mobile"));
			button.label.loadGraphic(Paths.image('touchpad/$labelGraphic', "mobile"));
			button.scale.set(0.243, 0.243);
			button.updateHitbox();
			@:privateAccess button.updateLabelPosition();
			button.statusBrightness = [1, 0.75, 0.4];
			button.statusIndicatorType = BRIGHTNESS;
			@:privateAccess button.indicateStatus();
			button.immovable = true;
			button.moves = button.solid = false;
			button.antialiasing = button.label.antialiasing = FlxG.save.data.antialiasing;
			button.tag = labelGraphic.toUpperCase();

			button.onDown.callback = () -> onButtonDown.dispatch(button);
			button.onOut.callback = button.onUp.callback = () -> onButtonUp.dispatch(button);
		}
		return button;
	}

	override function set_alpha(Value):Float
	{
		forEachAlive((button:TouchButton) -> button.parentAlpha = Value);
		return super.set_alpha(Value);
	}
}
