local allowEndShit = false

function onEndSong()
 if not allowEndShit and isStoryMode and not seenCutscene then
  setProperty('inCutscene', true);
  startDialogue('dialogueEnd', 'breakfast'); 
  allowEndShit = true;
  return Function_Stop;
 end
 return Function_Continue;
end