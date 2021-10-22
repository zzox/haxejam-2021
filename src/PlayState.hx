package;

import data.FloorMap;
import data.Game;
import data.Towers;
import data.Utils;
import display.Hud;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.group.FlxGroup;
import flixel.tile.FlxBaseTilemap.FlxTilemapAutoTiling;
import flixel.tile.FlxTilemap;
import flixel.tweens.FlxTween;
import maps.MapUtils;
import objects.Player;

typedef Room = {
    var walls:FlxTypedGroup<FlxTilemap>;
    var enemies:Array<FlxSprite>;
}

class PlayState extends FlxState {
    static final MOVE_ROOM_TIME = 0.66;
    static final HUD_HEIGHT = 16;
    static final ROOM_SIZE = { width: 192, height: 144 };
    static final DIRS = [Left, Right, Up, Down];

    var rooms:Array<Array<Room>>;
    var currentRoomVec:Vec2;
    var player:Player;
    var actors:FlxGroup;
    var endItem:FlxSprite;

    public var movingRoom:Bool = false;

    override public function create() {
        super.create();

        camera.pixelPerfectRender = true;
        bgColor = 0xff073642;

        trace(Game.inst.floor);
        final tower = Towers.data[Game.inst.tower];
        final size = tower.size;
        final map = new FloorMap(size);
        map.generate(Game.inst.startVec);

        // make player, add after floors
        player = new Player(0, 0, this);

        // actor group, combined with player to have y depth sorting
        actors = new FlxGroup();

        rooms = [];
        for (x in 0...size) {
            final row = [];

            for (y in 0...size) {
                final room = map.getRoom({ x: x, y: y });
                final walls = new FlxTypedGroup<FlxTilemap>();

                final roomTilemap = new TiledMap(AssetPaths.room_empty_1__tmx);
                // floor
                add(createTileLayer(roomTilemap, 'ground', { x: x * ROOM_SIZE.width, y: y * ROOM_SIZE.height }));
                // collidable items
                walls.add(createTileLayer(roomTilemap, 'walls', { x: x * ROOM_SIZE.width, y: y * ROOM_SIZE.height }));

                // TODO: add item squares positions to Room obj
                final roomItems = Utils.shuffle(getRoomItems(roomTilemap));

                if (room.end) {
                    final endItemPos = roomItems.shift();

                    endItem = new FlxSprite(endItemPos.x, endItemPos.y);
                    endItem.loadGraphic(AssetPaths.ladder__png);
                    endItem.offset.set(7, 7);
                    endItem.setSize(2, 2);
                    actors.add(endItem);
                }

                // add open or closed walls
                for (dir in DIRS) {
                    final mapUri = MapUtils.getMapByType(dir, room.connects.contains(dir));
                    final tileMap = new TiledMap(mapUri);

                    final chunkPos = MapUtils.mapChunkPositionFromDir[dir];

                    final mapTiles = createTileLayer(tileMap, 'walls', { x: x * ROOM_SIZE.width + chunkPos.x, y: y * ROOM_SIZE.height + chunkPos.y });

                    walls.add(mapTiles);
                }

                if (room.start) {
                    player.setPosition(x * ROOM_SIZE.width + 100, y * ROOM_SIZE.height + 80);
                    currentRoomVec = { x: x, y: y };
                }

                row.push({ walls: walls, itemPositions: roomItems, enemies: [] });
                add(walls);
            }

            rooms.push(row);
        }

        actors.add(player);
        add(actors);
        add(player.sword);

        add(new Hud());

        setBounds();
        FlxG.camera.scroll.set(currentRoomVec.x * ROOM_SIZE.width, currentRoomVec.y * ROOM_SIZE.height - HUD_HEIGHT);
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);

        final currentRoom = rooms[currentRoomVec.x][currentRoomVec.y];

        if (!movingRoom) {
            FlxG.collide(currentRoom.walls, player);
            checkExits();
        }
    }

    function exitRoom (dir:Dir) {
        final playerPos = { x: player.x, y: player.y };
        final cameraPos = { x: FlxG.camera.scroll.x, y: FlxG.camera.scroll.y }

        switch (dir) {
            case Left:
                playerPos.x -= 12;
                cameraPos.x -= ROOM_SIZE.width;
                currentRoomVec.x--;
            case Right:
                playerPos.x += 12;
                cameraPos.x += ROOM_SIZE.width;
                currentRoomVec.x++;
            case Up:
                playerPos.y -= 18;
                cameraPos.y -= ROOM_SIZE.height;
                currentRoomVec.y--;
            case Down:
                playerPos.y += 18;
                cameraPos.y += ROOM_SIZE.height;
                currentRoomVec.y++;
        }

        FlxTween.tween(player, playerPos, MOVE_ROOM_TIME, { onComplete: setBounds });
        FlxTween.tween(FlxG.camera.scroll, cameraPos, MOVE_ROOM_TIME);

        movingRoom = true;
    }

    function checkExits () {
        FlxG.overlap(player, endItem, nextFloor);

        if (player.x < currentRoomVec.x * ROOM_SIZE.width) {
            exitRoom(Left);
            return;
        }

        if (player.x + player.width > currentRoomVec.x * ROOM_SIZE.width + ROOM_SIZE.width) {
            exitRoom(Right);
            return;
        }

        if (player.y < currentRoomVec.y * ROOM_SIZE.height) {
            exitRoom(Up);
            return;
        }

        if (player.y + player.height > currentRoomVec.y * ROOM_SIZE.height + ROOM_SIZE.height) {
            exitRoom(Down);
            return;
        }
    }

    function nextFloor (_p:Player, _d:FlxSprite) {
        Game.inst.nextLevel(currentRoomVec);
        FlxG.switchState(new PlayState());

        // TODO: Pause movement
        // TODO: timer for next level
        // TODO: curtains
    }

    // TODO: change to room set function
    // activate physics, enemies, etc.
    function setBounds (?_:FlxTween) {
        movingRoom = false;
        final x = currentRoomVec.x * ROOM_SIZE.width;
        final y = currentRoomVec.y * ROOM_SIZE.height;
        FlxG.worldBounds.set(x, y, ROOM_SIZE.width, ROOM_SIZE.height);
    }

    // can maybe `cast` better
    function getRoomItems (map:TiledMap):Array<Vec2> {
        final items = cast(map.getLayer('items'), TiledObjectLayer).objects;
        return items.map(item -> {
            return {
                x: item.x,
                y: item.y
            };
        });
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
