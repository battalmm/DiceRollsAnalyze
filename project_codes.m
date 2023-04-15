clear all;
clc;
close all;

% Yusuf Can Korkmaz
% 20191709009
% GE 204 / FENS 200 Poject-1

%% Setting Initial Conditions (For Creating Data First Time)

% Set the number of rolls
numRolls = 100;
% Rolling the dice and store the results
firstHundredDiceRolls = randi([1,6],1,numRolls);
% Second dice rolls
[secondHundredDiceRolls, averagListOfFiveRolls] = fiveRollInRow();

%% Setting Initial Conditions (For Fetching Data Time)

% Set the number of rolls
numRolls = 100;
% Specify the range s
range1 = 'B2:B101';
range2 = 'C2:C101';
range3 = 'B2:B21';
% File Name
fileName = "raw_data.xlsx";
% Sheet Names
sheet1 = "Rolls";
sheet2 = "FiveGroupedRolls Data";

% Read the data from the Excel sheet
tableData1 = readtable(fileName, 'Sheet', sheet1, 'Range', range1);
tableData2 = readtable(fileName, 'Sheet', sheet1, 'Range', range2);
tableData3 = readtable(fileName, 'Sheet', sheet2, 'Range', range3);

% Turn them matrix
firstHundredDiceRolls = table2array(tableData1)';
secondHundredDiceRolls = table2array(tableData2)';
averagListOfFiveRolls = table2array(tableData3)';

%% Displaying the Results After 100 Trials

% Display the results
fprintf('The results of first rolls are: ');
for i = 1 : numRolls
    fprintf('%d ', firstHundredDiceRolls(i));
end
fprintf('\nThe results of second rolls are: ');
for i = 1 : numRolls
    fprintf('%d ', secondHundredDiceRolls(i));
end

%% Calculating Probabilities

% Calculating and Displaying the probabilities
fprintf('\nThe probabilities of each outcome are: \n');
[allDatasProbability] = probabilityCalculator(firstHundredDiceRolls, 1, 100, 100);

%% Calculating half pieces datas probabilities

% Calculating and Displaying the probabilities
fprintf('The probabilities of the first 50 outcomes are: \n');
[firstHalfProbabilities] = probabilityCalculator(firstHundredDiceRolls, 1, 50, 50);

fprintf('The probabilities of the last 50 outcomes are: \n');
[secondHalfProbabilities] = probabilityCalculator(firstHundredDiceRolls, 51, 100, 50);

%% Calculating quadratic pieces datas probabilities

% Calculating and Displaying the probabilities
fprintf('The probabilities of the first 25 outcomes are: \n');
[firstQuadricProbabilities] = probabilityCalculator(firstHundredDiceRolls, 1, 25, 25);

fprintf('The probabilities of the second 25 outcomes are: \n');
[secondQuadricProbabilities] = probabilityCalculator(firstHundredDiceRolls, 26, 50, 25);

fprintf('The probabilities of the third 25 outcomes are: \n');
[thirdQuadricProbabilities] = probabilityCalculator(firstHundredDiceRolls, 51, 75, 25);

fprintf('The probabilities of the fourth 25 outcomes are: \n');
[fourthQuadricProbabilities] = probabilityCalculator(firstHundredDiceRolls, 76, 100, 25);

%% Calculating Error Rate

% Calculate percent error for all 100 outcomes
percentError100 = abs((1/6 - allDatasProbability) / (1/6)) * 100;
meanPercentError100 = mean(percentError100);

% Calculate percent error for all 100 outcomes
percentErrorFirst50 = abs((1/6 - firstHalfProbabilities) / (1/6)) * 100;
meanPercentErrorFirst50 = mean(percentErrorFirst50);

% Calculate percent error for all 100 outcomes
percentErrorSecond50 = abs((1/6 - secondHalfProbabilities) / (1/6)) * 100;
meanPercentErrorSecond50 = mean(percentErrorSecond50);

% Calculate percent error for first 25 outcomes
percentErrorFirst25 = abs((1/6 - firstQuadricProbabilities) / (1/6)) * 100;
meanPercentErrorFirst25 = mean(percentErrorFirst25);

% Calculate percent error for first 25 outcomes
percentErrorSecond25 = abs((1/6 - secondQuadricProbabilities) / (1/6)) * 100;
meanPercentErrorSecond25 = mean(percentErrorSecond25);

% Calculate percent error for first 25 outcomes
percentErrorThird25 = abs((1/6 - thirdQuadricProbabilities) / (1/6)) * 100;
meanPercentErrorThird25 = mean(percentErrorThird25);

% Calculate percent error for first 25 outcomes
percentErrorFourth25 = abs((1/6 - fourthQuadricProbabilities) / (1/6)) * 100;
meanPercentErrorFourth25 = mean(percentErrorFourth25);

% Mean Error List
meanErrorList = [meanPercentError100, meanPercentErrorFirst50, meanPercentErrorSecond50, ... 
    meanPercentErrorFirst25, meanPercentErrorSecond25, meanPercentErrorThird25, meanPercentErrorFourth25];

