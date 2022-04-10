%% AnalyzeWords.m
% Generates rankings of five letter words for Wordle
%
% Written by Keith A. Brown 2/2022
% brownka@gmail.com

%% load in data
% note that this can a while due to the nexted for loops

clear all
close all
clc

letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
words = importdata('words.txt');
words = cell2mat(words);

numwords = size(words,1);

% pre-calculate all possible results of guessing 'guess' when the true
% answer is 'answer'. Here, this WordleResult is stored as a base-3 number
% so the five digit wordle result can be stored as a single number
WordleResult = zeros(numwords,numwords);

for i=1:size(words,1)
    guess = words(i,:);
    for j=1:size(words,1)
        answer = words(j,:);
        pattern = WordlePattern(guess,answer);
        WordleResult(i,j) = pattern(1)+3*pattern(2)+9*pattern(3)+27*pattern(4)+81*pattern(5);
    end
end

clear answer guess i j pattern
save WordleData.mat






%% Compute the abundance of each letter and then compute the rank of words based upon how abundant each letter is

load WordleData.mat
LetterAbundance = zeros(size(letters));

for i=1:length(words)
    temp = words(i,:);
    for j=1:5
        ind = find(temp(j)==letters);
        LetterAbundance(ind) = LetterAbundance(ind)+1;
    end
end

LetterAbundanceScore = zeros(size(words,1),1);

for i=1:size(words,1)
    temp = words(i,:);
    for j=1:5
        ind = find(temp(j)==letters);
        LetterAbundanceScore(i)=LetterAbundanceScore(i)+LetterAbundance(ind);
    end
end

save LetterAbundanceScore.mat LetterAbundanceScore







%% Compute the value of each word based on how many words it can eliminate

load WordleData.mat

% We wish to compute how many words could be elimated if we guess i. This
% is computed for all possible true answers k
EliminationScore = zeros(length(words),1);


% go through all possible guesses that a user could enter
for i=1:length(words)

    %for each guess, go through all possible words to see if they could be
    %elimated
    ruledout = zeros(length(words),1);
    for j=1:length(words)

        %to see if they were eliminated, we must what the response between
        %the guess and the true answer is
        for k=1:length(words)
            if  ~(WordleResult(i,j)==WordleResult(i,k))
               ruledout(j) = ruledout(j)+1; 
            end
        end
    end
    EliminationScore(i) = mean(ruledout);
    fprintf([num2str(i),' out of ',num2str(size(words,1)),' done\n'])
end

save EliminationScore.mat EliminationScore







%% Compute the value of each word based on how many words it can eliminate

load WordleData.mat

EntropyScore = zeros(size(words,1),1);

% here, the value of each word is determined by how nany unique patterns
% could emerge from a given guess
for i=1:size(words,1)
    EntropyScore(i) = length(unique(WordleResult(i,:)));
end

save EntropyScore.mat EntropyScore







%% plot word scores

load EntropyScore.mat
load EliminationScore.mat
load LetterAbundanceScore.mat

figure(1)
plot(sort(EliminationScore,'descend')./max(EliminationScore),'.','LineWidth',4,'Color',[99/255 75/255 235/255],'MarkerSize',20);
hold on
plot(sort(EntropyScore,'descend')./max(EntropyScore),'.','LineWidth',4,'Color',[235/255 166/255 56/255],'MarkerSize',20);
plot(sort(LetterAbundanceScore,'descend')./max(LetterAbundanceScore),'.','LineWidth',4,'Color',[65/255 235/255 197/255],'MarkerSize',20);
axis([0 12500 0 1])
set(gca,'LineWidth',3,'XColor','k','YColor','k','FontSize',22,'Layer','top','XTick',0:2500:12500)
xlabel('Word','FontSize',24)
ylabel('Value','FontSize',24)
set(gcf,'Position',[1 1 600 500])
legend('Words eliminated','Unique outcomes','Letter abundance')


