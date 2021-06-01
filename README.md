MarioLANG2
============

Modified version of [MarioLANG](http://esolangs.org/wiki/MarioLANG) written in Ruby

## Extra Features
Now you can print strings easier. Use * to start recording a string, and all characters Mario runs into after that, (excluding ]) will be  
recorded into current string memory. Use ] to stop recording.  
Note, because only ] instruction works while recording, you can not stop, use elevator, turn around Mario, etc. while recording.  
Use $ instruction to print current string in memory.  
If you want to print new string you must clear current string in memory with % first.  
If not recording, characters still do nothing so you can use them like comments.
