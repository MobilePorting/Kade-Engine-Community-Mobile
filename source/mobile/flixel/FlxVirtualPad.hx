package mobile.flixel;

import flixel.FlxG;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.frames.FlxTileFrames;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSignal;
import mobile.flixel.FlxButton;
import openfl.display.BitmapData;
import openfl.utils.Assets;

// MTODO: FIX AFTER VPAD DESTROY CALL SPAM

enum FlxDPadMode
{
	UP_DOWN;
	LEFT_RIGHT;
	LEFT_FULL;
	RIGHT_FULL;
	NONE;
}

enum FlxActionMode
{
	A;
	B;
	P;
	A_B;
	A_B_C;
	A_B_E;
	A_B_X_Y;
	A_B_C_X_Y;
	A_B_C_X_Y_Z;
	A_B_C_D_V_X_Y_Z;
	NONE;
}

/**
 * A gamepad.
 * It's easy to customize the layout.
 *
 * @author Ka Wing Chin
 * @author Mihai Alexandru (M.A. Jigsaw)
 */
class FlxVirtualPad extends FlxTypedSpriteGroup<FlxButton>
{
	public var buttonLeft:FlxButton = new FlxButton(0, 0);
	public var buttonUp:FlxButton = new FlxButton(0, 0);
	public var buttonRight:FlxButton = new FlxButton(0, 0);
	public var buttonDown:FlxButton = new FlxButton(0, 0);

	public var buttonLeft2:FlxButton = new FlxButton(0, 0);
	public var buttonUp2:FlxButton = new FlxButton(0, 0);
	public var buttonRight2:FlxButton = new FlxButton(0, 0);
	public var buttonDown2:FlxButton = new FlxButton(0, 0);

	public var buttonA:FlxButton = new FlxButton(0, 0);
	public var buttonB:FlxButton = new FlxButton(0, 0);
	public var buttonC:FlxButton = new FlxButton(0, 0);
	public var buttonD:FlxButton = new FlxButton(0, 0);
	public var buttonE:FlxButton = new FlxButton(0, 0);
	public var buttonF:FlxButton = new FlxButton(0, 0);
	public var buttonG:FlxButton = new FlxButton(0, 0);
	public var buttonH:FlxButton = new FlxButton(0, 0);
	public var buttonI:FlxButton = new FlxButton(0, 0);
	public var buttonJ:FlxButton = new FlxButton(0, 0);
	public var buttonK:FlxButton = new FlxButton(0, 0);
	public var buttonL:FlxButton = new FlxButton(0, 0);
	public var buttonM:FlxButton = new FlxButton(0, 0);
	public var buttonN:FlxButton = new FlxButton(0, 0);
	public var buttonO:FlxButton = new FlxButton(0, 0);
	public var buttonP:FlxButton = new FlxButton(0, 0);
	public var buttonQ:FlxButton = new FlxButton(0, 0);
	public var buttonR:FlxButton = new FlxButton(0, 0);
	public var buttonS:FlxButton = new FlxButton(0, 0);
	public var buttonT:FlxButton = new FlxButton(0, 0);
	public var buttonU:FlxButton = new FlxButton(0, 0);
	public var buttonV:FlxButton = new FlxButton(0, 0);
	public var buttonX:FlxButton = new FlxButton(0, 0);
	public var buttonY:FlxButton = new FlxButton(0, 0);
	public var buttonZ:FlxButton = new FlxButton(0, 0);

	public var onButtonUp:FlxTypedSignal<FlxButton->Void> = new FlxTypedSignal<FlxButton->Void>();
	public var onButtonDown:FlxTypedSignal<FlxButton->Void> = new FlxTypedSignal<FlxButton->Void>();