% Mean Error List 100-50-25
meanErrorList100_50_25 = [meanPercentError100, (meanPercentErrorFirst50 + meanPercentErrorSecond50)/2 ...
    (meanPercentErrorFirst25 + meanPercentErrorSecond25 + meanPercentErrorThird25 + meanPercentErrorFourth25)/4];

%% Adding Datas to Tables

% Creating Table for Two Rolls
rollCount = 1 : 1 : 100;
DiceRollsTable = table(rollCount', firstHundredDiceRolls', secondHundredDiceRolls', ... 
    'VariableNames', {'Order','First 100 Rolls','Second 100 Rolls'});

% Creating Table About Average List of Five Rolls
groups = 1:20;
SecondRollsAverageListTable = table(groups', averagListOfFiveRolls', ...
    'VariableNames', {'Groups','Probability'});

% Creating Main Table
% Count the occurrences of each outcome
firstRollsTableOccurrences = histcounts(firstHundredDiceRolls, 6); 
outcomes = 1:6;
Table = table(outcomes', firstRollsTableOccurrences', allDatasProbability', percentError100', ...
    'VariableNames', {'Outcome', 'Frequency', 'Probability', 'Error'});

% Creating Table for First 50 and Adding Main Table
first50 = histcounts(firstHundredDiceRolls(1:50), 6);
TableFirst50 = table(outcomes', first50', firstHalfProbabilities', percentErrorFirst50', ...
    'VariableNames', {'First50-Outcome', 'First50-Frequency', 'First50-Probability', 'First50-Error'});
Table = [Table TableFirst50(:, 2:4)];

% Creating Table for Second 50 and Adding Main Table
last50 = histcounts(firstHundredDiceRolls(51:100), 6);
TableLast50 = table(outcomes', last50', secondHalfProbabilities', percentErrorSecond50', ...
    'VariableNames', {'Last50-Outcome', 'Last50-Frequency', 'Last50-Probability', 'Second50-Error'});
Table = [Table TableLast50(:, 2:4)];

% Creating Table for First 25 and Adding Main Table
first25 = histcounts(firstHundredDiceRolls(1:25), 6);
TableFirst25 = table(outcomes', first25', firstQuadricProbabilities', percentErrorFirst50', ...
    'VariableNames', {'First25-Outcome', 'First25-Frequency', 'First25-Probability', 'First25-Error'});
Table = [Table TableFirst25(:, 2:4)];

% Creating Table for Second 25 and Adding Main Table
second25 = histcounts(firstHundredDiceRolls(26:50), 6);
TableSecond25 = table(outcomes', second25', secondQuadricProbabilities', percentErrorSecond25', ...
    'VariableNames', {'Second25-Outcome', 'Second25-Frequency', 'Second25-Probability', 'Second25-Error'});
Table = [Table TableSecond25(:, 2:4)];

% Creating Table for Third 25 and Adding Main Table
third25 = histcounts(firstHundredDiceRolls(51:75), 6);
TableThird25 = table(outcomes', third25', thirdQuadricProbabilities', percentErrorThird25', ...
    'VariableNames', {'Third25-Outcome', 'Third25-Frequency', 'Third25-Probability', 'Third25-Error'});
Table = [Table TableThird25(:, 2:4)];

% Creating Table for Fourth 25 and Adding Main Table
fourth25 = histcounts(firstHundredDiceRolls(76:100), 6);
TableFourth25 = table(outcomes', fourth25', fourthQuadricProbabilities', percentErrorFourth25', ...
    'VariableNames', {'Fourth25-Outcome', 'Fourth25-Frequency', 'Fourth25-Probability', 'Fourth25-Error'});
Table = [Table TableFourth25(:, 2:4)];

disp(Table);

%% Plotting 

% Compute the frequency counts for each array
rolls1 = histcounts(firstHundredDiceRolls, 'BinMethod', 'integers');
rolls2 = histcounts(secondHundredDiceRolls, 'BinMethod', 'integers');

% Createing chart with two bars for each integer value
figure();
bar(1:6, [rolls1; rolls2], 'grouped');
% Set the x-axis labels to show 1-6 in any case
xticks(1:6);
% Add labels for the x and y axes and a title for the plot
xlabel('Dice Roll');
ylabel('Frequency');
title('Graph of 100 Fair Dice Rolls');
% Add a legend for the two histograms
legend('First Hundred Rolls', 'Second Hundred Rolls');

% Creating Figure for Five Grouped Rolls
figure();
bar(1:20, averagListOfFiveRolls, 'grouped');
title('Graph of Five Grouped Rolls');
xlabel('Groups of Five');
ylabel('Means');
xlim([0, 6]);
xlim([0, 21]);

figure();
% Creating a 2x3 tiled layout
t = tiledlayout(2,3);
t.TileSpacing = 'compact';

% Plot bar graphs for each tile
% Graph for probability of roll 1
ax1 = nexttile;
bar(ax1, 1:7, [Table{1, 3}; Table{1, 6}; Table{1, 9}; Table{1, 12}; Table{1, 15}; ...
    Table{1, 18}; Table{1, 21}], 'grouped');
ylim(ax1, [0, 0.5]);
title(ax1, "Probability of roll 1");

