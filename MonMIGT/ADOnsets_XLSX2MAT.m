%This script will ONLY convert the onset to Win and Loss trials. Not
%Advantage vs disadvantegous trials

clc;

%Must specify the condition to extract
%In this case, it is the first THREE
    % set conditions
    numberOfConditions = 3

%Looping through all 81 of my subjects.
for subjectNumber = 0:80
    
    rowRange = strcat ( ...
        num2str(1 + subjectNumber*5), ...
        ':', ... 
        num2str(numberOfConditions+subjectNumber*5) ...
        );
    
    % Will have to change the row indexer 1:5 later on.
    [ConditionOnsetTime ConditionName] = xlsread('K:\ResearchData\2013-09 fMRI Connectivity\fMRIdata\onsets\IGT\IGT Onsets for Matlab XLSread.xlsx', 'NoFormulaOnsets',rowRange);



    % Check the size of both imported text and numerical variables.
    % They must both have FIVE entries. AB, CD, Control, LOSS, WIN. 
    assert( size(ConditionOnsetTime,1) == numberOfConditions, 'Missing onset data rows.');
    assert( size(ConditionName,1) == numberOfConditions, 'Missing onset name rows.');

    % Looping through each conditions,
    for columnIndex = 1 : numberOfConditions
        % and name the column
        % sample output should be like: AB{1} = XXXXXX
        eval( [ ConditionName{columnIndex, 3}, ' = ConditionOnsetTime(columnIndex,:);' ] ); 
    end

    %Declare names cell array.
    names = cell(1,numberOfConditions);
    %Fill in the name cell array. 
    names = transpose (ConditionName (:,3))

    %Declare onests, durations
    onsets = cell(1,numberOfConditions);
    durations=cell(1,numberOfConditions);

    %Fill in the onsets cell array. 
    for cellIndex = 1 : numberOfConditions
        %Put onsets from imported double into onset array. 
        onsets{cellIndex} = ConditionOnsetTime(cellIndex,:);
        % This magical line is suppose to CLEAN all NaN values that generated during the import process.
        x = onsets{cellIndex};
        cleanedArray = x(isfinite(x));
        onsets{cellIndex} = cleanedArray;
        durations{cellIndex} = 0;
    end

    save(strcat(ConditionName{1,1},'AD'),'names', 'onsets', 'durations');
end