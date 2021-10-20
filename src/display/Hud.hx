package display;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;

class Hud extends FlxGroup {
    public function new () {
        super();

        var bg = new FlxSprite();
        bg.makeGraphic(FlxG.width, 16, 0xff6c71c4);
        bg.scrollFactor.set(0, 0);
        add(bg);
    }
}
