package data;

enum Dir {
    Left;
    Right;
    Up;
    Down;
}

typedef Vec2 = {
    var x:Int;
    var y:Int;
}

typedef MinMax = {
    var min:Int;
    var max:Int;
}

class Utils {
    public static inline function randomVec2 (squareSize:Int):Vec2
        return { x: Math.floor(Math.random() * squareSize), y: Math.floor(Math.random() * squareSize) }

    public static inline function flipDir (dir:Dir)
        return switch (dir) {
            case Left: Right;
            case Right: Left;
            case Up: Down;
            case Down: Up;
        }

    public static function vecFromDir (vec2:Vec2, dir:Dir):Vec2
        return switch (dir) {
            case Left: { x: vec2.x - 1, y: vec2.y };
            case Right: { x: vec2.x + 1, y: vec2.y };
            case Up: { x: vec2.x, y: vec2.y - 1 };
            case Down: { x: vec2.x, y: vec2.y + 1 };
        }

    public static inline function shuffle<T> (array:Array<T>): Array<T> {
        var res = [];

        while (array.length > 0) {
            var pos = Math.floor(Math.random() * array.length);
            res.push(array.splice(pos, 1)[0]);
        }

        return res;
    }

    public static inline function randomInWindow (window:MinMax):Int
        return window.min + Math.round(Math.random() * (window.max - window.min));
}
