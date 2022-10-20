package funkin.scripting.events;

import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.system.FlxSound;

class CountdownEvent extends CancellableEvent {
    /**
     * At which count the countdown is. Normally goes 0-1-2-3-4 unless `PlayState.instance.introLength` is changed.
     */
    public var swagCounter:Int;
    /**
     * Volume at which the intro countdown sound will play.
     */
    public var volume:Float;
    /**
     * Path of the intro sound that'll be played.
     */
    public var soundPath:String;
    /**
     * Path to the sprite path that'll be shown.
     */
    public var spritePath:String;
    /**
     * Scale of the sprite.
     */
    public var scale:Float;
    /**
     * Whenever antialiasing is enabled or not.
     */
    public var antialiasing:Bool;


    /**
     * Created sprite, only available in `onCountdownPost`
     */
    public var sprite:FlxSprite;
    /**
     * Created tween for the sprite, only available in `onCountdownPost`
     */
    public var spriteTween:FlxTween;
    /**
     * Created sound, only available in `onCountdownPost`
     */
    public var sound:FlxSound;

    public function new(spritePath:String, soundPath:String, scale:Float = 1, volume:Float = 1, antialiasing:Bool = true) {
        super();
        this.volume = volume;
        this.soundPath = soundPath;
        this.spritePath = spritePath;
        this.scale = scale;
        this.antialiasing = antialiasing;
    }
}