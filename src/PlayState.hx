package;

import objects.Player;
import flixel.FlxG;
import flixel.FlxState;

class PlayState extends FlxState {
    override public function create() {
        super.create();

        camera.pixelPerfectRender = true;

        var player = new Player(100, 80);
        add(player);
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);
    }
}
