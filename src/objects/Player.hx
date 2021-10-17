package objects;

import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxSprite;

typedef HoldsObj = {
    var left:Float;
    var right:Float;
    var up:Float;
    var down:Float;
}

class Player extends FlxSprite {
    static final VELOCITY = 60;

    var lrVel:Int = 0;
    var udVel:Int = 0;

    var holds:HoldsObj = {
        left: 0.,
        right: 0.,
        up: 0.,
        down: 0.
    };

    public function new (x:Float, y:Float) {
        super(x, y);

        makeGraphic(8, 12, 0xfffdf6e3);
    }

    override public function update (elapsed:Float) {
        handleInputs(elapsed);

        velocity.set(lrVel * VELOCITY, udVel * VELOCITY);

        super.update(elapsed);
    }

    /**
        Checks inputs and updates state. Updates left/right + up/down velocity.
    **/
    function handleInputs (elapsed:Float) {
        var controlsPressed = {
            left: FlxG.keys.pressed.LEFT,
            right: FlxG.keys.pressed.RIGHT,
            up: FlxG.keys.pressed.UP,
            down: FlxG.keys.pressed.DOWN,
        }

        lrVel = 0;
        udVel = 0;

        if (controlsPressed.left) {
            lrVel = -1;
            holds.left += elapsed;
        } else {
            holds.left = 0;
        }

        if (controlsPressed.right) {
            lrVel = 1;
            holds.right += elapsed;
        } else {
            holds.right = 0;
        }

        if (controlsPressed.left && controlsPressed.right) {
            if (holds.right > holds.left) {
                lrVel = -1;
            } else {
                lrVel = 1;
            }
        }

        if (controlsPressed.up) {
            udVel = -1;
            holds.up += elapsed;
        } else {
            holds.up = 0;
        }

        if (controlsPressed.down) {
            udVel = 1;
            holds.down += elapsed;
        } else {
            holds.down = 0;
        }

        if (controlsPressed.up && controlsPressed.down) {
            if (holds.down > holds.up) {
                udVel = -1;
            } else {
                udVel = 1;
            }
        }
    }
}
