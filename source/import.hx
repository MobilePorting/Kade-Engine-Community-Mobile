#if !macro
import flixel.sound.FlxSound;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.math.FlxPoint;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxStringUtil;
import haxe.Json;
import flixel.input.keyboard.FlxKey;
#if android
import android.content.Context as AndroidContext;
import android.widget.Toast as AndroidToast;
import android.os.Environment as AndroidEnvironment;
import android.Permissions as AndroidPermissions;
import android.Settings as AndroidSettings;
import android.Tools as AndroidTools;
import android.os.Build.VERSION as AndroidVersion;
import android.os.Build.VERSION_CODES as AndroidVersionCode;
import android.os.BatteryManager as AndroidBatteryManager;
#end
import mobile.kec.objects.MobileControls;
import mobile.kec.backend.util.StorageUtil;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.FlxCamera;
import flixel.FlxState;
import flixel.FlxSubState;
import kec.objects.KECSprite;
import kec.states.*;
import kec.backend.util.Paths;
import kec.backend.chart.Conductor;
import kec.backend.Debug;
import kec.backend.util.CoolUtil;
import kec.backend.Constants;
import kec.backend.util.Sort;
#end

using Lambda;
using StringTools;
using kec.backend.tools.ArraySortTools;
using kec.backend.tools.ArrayTools;
using kec.backend.tools.FloatTools;
using kec.backend.tools.Int64Tools;
using kec.backend.tools.IntTools;
using kec.backend.tools.IteratorTools;
using kec.backend.tools.MapTools;
using kec.backend.tools.StringTools;
