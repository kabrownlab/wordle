%% PlayAllGames.m
% Plays all possible Wordle games with a given strategy
%
% Written by Keith A. Brown 2/2022
% brownka@gmail.com

clear all
close all
clc


load WordleData.mat

% 0 - Random Selection
% 1 - Value words based on letter abundance
% 2 - Value words based on how many words they can elimate
% 3 - Value words based on how many unique patterns they produce
strategy = 3;

score = zeros(numwords,1);
for i=1:numwords
    fprintf(['\n>>>>Word ',num2str(i),'/',num2str(numwords),' is ',words(i,:),'\n'])
    score(i) = PlayWordle(strategy,words(i,:));
end

%% Plot the data

figure
histogram(score,[1:(max(score)+1)]-.5)
set(gca,'LineWidth',3,'XColor','k','YColor','k','FontSize',22,'Layer','top')
xlabel('Guesses','FontSize',24)
ylabel('Counts','FontSize',24)
set(gcf,'Position',[1 1 600 500])



