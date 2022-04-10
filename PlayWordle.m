function guesses = PlayWordle(strategy,answer)
% function PlayWordle(strategy)
%
% Have WordleBot play a game of Wordle with a selected strategy
% 0 - Random Selection
% 1 - Value words based on letter abundance
% 2 - Value words based on how many words they can elimate
% 3 - Value words based on how many unique patterns they produce
% if answer = 'WORDS', this will proceed automatically
% if answer = [] it will wait for user input

load WordleData.mat

fprintf('\n****Time to play some Wordle!****\n');

switch strategy
    case 0 
        index = ceil(rand.*size(words,1));
        fprintf(['WordleBot: I am going to guess randonly\n']);
    case 1
        load LetterAbundanceScore.mat
        fprintf('WordleBot: I am going to guess based on letter abundance\n');
        [~,index] = max(LetterAbundanceScore);      
    case 2
        load EliminationScore.mat
        fprintf('WordleBot: I am going to guess based on how many words each word can eliminate\n');
        [~,index] = max(EliminationScore);
    case 3
        load EntropyScore.mat
        fprintf('WordleBot: I am going to guess based on how many unique outcomes each guess could have\n');
        [~,index] = max(EntropyScore);
    otherwise
        fprintf('WordleBot: I do not recognize that strategy. choose 0, 1, 2, or 3.\n') 
        return
end

guesses = 0;

while size(words,1)>0

    guess = words(index,:);

    if isempty(answer)
        fprintf(['WordleBot: Ok - try <',guess,'> and let me know how it goes\n']);
        templatePattern = input('result = ');
        fprintf('\n')
    else
        fprintf(['WordleBot: I have chosen <',guess,'> and will let you know how it went\n']);
        templatePattern = WordlePattern(guess,answer); 
        fprintf(['WordleBot: The result is: ',num2str(templatePattern(1)),',',num2str(templatePattern(2)),',',num2str(templatePattern(3)),',',num2str(templatePattern(4)),',',num2str(templatePattern(5)),'\n'])
    end

    templatedZed = templatePattern(1)+3*templatePattern(2)+9*templatePattern(3)+27*templatePattern(4)+81*templatePattern(5);
    guesses = guesses+1;
    
	if templatedZed==242
        if guesses<7
            fprintf(['Winner! In ',num2str(guesses),' guesses.\n'])
        else
            fprintf(['Lost :( in ',num2str(guesses),' guesses.\n'])
        end
        return
    end    
    
    valid = WordleResult(index,:)==templatedZed;
    words = words(valid,:);
    WordleResult = WordleResult(valid,valid); 
    
    if size(words,1)==0
        break
    end

    fprintf(['WordleBot: There are ',num2str(size(words,1)),' possible words left. computing best word\n'])
    
    if size(words,1)==1
        index = 1;
    else

        switch strategy
            case 0 
                index = ceil(rand.*size(words,1));
            case 1
                LetterAbundance = zeros(size(letters));
                for i=1:size(words,1)
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
                [~,index] = max(LetterAbundanceScore);

            case 2
                EliminationScore = zeros(size(words,1),1);
                for i=1:size(words,1)
                    ruledout = zeros(size(words,1),1);
                    for j=1:size(words,1)
                        for k=1:size(words,1)
                            if  ~(WordleResult(i,j)==WordleResult(i,k))
                               ruledout(j) = ruledout(j)+1; 
                            end
                        end
                    end
                    EliminationScore(i) = mean(ruledout);
                end
                [~,index] = max(EliminationScore);
            case 3
                EntropyScore = zeros(size(words,1),1);
                for i=1:size(words,1)
                    EntropyScore(i) = length(unique(WordleResult(i,:)));
                end
                [~,index] = max(EntropyScore);
            otherwise
                break
        end
    end
end
fprintf('Wordlebot: I ran out of words to guess, perhaps the target word was not in the list?\n');
guesses = [];

