package objects;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;

enum EnemyState {
    Stroll;
}

class Enemy extends FlxSprite {
    var player:Player;
    var attacking:Bool = false;
    var state:EnemyState = Stroll;
    // MD:
    var vel:FlxPoint = new FlxPoint(90, 90);

    public function new (x:Float, y:Float, player:Player) {
        super(x, y);

        this.player = player;
        makeGraphic(16, 16, 0xffb58900);
        offset.set(1, 1);
        setSize(14, 14);
        chooseStart();
    }

    override public function update (elapsed:Float) {
        chooseState();
        super.update(elapsed);
    }

    function chooseState () {
        // TODO: different enemy state types
        var vels = [{ x: -1, y: 0 }, { x: 1, y: 0 }, { x: 0, y: 1 }, { x: 0, y: -1 }];
        switch (state) {
            case Stroll:
                if (isTouching(FlxObject.LEFT)) {
                    vels.splice(0, 1);
                } else if (isTouching(FlxObject.RIGHT)) {
                    vels.splice(1, 1);
                } else if (isTouching(FlxObject.UP)) {
                    vels.splice(2, 1);
                } else if (isTouching(FlxObject.DOWN)) {
                    vels.splice(3, 1);
                    // gross
                } else if (Math.random() < 0.005) {
                    // skip and try any dir
                } else {
                    return;
                }

                final chosenVel = vels[Math.floor(Math.random() * vels.length)];

                velocity.set(chosenVel.x * vel.x, chosenVel.y * vel.y);
        }
    }

    function chooseStart () {
        var vels = [{ x: -1, y: 0 }, { x: 1, y: 0 }, { x: 0, y: 1 }, { x: 0, y: -1 }];
        switch (state) {
            case Stroll:
                final chosenVel = vels[Math.floor(Math.random() * vels.length)];
                velocity.set(chosenVel.x * vel.x, chosenVel.y * vel.y);
        }
    }
}
