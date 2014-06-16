%This script tries to read a specially format sized OnSet XLSX file that
%has been prepared manually.

%Last updated 2014-06-01 for IGT manual extraction from the database. 

clc;
clear;

totalSubjects = 1;
numberOfConditions = 10;

%Looping through all 81 of my subjects.
for subjectNumber = 0:(totalSubjects-1)
    
    rowRange = strcat ( ...
        num2str(1 + subjectNumber*numberOfConditions), ...
        ':', ... 
        num2str(numberOfConditions+subjectNumber*numberOfConditions) ...
        );
    
    % Will have to change the row indexer 1:5 later on.
    [ConditionOnsetTime ConditionName] = xlsread('C:\GitHub\Batch-IGT-Conversion-Script\RelativeStudyIGT\RAW\2014-06-04 T1336 68023.xlsx', 'Sheet2',rowRange);

    % Check the size of both imported text and numerical variables.
    % They must both have FIVE entries. AB, CD, Control, LOSS, WIN. 
    assert( size(ConditionOnsetTime,1) == numberOfConditions, 'Missing onset data rows.');
    assert( size(ConditionName,1) == numberOfConditions, 'Missing onset name rows.');

    % Looping through each conditions,
    for columnIndex = 1 : numberOfConditions
        % and name the column
        % sample output should be like: AB{1} = XXXXXX
        ConditionName{columnIndex, 3} = ConditionOnsetTime(columnIndex,:);
    end

    %Declare names cell array.
    names = cell(1,6);
    %Fill in the name cell array. 
    names = transpose (ConditionName (:,1))

    %Declare onests, durations
    onsets = cell(1,6);
    durations = cell(1,6);

    %Fill in the onsets cell array. 
    %for cellIndex = 1 : numberOfConditions
    for cellIndex = 1 : 6
        %Put onsets from imported double into onset array. 
        onsets{cellIndex} = ConditionOnsetTime(cellIndex,:);
        % This magical line is suppose to CLEAN all NaN values that generated during the import process.
        x = onsets{cellIndex};
        cleanedArray = x(isfinite(x));
        onsets{cellIndex} = cleanedArray;
        durations{cellIndex} = 0;
    end
    names(:,7:1:10) = [];
    

    save(num2str(ConditionName{10,3}(1)),'names', 'onsets', 'durations');
end