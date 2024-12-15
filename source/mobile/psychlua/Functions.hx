/*
 * Copyright (C) 2024 Mobile Porting Team
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

package mobile.psychlua;

#if LUA_ALLOWED
import llua.*;
import llua.Lua;
import lime.ui.Haptic;
import psychlua.FunkinLua;
import mobile.backend.TouchFunctions;
#if android
import mobile.backend.PsychJNI;
// import android.os.BatteryManager;
import android.widget.Toast;
import android.Tools;
#end

class MobileFunctions
{
	public static function implement(funk:FunkinLua)
	{
		funk.set('mobileC', Controls.instance.mobileC);

		funk.set('mobileControlsMode', getMobileControlsAsString());

		funk.set("extraButtonPressed", function(button:String)
		{
			button = button.toLowerCase();
			if (MusicBeatState.instance.mobileControls != null)
			{
				switch (button)
				{
					case 'second':
						return MusicBeatState.instance.mobileControls.current.buttonExtra2.pressed;
					default:
						return MusicBeatState.instance.mobileControls.current.buttonExtra.pressed;
				}
			}
			return false;
		});

		funk.set("extraButtonJustPressed", function(button:String)
		{
			button = button.toLowerCase();
			if (MusicBeatState.instance.mobileControls != null)
			{
				switch (button)
				{
					case 'second':
						return MusicBeatState.instance.mobileControls.current.buttonExtra2.justPressed;
					default:
						return MusicBeatState.instance.mobileControls.current.buttonExtra.justPressed;
				}
			}
			return false;
		});

		funk.set("extraButtonJustReleased", function(button:String)
		{
			button = button.toLowerCase();
			if (MusicBeatState.instance.mobileControls != null)
			{
				switch (button)
				{
					case 'second':
						return MusicBeatState.instance.mobileControls.current.buttonExtra2.justReleased;
					default:
						return MusicBeatState.instance.mobileControls.current.buttonExtra.justReleased;
				}
			}
			return false;
		});

		funk.set("vibrate", function(duration:Null<Int>, ?period:Null<Int>)
		{
			if (period == null)
				period = 0;
			if (duration == null)
				return FunkinLua.luaTrace('vibrate: No duration specified.');
			return Haptic.vibrate(period, duration);
		});

		funk.set("addVirtualPad", (DPadMode:String, ActionMode:String) ->
		{
			PlayState.instance.makeLuaVirtualPad(DPadMode, ActionMode);
			PlayState.instance.addLuaVirtualPad();
		});

		funk.set("removeVirtualPad", () ->
		{
			PlayState.instance.removeLuaVirtualPad();
		});

		funk.set("addVirtualPadCamera", () ->
		{
			if (PlayState.instance.luaVirtualPad == null)
			{
				FunkinLua.luaTrace('addVirtualPadCamera: VPAD does not exist.');
				return;
			}
			PlayState.instance.addLuaVirtualPadCamera();
		});

		funk.set("virtualPadJustPressed", function(button:Dynamic):Bool
		{
			if (PlayState.instance.luaVirtualPad == null)
			{
				//FunkinLua.luaTrace('virtualPadJustPressed: VPAD does not exist.');
				return false;
			}
			return PlayState.instance.luaVirtualPadJustPressed(button);
		});

		funk.set("virtualPadPressed", function(button:Dynamic):Bool
		{
			if (PlayState.instance.luaVirtualPad == null)
			{
				//FunkinLua.luaTrace('virtualPadPressed: VPAD does not exist.');
				return false;
			}
			return PlayState.instance.luaVirtualPadPressed(button);
		});

		funk.set("virtualPadJustReleased", function(button:Dynamic):Bool
		{
			if (PlayState.instance.luaVirtualPad == null)
			{
				//FunkinLua.luaTrace('virtualPadJustReleased: VPAD does not exist.');
				return false;
			}
			return PlayState.instance.luaVirtualPadJustReleased(button);
		});

		funk.set("touchJustPressed", TouchFunctions.touchJustPressed);
		funk.set("touchPressed", TouchFunctions.touchPressed);
		funk.set("touchJustReleased", TouchFunctions.touchJustReleased);
		funk.set("touchPressedObject", function(object:String):Bool
		{
			var obj = PlayState.instance.getLuaObject(object);
			if (obj == null)
			{
				FunkinLua.luaTrace('touchPressedObject: $object does not exist.');
				return false;
			}
			return TouchFunctions.touchOverlapObject(obj) && TouchFunctions.touchPressed;
		});

		funk.set("touchJustPressedObject", function(object:String):Bool
		{
			var obj = PlayState.instance.getLuaObject(object);
			if (obj == null)
			{
				FunkinLua.luaTrace('touchJustPressedObject: $object does not exist.');
				return false;
			}
			return TouchFunctions.touchOverlapObject(obj) && TouchFunctions.touchJustPressed;
		});

		funk.set("touchJustReleasedObject", function(object:String):Bool
		{
			var obj = PlayState.instance.getLuaObject(object);
			if (obj == null)
			{
				FunkinLua.luaTrace('touchJustPressedObject: $object does not exist.');
				return false;
			}
			return TouchFunctions.touchOverlapObject(obj) && TouchFunctions.touchJustReleased;
		});

		funk.set("touchOverlapsObject", function(object:String):Bool
		{
			var obj = PlayState.instance.getLuaObject(object);
			if (obj == null)
			{
				FunkinLua.luaTrace('touchOverlapsObject: $object does not exist.');
				return false;
			}
			return TouchFunctions.touchOverlapObject(obj);
		});
	}

	public static function getMobileControlsAsString():String
	{
		switch (MobileControls.mode)
		{
			case 0:
				return 'left';
			case 1:
				return 'right';
			case 2:
				return 'custom';
			case 3:
				return 'duo';
			case 4:
				return 'hitbox';
			case 5:
				return 'none';
		}
		return 'unknown';
	}
}

#if android
class AndroidFunctions
{
	// static var spicyPillow:BatteryManager = new BatteryManager();
	public static function implement(funk:FunkinLua)
	{
		// funk.set("isRooted", Tools.isRooted());
		funk.set("isDolbyAtmos", Tools.isDolbyAtmos());
		funk.set("isAndroidTV", Tools.isAndroidTV());
		funk.set("isTablet", Tools.isTablet());
		funk.set("isChromebook", Tools.isChromebook());
		funk.set("isDeXMode", Tools.isDeXMode());
		// funk.set("isCharging", spicyPillow.isCharging());

		funk.set("backJustPressed", FlxG.android.justPressed.BACK);
		funk.set("backPressed", FlxG.android.pressed.BACK);
		funk.set("backJustReleased", FlxG.android.justReleased.BACK);

		funk.set("menuJustPressed", FlxG.android.justPressed.MENU);
		funk.set("menuPressed", FlxG.android.pressed.MENU);
		funk.set("menuJustReleased", FlxG.android.justReleased.MENU);

		funk.set("getCurrentOrientation", () -> PsychJNI.getCurrentOrientationAsString());
		funk.set("setOrientation", function(?hint:String):Void
		{
			switch (hint.toLowerCase())
			{
				case 'portrait':
					hint = 'Portrait';
				case 'portraitupsidedown' | 'upsidedownportrait' | 'upsidedown':
					hint = 'PortraitUpsideDown';
				case 'landscapeleft' | 'leftlandscape':
					hint = 'LandscapeLeft';
				case 'landscaperight' | 'rightlandscape' | 'landscape':
					hint = 'LandscapeRight';
				default:
					hint = null;
			}
			if (hint == null)
				return FunkinLua.luaTrace('setOrientation: No orientation specified.');
			PsychJNI.setOrientation(FlxG.stage.stageWidth, FlxG.stage.stageHeight, false, hint);
		});

		funk.set("minimizeWindow", () -> Tools.minimizeWindow());

		funk.set("showToast", function(text:String, ?duration:Int, ?xOffset:Int, ?yOffset:Int) /* , ?gravity:Int*/
		{
			if (text == null)
				return FunkinLua.luaTrace('showToast: No text specified.');
			else if (duration == null)
				return FunkinLua.luaTrace('showToast: No duration specified.');

			if (xOffset == null)
				xOffset = 0;
			if (yOffset == null)
				yOffset = 0;

			Toast.makeText(text, duration, -1, xOffset, yOffset);
		});

		funk.set("isScreenKeyboardShown", () -> PsychJNI.isScreenKeyboardShown());

		funk.set("clipboardHasText", () -> PsychJNI.clipboardHasText());
		funk.set("clipboardGetText", () -> PsychJNI.clipboardGetText());
		funk.set("clipboardSetText", function(?text:String):Void
		{
			if (text != null)
				return FunkinLua.luaTrace('clipboardSetText: No text specified.');
			PsychJNI.clipboardSetText(text);
		});

		funk.set("manualBackButton", () -> PsychJNI.manualBackButton());

		funk.set("setActivityTitle", function(text:String):Void
		{
			if (text != null)
				return FunkinLua.luaTrace('setActivityTitle: No text specified.');
			PsychJNI.setActivityTitle(text);
		});
	}
}
#end
#end
