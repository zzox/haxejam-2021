package objects;

import flixel.FlxSprite;

class Enemy extends FlxSprite {
    var player:Player;
    public function new (x:Float, y:Float, player:Player) {
        super(x, y);

        this.player = player;
    }

    override public function update (elapsed:Float) {
        
    }
}
