package;

import objects.Player;
import flixel.FlxG;
import flixel.FlxState;
import data.FloorMap;

class PlayState extends FlxState {
    override public function create() {
        super.create();

        camera.pixelPerfectRender = true;

        var player = new Player(100, 80);
        add(player);

        final map = new FloorMap(2);
        map.generate();
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);
    }
}
