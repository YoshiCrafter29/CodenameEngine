package funkin.scripting.events;

import funkin.game.Character;
import funkin.game.Note;

class NoteHitEvent extends CancellableEvent {
    @:dox(hide) public var animCancelled:Bool = false;
    @:dox(hide) public var strumGlowCancelled:Bool = false;
	@:dox(hide) public var noteSplashCancelled:Bool = false;
    @:dox(hide) public var deleteNote:Bool = true;
    @:dox(hide) public var unmuteVocals:Bool = true;
    @:dox(hide) public var enableCamZooming:Bool = true;
    @:dox(hide) public var autoHitLastSustain:Bool = true;

    /**
        Whenever a miss should be added.
    **/
    public var misses:Bool = true;
    /**
        Whenever a miss should be added.
    **/
    public var countAsCombo:Bool = true;
    /**
        Whenever ratings should be shown or not.
    **/
    public var showRating:Null<Bool> = null;
    /**
     * Note that has been pressed
     */
    public var note:Note;
    /**
     * Character that pressed the note
     */
    public var character:Character;
    /**
     * Whenever the Character is a player
     */
    public var player:Bool;
    /**
     * Note Type name (null if default note)
     */
    public var noteType:String;
    /**
     * Suffix of the animation. "-alt" for alt notes, "" for normal ones.
     */
    public var animSuffix:String;
    /**
     * Prefix of the rating sprite path. Defaults to "game/score/"
     */
    public var ratingPrefix:String;
    /**
     * Suffix of the rating sprite path.
     */
    public var ratingSuffix:String;
    /**
     * Direction of the press (0 = Left, 1 = Down, 2 = Up, 3 = Right)
     */
    public var direction:Int;
    /**
     * Score gained after note press.
     */
    public var score:Int;
    /**
     * Accuracy gained from pressing this note. From 0 to 1. null means no accuracy is gained.
     */
    public var accuracy:Null<Float>;
    /**
     * The amount of health that'll be gained from pressing that note. If called from `onPlayerMiss`, the value will be negative.
     */
    public var healthGain:Float;
    /**
     * Rating name. Defaults to "sick", "good", "bad" and "shit". Customisable.
     */
    public var rating:String = "sick";
    /**
     * Scale of ratings.
     */
    public var ratingScale:Float = 0.7;
    /**
     * Whenever antialiasing should be enabled on ratings.
     */
    public var ratingAntialiasing:Bool = true;
    /**
     * Scale of combo numbers.
     */
    public var numScale:Float = 0.5;
    /**
     * Whenever antialiasing should be enabled on combo number.
     */
    public var numAntialiasing:Bool = true;

    /**
     * Creates a new NoteHitEvent.
     */
    public function new(note:Note, character:Character, player:Bool, noteType:String,
        direction:Int, healthGain:Float, unmuteVocals:Bool = true, score:Int = 350,
        animSuffix:String = "", rating:String = "sick", ?accuracy:Null<Float>, ratingPrefix:String = "",
        ratingSuffix:String = "") {
        super();

        this.note = note;
        this.character = character;
        this.player = player;
        this.noteType = noteType;
        this.direction = direction;
        this.healthGain = healthGain;
        this.unmuteVocals = unmuteVocals;
        this.score = score;
        this.animSuffix = animSuffix;
        this.countAsCombo = !note.isSustainNote && note.mustPress;
        this.rating = rating;
        this.accuracy = accuracy;
        this.ratingPrefix = ratingPrefix;
        this.ratingSuffix = ratingSuffix;
    }

    /**
     * Prevents the default sing animation from being played.
     */
    public function preventAnim() {
        animCancelled = true;
    }

    @:dox(hide)
    public function cancelAnim() {preventAnim();}

    /**
     * Prevents note splash from being created, if any.
     */
    public function preventNoteSplash() {
        noteSplashCancelled = true;
    }

	/**
	 * Prevents the note from being deleted.
	 */
    public function preventDeletion() {
        deleteNote = false;
    }
    @:dox(hide)
    public function cancelDeletion() {preventDeletion();}

    /**
     * Prevents the vocals volume from being set to 1 after pressing the note.
     */
    public function preventVocalsUnmute() {
        unmuteVocals = false;
    }
    @:dox(hide)
    public function cancelVocalsUnmute() {preventVocalsUnmute();}

    /**
     * Prevents the vocals volume from being muted in case its a parameter of `onPlayerMiss`
     */
    public function preventVocalsMute() {
        unmuteVocals = true;
    }
    @:dox(hide)
    public function cancelVocalsMute() {preventVocalsMute();}

    /**
     * Prevents the camera zoom every 4 beats from enabling.
     */
    public function preventCamZooming() {
        enableCamZooming = false;
    }
    @:dox(hide)
    public function cancelCamZooming() {preventCamZooming();}
    
    /**
     * Prevents the sustain tail (the last one) from being automatically hit when the sustain before it is hit.
     */
    public function preventLastSustainHit() {
        autoHitLastSustain = false;
    }
    @:dox(hide)
    public function cancelLastSustainHit() {preventLastSustainHit();}
    
    /**
     * Prevents the strum from glowing after this note has been pressed.
     */
    public function preventStrumGlow() {
        strumGlowCancelled = true;
    }
    @:dox(hide)
    public function cancelStrumGlow() {preventStrumGlow();}
}