package data;

import data.Towers;
import data.Utils;

class Game {
    public static final inst:Game = new Game();
    public var floor:Int;
    public var tower:TowerType;
    public var startVec:Null<Vec2>;
    public var levelsCleared:Int;

    public function new () {
        levelsCleared = 0;
    }

    public function newGame (tower:TowerType) {
        this.tower = tower;
        floor = 0;
        startVec = null;
    }

    public function nextLevel (startVec:Vec2) {
        floor++;
        this.startVec = startVec;
    }

    public function quitGame () {}
}
