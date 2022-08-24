package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class DialogueBoxCool extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;
	var swagDialogue2:FlxTypeText;

	var dropText:FlxText;
	var dropText2:FlxText;

	var nameLoL:FlxText;

	public var finishThing:Void->Void;
	public var nextDialogueThing:Void->Void = null;
	public var skipDialogueThing:Void->Void = null;

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		//switch (PlayState.SONG.song.toLowerCase())
		//{
		//	default:
		//		FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
		//		FlxG.sound.music.fadeIn(1, 0, 0.8);
		//}

		box = new FlxSprite(140, 390);
		
		var hasDialog = false;

		switch (PlayState.SONG.song.toLowerCase())
		{
			default:
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('speech_bubble');
				//box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'speech bubble normal', [4], "", 24);
		}

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;
		
		/*
		portraitLeft = new FlxSprite(-20, 40);
		portraitLeft.frames = Paths.getSparrowAtlas('weeb/senpaiPortrait');
		portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
		portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
		portraitLeft.updateHitbox();
		portraitLeft.scrollFactor.set();
		add(portraitLeft);
		portraitLeft.visible = false;

		portraitRight = new FlxSprite(0, 40);
		portraitRight.frames = Paths.getSparrowAtlas('weeb/bfPortrait');
		portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
		portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
		portraitRight.updateHitbox();
		portraitRight.scrollFactor.set();
		add(portraitRight);
		portraitRight.visible = false;

		box.screenCenter(X);
		portraitLeft.screenCenter(X);

		handSelect = new FlxSprite(1042, 590).loadGraphic(Paths.image('weeb/pixelUI/hand_textbox'));
		handSelect.setGraphicSize(Std.int(handSelect.width * PlayState.daPixelZoom * 0.9));
		handSelect.updateHitbox();
		handSelect.visible = false;
		add(handSelect);

		*/

		box.frames = Paths.getSparrowAtlas('speech_bubble');
		box.animation.addByPrefix('normal', 'speech bubble normal', 24, false);
		box.animation.play('normal');
		box.setGraphicSize(Std.int(box.width * 0.8));
		box.updateHitbox();
		add(box);



		if (!talkingRight)
		{
			// box.flipX = true;
		}

		dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
		dropText.font = 'ConsertaC';
		dropText.color = 0xFFFFFFFF;
		dropText.visible = false;
		add(dropText);

		swagDialogue = new FlxTypeText(220, 540, Std.int(FlxG.width * 0.7), "", 48);
		swagDialogue.font = 'ConsertaC';
		swagDialogue.color = 0xFFFFFFFF;
		//swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		add(swagDialogue);

		nameLoL = new FlxText(220, 490, Std.int(FlxG.width * 0.6), "", 42);
		nameLoL.font = 'ConsertaC';
		nameLoL.color = 0xFFFFFFFF;
		add(nameLoL);

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;
	var dialogueEnded:Bool = false;

	override function update(elapsed:Float)
	{
		// HARD CODING CUZ IM STUPDI
		/*
		if (PlayState.SONG.song.toLowerCase() == 'roses')
			portraitLeft.visible = false;
		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitLeft.visible = false;
			swagDialogue.color = FlxColor.WHITE;
			dropText.color = FlxColor.BLACK;
		}
		*/

		dropText.text = swagDialogue.text;
		
		nameLoL.text = curCharacter;

		switch(curCharacter)
		{
			case 'BF':
				nameLoL.color = 0xFF0028C8;
			case 'Sally':
				nameLoL.color = 0xFF00DDFF;
			case 'Larry':
				nameLoL.color = 0xFFBB5A00;
		}

		if (!dialogueStarted)
			{
				startDialogue();
				dialogueStarted = true;
			}

		if(PlayerSettings.player1.controls.ACCEPT)
		{
			if (dialogueEnded)
			{
				remove(dialogue);
				if (dialogueList[1] == null && dialogueList[0] != null)
				{
					if (!isEnding)
					{
						isEnding = true;
						FlxG.sound.play(Paths.sound('clickText'), 0.8);	

						//if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns')
						//	FlxG.sound.music.fadeOut(1.5, 0);
						
						new FlxTimer().start(0.2, function(tmr:FlxTimer)
						{
							box.alpha -= 0.1;
							swagDialogue.alpha -= 0.1;
							//handSelect.alpha -= 1 / 5;
							nameLoL.alpha -= 0.1;
							dropText.alpha = swagDialogue.alpha;
						}, 5);
						

						new FlxTimer().start(1.1, function(tmr:FlxTimer)
						{
							finishThing();
							kill();
						});
					}
				}
				else
				{
					dialogueList.remove(dialogueList[0]);
					startDialogue();
					FlxG.sound.play(Paths.sound('clickText'), 0.8);
				}
			}
			else if (dialogueStarted)
			{
				FlxG.sound.play(Paths.sound('clickText'), 0.8);
				swagDialogue.skip();
				
				if(skipDialogueThing != null) {
					skipDialogueThing();
				}
			}
		}
		
		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);
		swagDialogue.completeCallback = function() {
			//handSelect.visible = true;
			dialogueEnded = true;
		};

		//handSelect.visible = false;
		dialogueEnded = false;
		if(nextDialogueThing != null) {
			nextDialogueThing();
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
}
