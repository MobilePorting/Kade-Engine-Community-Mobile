package mobile.kec.backend;

import flixel.util.FlxSave;

/**
 * ...
 * @author: Lily Ross (mcagabe19)
 */
class KEMobileData
{
	public static function initSave()
	{
		if (FlxG.save.data.mobileCMode == null)
			FlxG.save.data.mobileCMode = 3;

		if (FlxG.save.data.mobileCAlpha == null)
			FlxG.save.data.mobileCAlpha = FlxG.onMobile ? 0.6 : 0;

		if (FlxG.save.data.hitboxType == null)
			FlxG.save.data.hitboxType = 0;
	}
}
