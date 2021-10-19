package maps;

import data.Utils;

class MapUtils {
    public static final mapChunkPositionFromDir:Map<Dir, Vec2> = [
        Left => { x: 0, y: 16 },
        Right => { x: 176, y: 16 },
        Up => { x: 0, y: 0 },
        Down => { x: 0, y: 128 },
    ];

    public static inline function getMapByType (dir:Dir, open:Bool): String
        return switch (dir:Dir) {
            case Left: open ? AssetPaths.left_open__tmx : AssetPaths.left_closed__tmx;
            case Right: open ? AssetPaths.right_open__tmx : AssetPaths.right_closed__tmx;
            case Up: open ? AssetPaths.up_open__tmx : AssetPaths.up_closed__tmx;
            case Down: open ? AssetPaths.down_open__tmx : AssetPaths.down_closed__tmx;
        }
}