% Graph for probability of roll 2
ax2 = nexttile;
bar(ax2, 1:7, [Table{2, 3}; Table{2, 6}; Table{2, 9}; Table{2, 12}; Table{2, 15}; ...
    Table{2, 18}; Table{2, 21}], 'grouped');
ylim(ax2, [0, 0.5]);
title(ax2, "Probability of roll 2");

% Graph for probability of roll 3
ax3 = nexttile;
bar(ax3, 1:7, [Table{3, 3}; Table{3, 6}; Table{3, 9}; Table{3, 12}; Table{3, 15}; ...
    Table{3, 18}; Table{3, 21}], 'grouped');
ylim(ax3, [0, 0.5]);
title(ax3, "Probability of roll 3");

% Graph for probability of roll 4
ax4 = nexttile;
bar(ax4, 1:7, [Table{4, 3}; Table{4, 6}; Table{4, 9}; Table{4, 12}; Table{4, 15}; ...
    Table{4, 18}; Table{4, 21}], 'grouped');
ylim(ax4, [0, 0.5]);
title(ax4, "Probability of roll 4");

% Graph for probability of roll 5
ax5 = nexttile;
bar(ax5, 1:7, [Table{5, 3}; Table{5, 6}; Table{5, 9}; Table{5, 12}; Table{5, 15}; ...
    Table{5, 18}; Table{5, 21}], 'grouped');
ylim(ax5, [0, 0.5]);
title(ax5, "Probability of roll 5");

% Graph for probability of roll 6
ax6 = nexttile;
bar(ax6, 1:7, [Table{6, 3}; Table{6, 6}; Table{6, 9}; Table{6, 12}; Table{6, 15}; ...
    Table{6, 18}; Table{6, 21}], 'grouped');
ylim(ax6, [0, 0.5]);
title(ax6, "Probability of roll 6");

% Add labels to the main figure
xlabel(t, 'Intervals: 1=(0 100)  2=(0 50)  3=(50 100)  4=(0 25)  5=(25 50)  6=(50 75)  7=(75 100)');
ylabel(t, 'Probability');
title(t, 'Probabilities About Different Intervals');

figure();
bar(1:7, meanErrorList);
xlabel('Intervals: 1=(0 100)  2=(0 50)  3=(50 100)  4=(0 25)  5=(25 50)  6=(50 75)  7=(75 100)');
ylabel('Error Rate');
title('Mean Error Rate of Seven Values');

figure();
bar(1:3, meanErrorList100_50_25);
xlabel(' 100 - 2*50 - 4*25 ');
ylabel('Error Rate');
title('Mean Error Rate of 100, 2*50 and 4*25 rolls');

%% Saving Tables to Files

% % Write the table to an Excel file
% filename = 'raw_data.xlsx';
% writetable(DiceRollsTable, filename, 'Sheet', 'Rolls');
% writetable(Table, filename, 'Sheet', 'Rolls Analyze');
% writetable(SecondRollsAverageListTable, filename, 'Sheet', 'FiveGroupedRolls Data');

%% Some Statistic Info

firstMean = mean(firstHundredDiceRolls);
secondMean = mean(secondHundredDiceRolls);

firstVariance = var(firstHundredDiceRolls);
secondVariance = var(secondHundredDiceRolls);

firstStd = std(firstHundredDiceRolls);
secondStd = std(secondHundredDiceRolls);

firstMedian = median(firstHundredDiceRolls);
secondMedian = median(secondHundredDiceRolls);

secondData = reshape(secondHundredDiceRolls, 5, 20);
secondDataVariance = var(secondData)';


%% Functions

function [probabilities] = probabilityCalculator(hundredDiceRolls, firstElement, lastElement, elementCount)

% Calculation of the probabilities between wanted elements
values = hundredDiceRolls(firstElement:lastElement);
probabilities = zeros(1,6);
    for i = 1:6
        probabilities(i) = sum(values == i) / elementCount;
    end

    % Printing probabilities
    for i = 1:6
        fprintf('Rolling a %d: %.2f\n', i, probabilities(i));
    end

end

function [secondHundredDiceRolls, averagListOfFivePieces]= fiveRollInRow()
% Initialization of arrays
secondHundredDiceRolls = zeros(1,100);
averagListOfFivePieces = zeros(1,20);

% There should be 20 step and each of them contains 5 rolls average
stepNumber = 1;
while stepNumber < 21
    % Rolling dices
    firstHundredDiceRolls = randi([1,6],1,5);
    sumOfNumbers = 0;
    
    % Setting rolls to lists
    for i = 1 : 5
        % Second roll list 
        secondHundredDiceRolls(((stepNumber - 1)*5) + i) = firstHundredDiceRolls(i);
        % This one for averages
        sumOfNumbers = sumOfNumbers + firstHundredDiceRolls(i);
    end
    
    % Finding average
    average = sumOfNumbers/5;
    fprintf('%d. The results of 5 rolls average is (second 100 set): %.2f\n', stepNumber, average);
    averagListOfFivePieces(stepNumber) = average;
    stepNumber = stepNumber + 1;
end
end