	/**
	 * Create a gamepad.
	 *
	 * @param   DPadMode     The D-Pad mode. `LEFT_FULL` for example.
	 * @param   ActionMode   The action buttons mode. `A_B_C` for example.
	 */
	public function new(DPad:FlxDPadMode, Action:FlxActionMode):Void
	{
		super();

		switch (DPad)
		{
			case UP_DOWN:
				add(buttonUp = createButton(0, FlxG.height - 255, 'up', 0x00FF00));
				add(buttonDown = createButton(0, FlxG.height - 135, 'down', 0x00FFFF));
			case LEFT_RIGHT:
				add(buttonLeft = createButton(0, FlxG.height - 135, 'left', 0xFF00FF));
				add(buttonRight = createButton(127, FlxG.height - 135, 'right', 0xFF0000));
			case LEFT_FULL:
				add(buttonUp = createButton(105, FlxG.height - 345, 'up', 0x00FF00));
				add(buttonLeft = createButton(0, FlxG.height - 243, 'left', 0xFF00FF));
				add(buttonRight = createButton(207, FlxG.height - 243, 'right', 0xFF0000));
				add(buttonDown = createButton(105, FlxG.height - 135, 'down', 0x00FFFF));
			case RIGHT_FULL:
				add(buttonUp = createButton(FlxG.width - 258, FlxG.height - 408, 'up', 0x00FF00));
				add(buttonLeft = createButton(FlxG.width - 384, FlxG.height - 309, 'left', 0xFF00FF));
				add(buttonRight = createButton(FlxG.width - 132, FlxG.height - 309, 'right', 0xFF0000));
				add(buttonDown = createButton(FlxG.width - 258, FlxG.height - 201, 'down', 0x00FFFF));
			case NONE: // do nothing
		}

		switch (Action)
		{
			case A:
				add(buttonA = createButton(FlxG.width - 132, FlxG.height - 135, 'a', 0xFF0000));
			case B:
				add(buttonB = createButton(FlxG.width - 132, FlxG.height - 135, 'b', 0xFFCB00));
			case P:
				add(buttonP = createButton(FlxG.width - 132, 0, 'x', 0x99062D));
			case A_B:
				add(buttonB = createButton(FlxG.width - 258, FlxG.height - 135, 'b', 0xFFCB00));
				add(buttonA = createButton(FlxG.width - 132, FlxG.height - 135, 'a', 0xFF0000));
			case A_B_C:
				add(buttonC = createButton(FlxG.width - 384, FlxG.height - 135, 'c', 0x44FF00));
				add(buttonB = createButton(FlxG.width - 258, FlxG.height - 135, 'b', 0xFFCB00));
				add(buttonA = createButton(FlxG.width - 132, FlxG.height - 135, 'a', 0xFF0000));
			case A_B_E:
				add(buttonE = createButton(FlxG.width - 384, FlxG.height - 135, 'e', 0xFF7D00));
				add(buttonB = createButton(FlxG.width - 258, FlxG.height - 135, 'b', 0xFFCB00));
				add(buttonA = createButton(FlxG.width - 132, FlxG.height - 135, 'a', 0xFF0000));
			case A_B_X_Y:
				add(buttonX = createButton(FlxG.width - 510, FlxG.height - 135, 'x', 0x99062D));
				add(buttonB = createButton(FlxG.width - 258, FlxG.height - 135, 'b', 0xFFCB00));
				add(buttonY = createButton(FlxG.width - 384, FlxG.height - 135, 'y', 0x4A35B9));
				add(buttonA = createButton(FlxG.width - 132, FlxG.height - 135, 'a', 0xFF0000));
			case A_B_C_X_Y:
				add(buttonC = createButton(FlxG.width - 384, FlxG.height - 135, 'c', 0x44FF00));
				add(buttonX = createButton(FlxG.width - 258, FlxG.height - 255, 'x', 0x99062D));
				add(buttonB = createButton(FlxG.width - 258, FlxG.height - 135, 'b', 0xFFCB00));
				add(buttonY = createButton(FlxG.width - 132, FlxG.height - 255, 'y', 0x4A35B9));
				add(buttonA = createButton(FlxG.width - 132, FlxG.height - 135, 'a', 0xFF0000));
			case A_B_C_X_Y_Z:
				add(buttonX = createButton(FlxG.width - 384, FlxG.height - 255, 'x', 0x99062D));
				add(buttonC = createButton(FlxG.width - 384, FlxG.height - 135, 'c', 0x44FF00));
				add(buttonY = createButton(FlxG.width - 258, FlxG.height - 255, 'y', 0x4A35B9));
				add(buttonB = createButton(FlxG.width - 258, FlxG.height - 135, 'b', 0xFFCB00));
				add(buttonZ = createButton(FlxG.width - 132, FlxG.height - 255, 'z', 0xCCB98E));
				add(buttonA = createButton(FlxG.width - 132, FlxG.height - 135, 'a', 0xFF0000));
			case A_B_C_D_V_X_Y_Z:
				add(buttonV = createButton(FlxG.width - 510, FlxG.height - 255, 'v', 0x49A9B2));
				add(buttonD = createButton(FlxG.width - 510, FlxG.height - 135, 'd', 0x0078FF));
				add(buttonX = createButton(FlxG.width - 384, FlxG.height - 255, 'x', 0x99062D));
				add(buttonC = createButton(FlxG.width - 384, FlxG.height - 135, 'c', 0x44FF00));
				add(buttonY = createButton(FlxG.width - 258, FlxG.height - 255, 'y', 0x4A35B9));
				add(buttonB = createButton(FlxG.width - 258, FlxG.height - 135, 'b', 0xFFCB00));
				add(buttonZ = createButton(FlxG.width - 132, FlxG.height - 255, 'z', 0xCCB98E));
				add(buttonA = createButton(FlxG.width - 132, FlxG.height - 135, 'a', 0xFF0000));
			case NONE: // do nothing
		}

		scrollFactor.set();
	}

	/**
	 * Clean up memory.
	 */
	override public function destroy():Void
	{
		super.destroy();
		for (field in Reflect.fields(this))
			if (Std.isOfType(Reflect.field(this, field), FlxButton))
				Reflect.setField(this, field, FlxDestroyUtil.destroy(Reflect.field(this, field)));
	}

	private function createButton(X:Float, Y:Float, Graphic:String, Color:Int = 0xFFFFFF):FlxButton
	{
		var graphic:FlxGraphic;

		if (Assets.exists(Paths.getPath('images/virtualpad/${Graphic}.png', IMAGE, null)))
			graphic = FlxG.bitmap.add(Paths.getPath('images/virtualpad/${Graphic}.png', IMAGE, null));
		else
			graphic = FlxG.bitmap.add(Paths.getPath('images/virtualpad/default.png', IMAGE, null));

		var button:FlxButton = new FlxButton(X, Y);
		button.frames = FlxTileFrames.fromGraphic(graphic, FlxPoint.get(Std.int(graphic.width / 2), graphic.height));
		button.solid = false;
		button.immovable = true;
		//button.moves = false;
		button.antialiasing = FlxG.save.data.antialiasing;
		button.scrollFactor.set();
		button.color = Color;
		button.alpha = FlxG.save.data.mobileCAlpha;
		button.onDown.callback = button.onOver.callback = () -> onButtonDown.dispatch(button);
		button.onUp.callback = button.onOut.callback = () -> onButtonUp.dispatch(button);
		#if FLX_DEBUG
		button.ignoreDrawDebug = true;
		#end
		return button;
	}
}
