%This script tries to read a specially format sized OnSet XLSX file that
%has been prepared manually.

%Update 2014-06-29 for 2s duration extraciton. 
%Updated 2014-06-15 for extracting only specific components of the
%XLSX file.
%Updated 2014-06-01 for IGT manual extraction from the database.

clc;
clear;

totalSubjects = 57;
numberOfConditions = 10;

%From the minimum
cellIndexMIN = 8;
cellIndexMAX = 9;

%Offset necessary to keep everthing start from 1!
cellIndexOffset = cellIndexMIN - 1;

%This number indicates actually HOW many numbers are necessary for the
%export. 
cellIndexSpan = cellIndexMAX - cellIndexOffset;

%Looping through all 81 of my subjects.
for subjectNumber = 0:(totalSubjects-1)
    
    rowRange = strcat ( ...
        num2str(1 + subjectNumber*numberOfConditions), ...
        ':', ...
        num2str(numberOfConditions+subjectNumber*numberOfConditions) ...
        );
    
    % Will have to change the row indexer 1:5 later on.
    [ConditionOnsetTime ConditionName] = xlsread('C:\GitHub\Batch-IGT-Conversion-Script\RelativeStudyIGT\RAW\2014-06-15 T2210 All.xlsx', 'Sheet1',rowRange);
    
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
    names = cell(1,cellIndexSpan);
    
    
    %Declare onests, durations
    onsets = cell(1,cellIndexSpan);
    durations = cell(1,cellIndexSpan);
    
    %Temporary text to extract onset + end.
        cellIndex = 2
        %Put onsets from imported double into onset array.
        onsets{1} = ConditionOnsetTime(cellIndex,:);        
        %Fill in the name cell array.
        names{1} = ConditionName{cellIndex,1};  
        % This magical line is suppose to CLEAN all NaN values that generated during the import process.
        x = onsets{1};
        cleanedArray = x(isfinite(x));
        onsets{1} = cleanedArray;
        durations{1} = 0;
        
        %Win extraction.
        cellIndex = 8
        %Put onsets from imported double into onset array.
        onsets{2} = ConditionOnsetTime(cellIndex,:);
        %Fill in the name cell array.
        names{2} = ConditionName{cellIndex,1};       
        % This magical line is suppose to CLEAN all NaN values that generated during the import process.
        x = onsets{2};
        cleanedArray = x(isfinite(x));
        onsets{2} = cleanedArray;
        durations{2} = 2;
        
        %Lose extraction.
        cellIndex = 9
        %Put onsets from imported double into onset array.
        onsets{3} = ConditionOnsetTime(cellIndex,:);        
        %Fill in the name cell array.
        names{3} = ConditionName{cellIndex,1};                
        % This magical line is suppose to CLEAN all NaN values that generated during the import process.
        x = onsets{3};
        cleanedArray = x(isfinite(x));
        onsets{3} = cleanedArray;
        durations{3} = 2;
%     
%     %Fill in the onsets cell array.
%     
%     %for cellIndex = 1 : numberOfConditions
%     %1st = fixation, 2 = trial start, 3-6 = decks
%     for cellIndex = cellIndexMIN : 1 : cellIndexMAX
%         %Put onsets from imported double into onset array.
%         onsets{cellIndex - cellIndexOffset} = ConditionOnsetTime(cellIndex,:);
%         
%         %Fill in the name cell array.
%         names{cellIndex - cellIndexOffset} = ConditionName{cellIndex,1};
%         
%         
%         % This magical line is suppose to CLEAN all NaN values that generated during the import process.
%         x = onsets{cellIndex- cellIndexOffset};
%         cleanedArray = x(isfinite(x));
%         onsets{cellIndex- cellIndexOffset} = cleanedArray;
%         durations{cellIndex- cellIndexOffset} = 0;
%     end
%     %names(:,cellIndexSpan:1:numberOfConditions) = [];
    
    cd ('C:\GitHub\Batch-IGT-Conversion-Script\RelativeStudyIGT')
    save(num2str(ConditionName{10,3}(1)),'names', 'onsets', 'durations');
end
