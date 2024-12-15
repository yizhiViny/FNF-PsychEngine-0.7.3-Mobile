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

import haxe.ds.StringMap;

class Data
{
	public static var dpadMode:StringMap<FlxDPadMode> = new StringMap<FlxDPadMode>();
	public static var actionMode:StringMap<FlxActionMode> = new StringMap<FlxActionMode>();
	public static var extraActions:StringMap<ExtraActions> = new StringMap<ExtraActions>();

	public static function setup()
	{
		for (data in FlxDPadMode.createAll())
			dpadMode.set(data.getName(), data);

		for (data in FlxActionMode.createAll())
			actionMode.set(data.getName(), data);

		for (data in ExtraActions.createAll())
			extraActions.set(data.getName(), data);
	}
}

enum FlxDPadMode
{
	UP_DOWN;
	LEFT_RIGHT;
	UP_LEFT_RIGHT;
	LEFT_FULL;
	RIGHT_FULL;
	BOTH;
	DIALOGUE_PORTRAIT;
	MENU_CHARACTER;
	NOTE_SPLASH_DEBUG;
	NONE;
}

enum FlxActionMode
{
	A;
	B;
	B_X;
	A_B;
	A_B_C;
	A_B_E;
	A_B_X_Y;
	A_B_C_X_Y;
	A_B_C_X_Y_Z;
	A_B_C_D_V_X_Y_Z;
	CHARACTER_EDITOR;
	DIALOGUE_PORTRAIT;
	MENU_CHARACTER;
	NOTE_SPLASH_DEBUG;
	P;
	B_C;
	NONE;
}

enum ExtraActions
{
	SINGLE;
	DOUBLE;
	NONE;
}
