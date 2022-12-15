package;

import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.tweens.FlxEase;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.system.FlxSound;
import flixel.util.FlxStringUtil;
import openfl.utils.Assets as OpenFlAssets;
import lime.utils.Assets;
#if desktop
import Discord.DiscordClient;
#end
using StringTools;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;
//ALL CODE TAKE FROM DAVE AND BAMBI MODE. Thats how proggramers works
class FreeplayState extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];
	public var songText:Alphabet;

	var selector:FlxText;
	var curSelected:Int = 0;
	var curDifficulty:Int = 1;

	var bg:FlxSprite;

	var scoreBG:FlxSprite;
	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var lerpRating:Float = 0;
	var intendedScore:Int = 0;
	var intendedRating:Float = 0;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;
	private var curChar:String = "unknown";

	private var InMainFreeplayState:Bool = false;

	private var CurrentSongIcon:FlxSprite;

	private var AllPossibleSongs:Array<String> = ["normal", "errect"];

	private var CurrentPack:Int = 0;

	var loadingPack:Bool = false;
	var backdrops:FlxBackdrop;

	private var iconArray:Array<HealthIcon> = [];

	var seksName:String;
	public var emptySHIT:FlxSprite;


	var nbg_songs:FlxSprite;
	var split:FlxSprite;
	var ebg_songs:FlxSprite;
	var n_songs:FlxSprite;
	var e_songs:FlxSprite;

	var songColors:Array<FlxColor> = [
		0xFF000000,
		0xFF4965FF,//all ayko tan stuff
		0xFFFFFFFF,//myric color
		0xff4a34bb,//all ike stuff
		0xFF189429,//ye bambi
		0xff2e12b9,//nighmare
		0xffCf671b,//ATBS
		0xffDC143C,//REEEED
    ];

	override function create()
	{

		persistentUpdate = true;

		#if desktop
		DiscordClient.changePresence("In the Freeplay Menu", null);
		#end
		
		var isDebug:Bool = false;

		#if debug
		isDebug = true;
		#end

		bg = new FlxSprite().loadGraphic(Paths.image('menuBG'));
		bg.color = 0xFF4965FF;
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		backdrops = new FlxBackdrop(Paths.image('freeplay/grid'), 0.2, 0.2, true, true);
		backdrops.alpha = 0.1;
		backdrops.x -= 35;
		//add(backdrops);

		

		nbg_songs = new FlxSprite(-140,0).loadGraphic(Paths.image('freeplayStaff/n-bg'));
		nbg_songs.antialiasing = ClientPrefs.globalAntialiasing;
		add(nbg_songs);

		n_songs = new FlxSprite(-100,0);
		n_songs.frames = Paths.getSparrowAtlas('freeplayStaff/regular');
		n_songs.animation.addByPrefix('idle', "regular idle", 24, false);
		n_songs.animation.addByPrefix('select', "regular selected", 24, false);
		n_songs.animation.play('idle', true);
		n_songs.antialiasing = ClientPrefs.globalAntialiasing;
		n_songs.updateHitbox();
		add(n_songs);

		ebg_songs = new FlxSprite(-140,0).loadGraphic(Paths.image('freeplayStaff/m-bg'));
		ebg_songs.scale.set(1.2, 1.0);
		ebg_songs.antialiasing = ClientPrefs.globalAntialiasing;
		add(ebg_songs);

		e_songs = new FlxSprite(-100, 0);
		e_songs.frames = Paths.getSparrowAtlas('freeplayStaff/mental');
		e_songs.animation.addByPrefix('idle', "mental idle", 24, false);
		e_songs.animation.addByPrefix('select', "mental selected", 24, false);
		e_songs.animation.play('idle', true);
		e_songs.antialiasing = ClientPrefs.globalAntialiasing;
		e_songs.updateHitbox();
		add(e_songs);



		//split это полоска посредине
		split = new FlxSprite(-140,0).loadGraphic(Paths.image('freeplayStaff/split'));
		split.antialiasing = ClientPrefs.globalAntialiasing;
		split.updateHitbox();
		add(split);


		//CurrentSongIcon = new FlxSprite(0,0).loadGraphic(Paths.image('freeplay/freeplay_' + (AllPossibleSongs[CurrentPack].toLowerCase())));

		//CurrentSongIcon.centerOffsets(false);
		//CurrentSongIcon.x = (FlxG.width / 2) - 306;
		//CurrentSongIcon.y = (FlxG.height / 2) - 315;
		//CurrentSongIcon.antialiasing = true;

		//add(CurrentSongIcon);

		FlxG.camera.fade(FlxColor.BLACK, 0.5, true);
	}

	override function closeSubState() {
		changeSelection(0);
		persistentUpdate = true;
		super.closeSubState();
	}

	public function LoadProperPack()
		{
			switch (AllPossibleSongs[CurrentPack].toLowerCase())
			{
				case 'normal':
					addWeek(['dreams-of-funking'], 1, ['sally']);
					addWeek(['mom-knows-best'], 5, ['larry']);
					addWeek(['together'], 3, ['larry']);
					addWeek(['singular'], 3, ['sally']);
				case 'errect':
					addWeek(['singular-mental'], 3, ['larry']);
			}
		}


	public function GoToActualFreeplay()
	{
		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			songText = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false);
			songText.isMenuItem = true;
			//songText.x = 0;
			songText.targetY = i;
			grpSongs.add(songText);

			Paths.currentModDirectory = songs[i].folder;
			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;
			iconArray.push(icon);
			add(icon);
		}

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);
		scoreText.x = 750;

		scoreBG =  new FlxSprite(scoreText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 1), 66, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		add(diffText);

		add(scoreText);

		var textBG:FlxSprite = new FlxSprite(0, FlxG.height - 26).makeGraphic(FlxG.width, 26, 0xFF000000);
		textBG.alpha = 0.6;
		add(textBG);

		emptySHIT = new FlxSprite(0, 0).makeGraphic(FlxG.width, 1, 0xFF000000);
		emptySHIT.alpha = 0;

		
		#if PRELOAD_ALL
		var leText:String = "Press CTRL to open the fucking cheat menu.";
		var size:Int = 16;
		#else
		var leText:String = "Press CTRL to open the fucking cheat menu";
		var size:Int = 18;
		#end
		var text:FlxText = new FlxText(textBG.x, textBG.y + 4, FlxG.width, leText, size);
		text.setFormat(Paths.font("vcr.ttf"), size, FlxColor.WHITE, RIGHT);
		text.scrollFactor.set();
		text.screenCenter(X);
		add(text);
		
		changeSelection();
		changeDiff();

		var swag:Alphabet = new Alphabet(1, 0, "swag");
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter));
	}

	public function UpdatePackSelection(change:Int)
	{
		CurrentPack += change;
		if (CurrentPack == -1)

		{
			CurrentPack = AllPossibleSongs.length - 1;
			
			
		}
		if (CurrentPack == AllPossibleSongs.length)
		{
			CurrentPack = 0;
			
			
		}
		//CurrentSongIcon.loadGraphic(Paths.image('freeplay/freeplay_' + (AllPossibleSongs[CurrentPack].toLowerCase())));
	
		if (CurrentPack == 0)
		{
			e_songs.color = 0xFF565656;
			ebg_songs.color = 0xFF565656;
			n_songs.color = 0xFFFFFFFF;
			nbg_songs.color = 0xFFFFFFFF;
			FlxTween.tween(nbg_songs, {x: 0}, 0.5, {ease: FlxEase.cubeIn});
			FlxTween.tween(ebg_songs, {x: 0}, 0.5, {ease: FlxEase.cubeIn});
			FlxTween.tween(n_songs, {x: 80}, 0.5, {ease: FlxEase.cubeIn});
			FlxTween.tween(e_songs, {x: 80}, 0.5, {ease: FlxEase.cubeIn});
			FlxTween.tween(split, {x:0}, 0.5, {ease: FlxEase.cubeIn});
		}
		if (CurrentPack == 1)
		{
			n_songs.color = 0xFF565656;
			nbg_songs.color = 0xFF565656;
			e_songs.color = 0xFFFFFFFF;
			ebg_songs.color = 0xFFFFFFFF;
			FlxTween.tween(nbg_songs, {x: -280}, 0.5, {ease: FlxEase.cubeIn});
			FlxTween.tween(ebg_songs, {x: -280}, 0.5, {ease: FlxEase.cubeIn});
			FlxTween.tween(n_songs, {x: -280}, 0.5, {ease: FlxEase.cubeIn});
			FlxTween.tween(e_songs, {x: -280}, 0.5, {ease: FlxEase.cubeIn});
			FlxTween.tween(split, {x: -280}, 0.5, {ease: FlxEase.cubeIn});
		}
	}

	override function beatHit()
	{
		super.beatHit();
		FlxTween.tween(FlxG.camera, {zoom:1.05}, 0.3, {ease: FlxEase.quadOut, type: BACKWARD});
	}

	public function addWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['bf'];

		var num:Int = 0;
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num]);

			if (songCharacters.length != 1)
				num++;
		}
	}

	var instPlaying:Int = -1;
	private static var vocals:FlxSound = null;
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		backdrops.x -= .25*(elapsed/(1/120));
		backdrops.y += .25*(elapsed/(1/120));

		if (!InMainFreeplayState) 
		{
			if (controls.UI_LEFT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				UpdatePackSelection(-1);
				
			}
			if (controls.UI_RIGHT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				UpdatePackSelection(1);
				
			}
			if (controls.ACCEPT && !loadingPack)
			{
				loadingPack = true;
				LoadProperPack();
				//FlxTween.tween(CurrentSongIcon, {alpha: 0}, 0.3);
				if (CurrentPack == 0)
				{
					n_songs.animation.play('select', true);
				}
				if (CurrentPack == 1)
				{
					e_songs.animation.play('select', true);
				}
				FlxG.camera.flash(FlxColor.WHITE, 1);
				new FlxTimer().start(1.5, function(Dumbshit:FlxTimer)
				{
					FlxTween.tween(n_songs, {x: -920}, 1.1, {ease: FlxEase.cubeIn});
					FlxTween.tween(nbg_songs, {x: -920}, 1.1, {ease: FlxEase.cubeIn});
					FlxTween.tween(split, {x: -920}, 1.1, {ease: FlxEase.cubeIn});
					FlxTween.tween(ebg_songs, {x: 1280}, 1.1, {ease: FlxEase.cubeIn});
					FlxTween.tween(e_songs, {x: 1280}, 1.1, {ease: FlxEase.cubeIn, onComplete:
						function (twn:FlxTween)
						{
							GoToActualFreeplay();
							InMainFreeplayState = true;
							loadingPack = false;
						}});
				});
			}
			if (controls.BACK)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new MainMenuState());
				
			}	
		
			return;
		}

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, CoolUtil.boundTo(elapsed * 24, 0, 1)));
		lerpRating = FlxMath.lerp(lerpRating, intendedRating, CoolUtil.boundTo(elapsed * 12, 0, 1));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;
		if (Math.abs(lerpRating - intendedRating) <= 0.01)
			lerpRating = intendedRating;

		scoreText.text = 'PERSONAL BEST: ' + lerpScore + ' (' + Math.floor(lerpRating * 100) + '%)';


		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var accepted = controls.ACCEPT;
		var space = FlxG.keys.justPressed.SPACE;
		var ctrl = FlxG.keys.justPressed.CONTROL;
		

		if (upP)
		{

			changeSelection(-1);
		}
		if (downP)
		{

			changeSelection(1);
		}
		if (controls.UI_LEFT_P)
			changeDiff(-1);
		if (controls.UI_RIGHT_P)
			changeDiff(1);

		if(FlxG.keys.justPressed.CONTROL){
			{
				persistentUpdate = false;
				openSubState(new GameplayChangersSubstate());
			}
		}
		if (controls.BACK)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new FreeplayState());
				
	
			if (accepted)
			{					
				var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);
			
					trace(poop);
			
					PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
					PlayState.isStoryMode = false;
					PlayState.storyDifficulty = curDifficulty;
			
					PlayState.storyWeek = songs[curSelected].week;

					LoadingState.loadAndSwitchState(new PlayState());
			}
		if(FlxG.keys.justPressed.CONTROL)
			{
				persistentUpdate = false;
				openSubState(new GameplayChangersSubstate());
			}
		}
		
	#if PRELOAD_ALL
	if(space && instPlaying != curSelected){
	
		destroyFreeplayVocals();
		Paths.currentModDirectory = songs[curSelected].folder;
		var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);
		PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
		if (PlayState.SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();

		FlxG.sound.list.add(vocals);
		FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 0.7);
		vocals.play();
		vocals.persist = true;
		vocals.looped = true;
		vocals.volume = 0.7;
		instPlaying = curSelected;
	}
	else #end if (accepted)
	{
		var songLowercase:String = Paths.formatToSongPath(songs[curSelected].songName);
		var poop:String = Highscore.formatSong(songLowercase, curDifficulty);
		#if MODS_ALLOWED
		if(!sys.FileSystem.exists(Paths.modsJson(songLowercase + '/' + poop)) && !sys.FileSystem.exists(Paths.json(songLowercase + '/' + poop))) {
		#else
		if(!OpenFlAssets.exists(Paths.json(songLowercase + '/' + poop))) {
		#end
			poop = songLowercase;
			curDifficulty = 1;
			trace('Couldnt find file');
		}
		trace(poop);
		//Code I don’t know man you’ve been acting kinda sus lately
		//So i comment you
		//FlxTween.tween(songText, {x: -2900}, 2, {ease: FlxEase.cubeInOut});

		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

		FlxTween.tween(emptySHIT, {x: -900}, 1, {
			ease: FlxEase.backIn,
			onComplete: function(twn:FlxTween)
				{
					var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);
		
					trace(poop);
					
					PlayState.SONG = Song.loadFromJson(poop, songLowercase);
					PlayState.isStoryMode = false;
					PlayState.storyDifficulty = curDifficulty;
			
					PlayState.storyWeek = songs[curSelected].week;
			
					LoadingState.loadAndSwitchState(new PlayState());
			
					FlxG.sound.music.volume = 0;
			
					destroyFreeplayVocals();	
				}});
	}
	else if(controls.RESET)
	{
		openSubState(new ResetScoreSubState(songs[curSelected].songName, curDifficulty, songs[curSelected].songCharacter));
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}

	super.update(elapsed);
	}

	public static function destroyFreeplayVocals() {
		if(vocals != null) {
			vocals.stop();
			vocals.destroy();
		}
		vocals = null;
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = 1;
		if (curDifficulty > 1)
			curDifficulty = 0;
		
	
		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		intendedRating = Highscore.getRating(songs[curSelected].songName, curDifficulty);
		#end
	
		PlayState.storyDifficulty = curDifficulty;
		diffText.text = '< ' + CoolUtil.difficultyString() + ' >';
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		
		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;

		if (curSelected >= songs.length)
			curSelected = 0;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		intendedRating = Highscore.getRating(songs[curSelected].songName, curDifficulty);
		#end

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}

		iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;

			if (item.targetY == 0)
			{
				item.alpha = 1;
			}
		}
		changeDiff();
		FlxTween.color(bg, 0.25, bg.color, songColors[songs[curSelected].week]);
		FlxTween.color(backdrops, 0.25, backdrops.color, songColors[songs[curSelected].week]);

	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";
	public var folder:String = "";
	

	public function new(song:String, week:Int, songCharacter:String)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
		this.folder = Paths.currentModDirectory;
		if(this.folder == null) this.folder = '';
	}
}