package kec.states;

import lime.app.Application;

class OutdatedSubState extends MusicBeatState
{
	public static var leftState:Bool = false;

	public static var needVer:String = "IDFK LOL";
	public static var currChanges:String = "dk";

	private var bgColors:Array<String> = ['#314d7f', '#4e7093', '#70526e', '#594465'];
	private var colorRotation:Int = 1;

	override function create()
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();
		super.create();
		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('stageback', 'shared'));
		bg.screenCenter();
		bg.antialiasing = FlxG.save.data.antialiasing;
		add(bg);

		final buttonACCEPT:String = MobileControls.enabled ? "A" : "Space";
		final buttonBACK:String = MobileControls.enabled ? "B" : MainMenuState.kecVer.contains("PRE-RELEASE") ? "Space/Escape" : "ENTER";

		var txt:FlxText = new FlxText(0, 0, FlxG.width,
			"Your KEC Port is outdated!\nYou are on "
			+ MainMenuState.kecVer
			+ "\nwhile the most recent version is "
			+ needVer
			+ "."
			+ "\n\nWhat's new:\n\n"
			+ currChanges
			+ '\n\nPress $buttonACCEPT to view the full changelog and update\nor $buttonBACK to ignore this',
			32);

		if (Constants.kecVer.contains("PRE-RELEASE"))
			txt.text = "You are on\n"
				+ Constants.kecVer
				+ "\nWhich is a PRE-RELEASE BUILD!"
				+ '\n\nReport all bugs to the author of the pre-release.\n$buttonBACK ignores this.';

		txt.setFormat("VCR OSD Mono", 23, FlxColor.fromRGB(200, 200, 200), CENTER);
		txt.borderColor = FlxColor.BLACK;
		txt.borderSize = 2;
		txt.borderStyle = FlxTextBorderStyle.OUTLINE;
		txt.screenCenter();
		add(txt);

		// 6% chance of MOM appearing instead of KEC
		if (FlxG.random.bool(6) && !Constants.kecVer.contains("PRE-RELEASE"))
			// YOU KNOW WHO ELSE IS OUTDATED? MY MOM!
		{
			var mom:FlxText = new FlxText(0, 0, FlxG.width,
				"Your MOM is outdated!\nYou are on "
				+ Constants.kecVer
				+ "\nwhile the most recent version is "
				+ needVer
				+ "."
				+ "\n\nWhat's new:\n\n"
				+ currChanges
				+ '\n\nPress $buttonACCEPT to view the full changelog and update\nor $buttonBACK to ignore this',
				32);

			mom.setFormat("VCR OSD Mono", 23, FlxColor.fromRGB(200, 200, 200), CENTER);
			mom.borderColor = FlxColor.BLACK;
			mom.borderSize = 3;
			mom.borderStyle = FlxTextBorderStyle.OUTLINE;
			mom.screenCenter();
			remove(txt);

			add(mom);
		}

		FlxTween.color(bg, 2, bg.color, FlxColor.fromString(bgColors[colorRotation]));

		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			FlxTween.color(bg, 2, bg.color, FlxColor.fromString(bgColors[colorRotation]));
			if (colorRotation < (bgColors.length - 1))
				colorRotation++;
			else
				colorRotation = 0;
		}, 0);

		Paths.clearUnusedMemory();

		addVirtualPad(NONE, A_B);
	}

	override function update(elapsed:Float)
	{
<<<<<<< HEAD
		if (virtualPad.buttonA.justPressed || FlxG.keys.justPressed.SPACE && !MainMenuState.kecVer.contains("PRE-RELEASE"))
=======
		if (FlxG.keys.justPressed.SPACE && !Constants.kecVer.contains("PRE-RELEASE"))
>>>>>>> upstream/master
		{
			fancyOpenURL("https://therealjake12.github.io/Kade-Engine-Community/changelogs/changelog-" + needVer);
		}
		else if (controls.ACCEPT || controls.BACK)
		{
			leftState = true;
			MusicBeatState.switchState(new MainMenuState());
		}
		super.update(elapsed);
	}
}
