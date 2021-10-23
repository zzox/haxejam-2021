package data;

import data.Utils;

typedef RoomPlan = {
    var x:Int;
    var y:Int;
    var connects:Array<Dir>;
    var start:Bool;
    var end:Bool;
    var ?depth:Int;
}

class FloorMap {
    var rooms:Array<Array<RoomPlan>>;
    var size:Int;
    var minLength:Int;
    var endFound:Bool;

    public function new (size:Int) {
        this.size = size;
        minLength = Math.floor(Math.pow(size, 2) / 2); // is this accurate? 
        rooms = [];

        // gen 2d array
        for (x in 0...size) {
            final column = [];

            for (y in 0...size) {
                column.push({ start: false, end: false, x: x, y: y, connects: [] });
            }

            rooms.push(column);
        }
    }

    public function generate(startingVec2:Null<Vec2>) {
        var vec: Vec2 = startingVec2 != null ? startingVec2 : Utils.randomVec2(size);
        expandRoom(vec, 0);
    }

    // create the stats for this room.
    function expandRoom (roomVec2:Vec2, depth:Int) { 
        final curRoom:RoomPlan = rooms[roomVec2.x][roomVec2.y];
        curRoom.depth = depth;
        curRoom.start = depth == 0;

        // shuffle room exits
        final roomExits = Utils.shuffle([Left, Right, Up, Down]);
        final exitableExits = roomExits.filter(roomExit -> {
            final exitVec = Utils.vecFromDir({ x: curRoom.x, y: curRoom.y }, roomExit);
            final room = getRoom(exitVec);
            return room != null && room.depth == null;
        });

        // exits that we can maybe connect to
        final potentialExits = roomExits.filter(roomExit -> {
            final exitVec = Utils.vecFromDir({ x: curRoom.x, y: curRoom.y }, roomExit);
            return getRoom(exitVec) != null;
        });

        // chance to skip after the length
        final skipExit = exitableExits.length > 0 && Math.random() < size * 0.2;

        // tag the ending room
        if (depth >= minLength && !endFound && !skipExit) {
            curRoom.end = true;
            endFound = true;
        }

        for (exit in potentialExits) {
            final exitVec = Utils.vecFromDir({ x: curRoom.x, y: curRoom.y }, exit);
            var exitRoom = getRoom(exitVec);

            // if the room hasn't been gotten to, go to it.
            if (exitRoom.depth == null) {
                final nextRoom = getRoom({ x: exitRoom.x, y: exitRoom.y });
                // create exits from both sides.
                curRoom.connects.push(exit);
                nextRoom.connects.push(Utils.flipDir(exit));

                // recurse
                expandRoom({ x: exitRoom.x, y: exitRoom.y }, ++depth);
            } else {
                // TODO: connect to already gotten rooms only if good enough chance and not the end????
                // final potentialNextRoom = getRoom({ x: exitRoom.x, y: exitRoom.y });
                // if (depth + potentialNextRoom.depth < Math.pow(minLength, 2) && Math.random() < 0.5) {
                //     // create exits from both sides.
                //     curRoom.connects.push(exit);
                //     potentialNextRoom.connects.push(Utils.flipDir(exit));
                // }
            }

        }
    }

    public function getRoom (vec2:Vec2): Null<RoomPlan> {
        if (vec2.x < 0 || vec2.x >= size || vec2.y < 0 || vec2.y >= size) {
            return null;
        }

        return rooms[vec2.x][vec2.y];
    }

    public function isRoomOnEdge(room:Vec2):Bool
        return room.x == 0 || room.x == size || room.y == 0 || room.y == size;
}