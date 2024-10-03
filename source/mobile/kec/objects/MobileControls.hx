package mobile.kec.objects;

import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.util.FlxSignal;
import mobile.kec.input.MobileButtonsList;

/**
 * ...
 * @author: Karim Akra
 */
interface MobileControls
{
	public var buttonLeft:TouchButton;
	public var buttonUp:TouchButton;
	public var buttonRight:TouchButton;
	public var buttonDown:TouchButton;
	public var instance:FlxTypedSpriteGroup<TouchButton>;
	public var onButtonDown:FlxTypedSignal<TouchButton->Void>;
	public var onButtonUp:FlxTypedSignal<TouchButton->Void>;
	public function buttonPressed(id:MobileButtonsList):Bool;
	public function buttonJustPressed(id:MobileButtonsList):Bool;
	public function buttonJustReleased(id:MobileButtonsList):Bool;
}
