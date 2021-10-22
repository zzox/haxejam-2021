package objects;

import data.Utils;
import flixel.FlxG;
import flixel.FlxSprite;

typedef HoldsObj = {
    var left:Float;
    var right:Float;
    var up:Float;
    var down:Float;
    var swing:Float;
}

class Player extends FlxSprite {
    static final VELOCITY = 60;

    public var facingDir:Dir = Down;
    var facingDirs:Array<Dir> = [];
    var lrVel:Int = 0;
    var udVel:Int = 0;
    var holds:HoldsObj = {
        left: 0.,
        right: 0.,
        up: 0.,
        down: 0.,
        swing: 0.
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
        var justReleased = false;
        if (FlxG.keys.pressed.Z) {
            holds.swing += elapsed;
            sword.swing();
            // TODO: allow for buffer
        } else {
            sword.release();

            if (holds.swing != 0) {
                justReleased = true;
            }

            holds.swing = 0;
        }

        var controlsPressed = {
            left: FlxG.keys.pressed.LEFT,
            right: FlxG.keys.pressed.RIGHT,
            up: FlxG.keys.pressed.UP,
            down: FlxG.keys.pressed.DOWN
        }

        lrVel = 0;
        udVel = 0;

        // if swinging, we have no vel.
        if (sword.state == Start || sword.state == Swing) {
            return;
        }

        var canTurn = false;
        if (sword.state == Hilt) {
            canTurn = true;
        }

        if (controlsPressed.left) {
            // if we just released the sword, or we just pressed a key
            if (justReleased || (holds.left == 0 && canTurn)) {
                facingDirs.contains(Left) ? null : facingDirs.unshift(Left);
            }

            lrVel = -1;
            holds.left += elapsed;
        } else {
            holds.left = 0;
            if (facingDirs.contains(Left)) {
                facingDirs.remove(Left);
            }
        }

        if (controlsPressed.right) {
            if (justReleased || (holds.right == 0 && canTurn)) {
                facingDirs.contains(Right) ? null : facingDirs.unshift(Right);
            }

            lrVel = 1;
            holds.right += elapsed;
        } else {
            holds.right = 0;
            if (facingDirs.contains(Right)) {
                facingDirs.remove(Right);
            }
        }

        if (controlsPressed.left && controlsPressed.right) {
            if (holds.right > holds.left) {
                lrVel = -1;
            } else {
                lrVel = 1;
            }
        }

        if (controlsPressed.up) {
            if (justReleased || (holds.up == 0 && canTurn)) {
                facingDirs.contains(Up) ? null : facingDirs.unshift(Up);
            }

            udVel = -1;
            holds.up += elapsed;
        } else {
            holds.up = 0;
            if (facingDirs.contains(Up)) {
                facingDirs.remove(Up);
            }
        }

        if (controlsPressed.down) {
            if (justReleased || (holds.down == 0 && canTurn)) {
                facingDirs.contains(Down) ? null : facingDirs.unshift(Down);
            }

            udVel = 1;
            holds.down += elapsed;
        } else {
            holds.down = 0;
            if (facingDirs.contains(Down)) {
                facingDirs.remove(Down);
            }
        }

        if (controlsPressed.up && controlsPressed.down) {
            if (holds.down > holds.up) {
                udVel = -1;
            } else {
                udVel = 1;
            }
        }

        facingDir = facingDirs[0] != null ? facingDirs[0] : facingDir;
    }
}
