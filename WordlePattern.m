function pattern = WordlePattern(guess,answer)
% function pattern = wordlepattern(guess,answer)
% Returns the pattern that results from guessing 'GUESS' when the answer is
% 'ANSWER'. Here, 0 indicates grey, 1 indicates yellow, 2 indicates green
%
% Written by Keith A. Brown 2/2022
% brownka@gmail.com


    pattern = [0 0 0 0 0];
    unused = [1 1 1 1 1];

    %start by checking for letters that are correct
    temp = (guess==answer);
    if sum(temp)
        pattern(temp) = 2;
        unused(temp) = 0;
    end

    %for each space, check if the letter is present elsewhere
    for i=1:5
        if pattern(i)<2 %%make sure we haven't already set it to green
            if sum((guess(i)==answer).*unused)
                pattern(i) = 1;
                ind = find((guess(i)==answer).*unused,1,'first');
                unused(ind) = 0;
            end
        end
    end
end


