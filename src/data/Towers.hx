package data;

import data.Utils;

enum TowerType {
    SysTower;
    IoTower;
    LambdaTower;
    RemoteTower;
}

typedef Tower = {
    var size:Int;
    var roomTypes:Array<String>;
    var enemyTypes:Array<String>; // TODO: enemy type in enum
    var fullnessWindow:MinMax;
    // TODO: room fullness window (-1 when a floor end is in there)
}

class Towers {
    public static final data:Map<TowerType, Tower> = [
        SysTower => {
            size: 2,
            roomTypes: [],
            enemyTypes: [],
            fullnessWindow: { min: 1, max: 2 }
        }
    ];
}
