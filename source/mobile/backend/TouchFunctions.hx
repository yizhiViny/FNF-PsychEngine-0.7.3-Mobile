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


package mobile.backend;

import flixel.FlxBasic;
import flixel.input.touch.FlxTouch;

class TouchFunctions
{
	public static var touchPressed(get, never):Bool;
	public static var touchJustPressed(get, never):Bool;
	public static var touchJustReleased(get, never):Bool;
	public static var touch(get, never):FlxTouch;

	public static function touchOverlapObject(object:FlxBasic):Bool
	{
		for (touch in FlxG.touches.list)
			return touch.overlaps(object);
		return false;
	}

	@:noCompletion
	private static function get_touchPressed():Bool
	{
		for (touch in FlxG.touches.list)
			return touch.pressed;
		return false;
	}

	@:noCompletion
	private static function get_touchJustPressed():Bool
	{
		for (touch in FlxG.touches.list)
			return touch.justPressed;
		return false;
	}

	@:noCompletion
	private static function get_touchJustReleased():Bool
	{
		for (touch in FlxG.touches.list)
			return touch.justReleased;
		return false;
	}

	@:noCompletion
	private static function get_touch():FlxTouch
	{
		for (touch in FlxG.touches.list)
			return touch;
		return FlxG.touches.list[0];
	}
}
