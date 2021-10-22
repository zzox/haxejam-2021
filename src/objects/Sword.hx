package objects;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;

enum abstract SwordStage(String) to String {
    var Hilt;
    var Start;
    var Swing;
    var Hold;
}

class Sword extends FlxGroup {
    //MD:?
    static inline final SWING_TIME = 1;
    static inline final START_SWING_TIME = .5;

    var parent:Player;
    public var state:SwordStage;
    var swingTime:Float = 0;
    var swordSprite:FlxSprite;
    var swingSprite:FlxSprite;
    var released:Bool = true;

    public function new (parent:Player) {
        super();

        this.parent = parent;

        swordSprite = new FlxSprite();
        swordSprite.loadGraphic(AssetPaths.sword__png, true, 16, 16);
        swordSprite.animation.add(Start, [0]);
        swordSprite.animation.add(Swing, [1]);
        swordSprite.animation.add(Hold, [2]);
        swingSprite = new FlxSprite();
        swingSprite.makeGraphic(12, 12);
        // swingSprite.visible = false; // always invisible
        add(swordSprite);
        add(swingSprite);

        hiltSword();

        FlxG.debugger.track(swordSprite);
    }

    override function update (elapsed:Float) {
        super.update(elapsed);

        if (state != Hilt) {
            swingTime -= elapsed;
            setSwordPosition();

            if (swingTime < 0) {
                state = Hold;
                if (released) {
                    hiltSword();
                }
            } else if (swingTime < SWING_TIME - START_SWING_TIME) {
                state = Swing;
            }
        }
    }

    public function swing () {
        if (state == Hilt) {
            released = false;
            state = Start;
            swordSprite.visible = true;
            swingTime = SWING_TIME;
        }
    }

    public function release () {
        released = true;
        swingSprite.active = false;
    }

    function hiltSword () {
        swordSprite.visible = false;
        state = Hilt;
    }

    // big ugly
    function setSwordPosition () {
        switch (parent.facingDir) {
            case Left:
                swordSprite.angle = 0;
                swordSprite.flipX = false;
                if (state == Start) {
                    swordSprite.setPosition(parent.x, parent.y - 12);
                    swordSprite.offset.set(11, 1);
                    swordSprite.setSize(3, 16);
                    swingSprite.active = false; // does this do anything?
                } else if (state == Swing) {
                    swordSprite.setPosition(parent.x - 16, parent.y + 6);
                    swordSprite.offset.set(0, 11);
                    swordSprite.setSize(16, 3);
                    swingSprite.setPosition(parent.x - 14, parent.y - 6);
                    swingSprite.setSize(14, 12);
                    swingSprite.active = true;
                } else if (state == Hold) {
                    // sword sprite size carries over
                    swordSprite.setPosition(parent.x - 16, parent.y + 6);
                    swingSprite.active = false;
                }
            case Right:
                swordSprite.angle = 0;
                swordSprite.flipX = true;
                if (state == Start) {
                    swordSprite.setPosition(parent.x + 5, parent.y - 12);
                    swordSprite.offset.set(2, 1);
                    swordSprite.setSize(3, 16);
                    swingSprite.active = false;
                } else if (state == Swing) {
                    swordSprite.setPosition(parent.x + 8, parent.y + 6);
                    swordSprite.offset.set(0, 11);
                    swordSprite.setSize(16, 3);
                    swingSprite.setPosition(parent.x + 8, parent.y - 6);
                    swingSprite.setSize(14, 12);
                    swingSprite.active = true;
                } else if (state == Hold) {
                    swordSprite.setPosition(parent.x + 8, parent.y + 6);
                    swingSprite.active = false;
                }
            case Up:
                swordSprite.angle = 270;
                swordSprite.flipX = true;
                if (state == Start) {
                    swordSprite.setPosition(parent.x - 12, parent.y);
                    swordSprite.offset.set(1, 11);
                    swordSprite.setSize(16, 3);
                    swingSprite.active = false;
                } else if (state == Swing) {
                    swordSprite.setPosition(parent.x + 6, parent.y - 16);
                    swordSprite.offset.set(11, 0);
                    swordSprite.setSize(3, 16);
                    swingSprite.setPosition(parent.x - 6, parent.y - 14);
                    swingSprite.setSize(12, 14);
                    swingSprite.active = true;
                } else if (state == Hold) {
                    swordSprite.setPosition(parent.x + 6, parent.y - 16);
                    swingSprite.active = false;
                }
            case Down:
                swordSprite.angle = 270;
                swordSprite.flipX = false;
                if (state == Start) {
                    swordSprite.setPosition(parent.x - 12, parent.y + 9);
                    swordSprite.offset.set(1, -1);
                    swordSprite.setSize(16, 3);
                    swingSprite.active = false;
                } else if (state == Swing) {
                    swordSprite.setPosition(parent.x + 6, parent.y + 12);
                    swordSprite.offset.set(11, 0);
                    swordSprite.setSize(3, 16);
                    swingSprite.setPosition(parent.x - 6, parent.y + 12);
                    swingSprite.setSize(12, 14);
                    swingSprite.active = true;
                } else if (state == Hold) {
                    swordSprite.setPosition(parent.x + 6, parent.y + 12);
                    swingSprite.active = false;
                }

        }

        swordSprite.animation.play(state);
    }
}
