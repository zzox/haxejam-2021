package objects;

import data.Utils;
import flixel.FlxG;
import flixel.FlxSprite;

typedef HoldsObj = {
    var left:Float;
    var right:Float;
    var up:Float;
    var down:Float;
}

class Player extends FlxSprite {
    static final VELOCITY = 60;

    public var facingDir:Dir = Down;
    var lrVel:Int = 0;
    var udVel:Int = 0;
    var holds:HoldsObj = {
        left: 0.,
        right: 0.,
        up: 0.,
        down: 0.
    };

    public var sword:Sword;

    var scene:PlayState;

    public function new (x:Float, y:Float, scene:PlayState) {
        super(x, y);

        makeGraphic(8, 12, 0xfffdf6e3);

        this.scene = scene;
        sword = new Sword(this);
    }

    override public function update (elapsed:Float) {
        if (scene.movingRoom) {
            // TODO: play running/walking anim
            lrVel = 0;
            udVel = 0;
        } else {
            handleInputs(elapsed);
        }

        velocity.set(lrVel * VELOCITY, udVel * VELOCITY);

        super.update(elapsed);
    }

    /**
        Checks inputs and updates state. Updates left/right + up/down velocity.
    **/
    function handleInputs (elapsed:Float) {
        if (FlxG.keys.pressed.Z) {
            sword.swing();
            // TODO: allow for buffer
        } else {
            sword.release();
        }

        var controlsPressed = {
            left: FlxG.keys.pressed.LEFT,
            right: FlxG.keys.pressed.RIGHT,
            up: FlxG.keys.pressed.UP,
            down: FlxG.keys.pressed.DOWN
        }

        lrVel = 0;
        udVel = 0;

        if (controlsPressed.left) {
            if (holds.left == 0) {
                facingDir = Left;
            }

            lrVel = -1;
            holds.left += elapsed;
        } else {
            holds.left = 0;
        }

        if (controlsPressed.right) {
            if (holds.right == 0) {
                facingDir = Right;
            }

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
            if (holds.up == 0) {
                facingDir = Up;
            }

            udVel = -1;
            holds.up += elapsed;
        } else {
            holds.up = 0;
        }

        if (controlsPressed.down) {
            if (holds.down == 0) {
                facingDir = Down;
            }

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
