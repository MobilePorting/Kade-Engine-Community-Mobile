/*
 * Copyright (C) 2025 Mobile Porting Team
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */

package mobile.kec.backend;

import kec.backend.Options.Option;
import kec.substates.OptionsMenu;

class MobileControlsOption extends Option
{
	public function new(desc:String)
	{
		super();
		acceptType = true;
		if (OptionsMenu.isInPause)
		{
			blocked = true;
			description = pauseDesc;
		}
		else
			description = desc;
	}

	public override function press():Bool
	{
		if (OptionsMenu.isInPause)
			return false;
		FlxG.state.openSubState(new mobile.kec.substates.MobileControlsSelectSubState());
		return true;
	}

	private override function updateDisplay():String
	{
		return "Mobile Controls";
	}
}

class ScreensaverOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function left():Bool
	{
		lime.system.System.allowScreenTimeout = !lime.system.System.allowScreenTimeout;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Allow Phone Screensaver: < " + (!lime.system.System.allowScreenTimeout ? "Disabled" : "Enabled") + " >";
	}
}

class MobileControlsOpacityOption extends Option
{
	public function new(desc:String)
	{
		super();
		if (OptionsMenu.isInPause)
		{
			blocked = true;
			description = pauseDesc;
		}
		else
		{
			description = desc;
			acceptValues = true;
		}
	}

	private function check():Void
	{
		if (FlxG.save.data.mobileCAlpha < 0)
			FlxG.save.data.mobileCAlpha = 0;

		if (FlxG.save.data.mobileCAlpha > 1)
			FlxG.save.data.mobileCAlpha = 1;
	}

	override function right():Bool
	{
		if (OptionsMenu.isInPause)
			return false;
		FlxG.save.data.mobileCAlpha += 0.1;

		check();

		return true;
	}

	override function left():Bool
	{
		if (OptionsMenu.isInPause)
			return false;
		FlxG.save.data.mobileCAlpha -= 0.1;

		check();

		return true;
	}

	override function getValue():String
	{
		return "Mobile Controls Opacity: " + kec.util.HelperFunctions.truncateFloat(FlxG.save.data.mobileCAlpha, 1);
	}
}

class HitboxDesignOption extends Option
{
	final hintOptions:Array<String> = ["No Gradient", "No Gradient (Old)", "Gradient", "Hidden"];

	public function new(desc:String)
	{
		super();
		if (OptionsMenu.isInPause)
		{
			blocked = true;
			description = pauseDesc;
		}
		else
			description = desc;
	}

	public override function left():Bool
	{
		if (OptionsMenu.isInPause)
			return false;
		FlxG.save.data.hitboxType--;
		if (FlxG.save.data.hitboxType < 0)
			FlxG.save.data.hitboxType = hintOptions.length - 1;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		if (OptionsMenu.isInPause)
			return false;
		FlxG.save.data.hitboxType++;
		if (FlxG.save.data.hitboxType > hintOptions.length - 1)
			FlxG.save.data.hitboxType = 0;
		display = updateDisplay();
		return true;
	}

	override function getValue():String
	{
		return updateDisplay();
	}

	public override function updateDisplay():String
	{
		return "Current Hitbox Design: < " + hintOptions[FlxG.save.data.hitboxType] + " >";
	}
}