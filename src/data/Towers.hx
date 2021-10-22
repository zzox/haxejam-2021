package data;

enum TowerType {
    SysTower;
    IoTower;
    LambdaTower;
    RemoteTower;
}

typedef Tower = {
    var size:Int;
    var roomTypes: Array<String>;
    var enemyTypes: Array<String>; // TODO: enemy type in enum
    // TODO: room fullness window (-1 when a end is in there)
}

class Towers {
    public static final data:Map<TowerType, Tower> = [
        SysTower => {
            size: 2,
            roomTypes: [],
            enemyTypes: []
        }
    ];
}
