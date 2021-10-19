package;

import data.FloorMap;
import data.Utils;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tile.FlxBaseTilemap.FlxTilemapAutoTiling;
import flixel.tile.FlxTilemap;
import maps.MapUtils;
import objects.Player;

typedef Room = {
    var maps:FlxTilemap;
    var enemies:Array<FlxSprite>;
}

class PlayState extends FlxState {
    static final ROOM_SIZE = { width: 192, height: 144 };
    var walls:FlxTypedGroup<FlxTilemap>;

    var player:Player;

    override public function create() {
        super.create();

        camera.pixelPerfectRender = true;
        bgColor = 0xff002b36;

        player = new Player(0, 0);
        add(player);

        // MD:
        final size = 2;
        final map = new FloorMap(size);
        map.generate();

        walls = new FlxTypedGroup<FlxTilemap>();

        final dirs = [Left, Right, Up, Down];
        for (x in 0...size) {
            for (y in 0...size) {
                final room = map.getRoom({ x: x, y: y });

                // add open or closed walls
                for (dir in dirs) {
                    final mapUri = MapUtils.getMapByType(dir, room.connects.contains(dir));
                    final tileMap = new TiledMap(mapUri);

                    final chunkPos = MapUtils.mapChunkPositionFromDir[dir];

                    final mapTiles = createTileLayer(tileMap, 'walls', { x: x * ROOM_SIZE.width + chunkPos.x, y: y * ROOM_SIZE.height + chunkPos.y });
                    walls.add(mapTiles);
                }

                if (room.start) {
                    player.setPosition(x * ROOM_SIZE.width + 100, y * ROOM_SIZE.height + 80);
                }
            }
        }

        add(walls);

        FlxG.camera.follow(player);
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);
        FlxG.collide(walls, player);
    }

    function createTileLayer (map:TiledMap, layerName:String, pos:Vec2):Null<FlxTilemap> {
        var layerData = map.getLayer(layerName);
        if (layerData != null) {
            var layer = new FlxTilemap();
            layer.loadMapFromArray(cast(layerData, TiledTileLayer).tileArray, map.width, map.height,
                AssetPaths.tiles__png, map.tileWidth, map.tileHeight, FlxTilemapAutoTiling.OFF, 1, 1, 1)
                .setPosition(pos.x, pos.y);

            layer.useScaleHack = false;
            add(layer);

            return layer;
        }
        return null;
    }
}
