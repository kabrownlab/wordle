# WordleBot

These files were uploaded to partner with a manuscript I've written on how to learn about active learning using the world game Wordle.

These will run in matlab and were tested in MATLAB Version: 9.6.0.1174912 (R2019a) Update 5.

First, you must run AnalyzeWords.m to generate some .mat files that store information about the words in the word list. I've included a word list that corresponds to 12,478 English five letter words, but this should be compatible with any list of words in the format given in the 'words.txt' file. On my laptop, generating this file takes 3-4 hours. 

Once WordleData.mat has been generated, you will be able to run 'PlayWordle.m'. This can be run in two ways, either by specifying a word and watching the WordleBot trying to sovle it or by not specifying a word (i.e. using [] for the second input) and the WordleBot will ask you to provide responses.

In order to evaluate a strategy more generally, 'PlayAllGames.m' can be run that goes through all possible words and tabulates how a given strategy does. 

The strategies I've coded in are:
% 0 - Random Selection
% 1 - Value words based on letter abundance
% 2 - Value words based on how many words they can elimate
% 3 - Value words based on how many unique patterns they produce

The final file, 'WordlePattern.m' is a subroutine that takes two words (i.e. guess and answer) and produces the resulting wordle pattern. 

Enjoy!
Keith A. Brown
brownka@gmail.com
