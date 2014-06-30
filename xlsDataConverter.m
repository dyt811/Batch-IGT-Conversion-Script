%This script try to extract the actual data structure from the .mat file and convert them into txt.

%This will be fed into EVM analyses.
%By Yang Ding. 2014-03-25

clc
clear

%Load the extractor variable.
load('D:\Yang\Dropbox\Test\Julien Data\Test 2\EVM_Ready_Export.mat');

%Try to get group size.
intMainFolders = size(group,2);

%Initialize total file entries index
indexTotalFileEntries = 0;

%Loop through each main folders.
%for indexMainFolder = 1:intMainFolders
for indexMainFolder = 1:intMainFolders
    
    %Only analyse the gorup if it is not empty
    if isempty(group(1,indexMainFolder).Name)==false
        
        %Get the number of IQDAT files.
        intIQDATFiles = size(group(1,indexMainFolder).IQDATparticipant,2);

        %Get the number of TXT files.
        intTXTFiles = size(group(1,indexMainFolder).TXTparticipant,2);

        %Get the number of XLS files
        intXLSFiles = size(group(1,indexMainFolder).XLSparticipant,2);

        %==============================================
        %This chunk of code try to extract TXT files.
        %==============================================
        if isempty(group(1,indexMainFolder).TXTparticipant) == 0
            %Loop through all the TXT files.
            for indexTXTFiles = 1:intTXTFiles

                arrayMatchingLocation =[];

                %Do a check to avoid duplicated entries from 2nd entry onward and only
                %this new entry is not EMPTY
                if indexTXTFiles > 2 && isempty(group(1,indexMainFolder).TXTparticipant(1,indexTXTFiles).choiceArray)==0
                    %Get current file name
                    currentFileName = group(1,indexMainFolder).TXTparticipant(1,indexTXTFiles).name;

                    %Try to see if it matches anything, if matched to anything,intXLSFiles
                    %will skip analyses.
                    arrayMatchingLocation = strmatch(currentFileName,textFileArray(:,3));
                end


                %CHeck if any location matches, only analyse when no existing
                %match. Only analyze when choice array is not empty.
                if isempty(arrayMatchingLocation)==1 && isempty(group(1,indexMainFolder).TXTparticipant(1,indexTXTFiles).choiceArray)==0

                    %Loop through all 100th trials
                    for indexTrial = 1:100
                        %Increase total file index by 1
                        indexTotalFileEntries = indexTotalFileEntries+1;

                        %Record main folder name.
                        textFileArray{indexTotalFileEntries,1} = group(1,indexMainFolder).TXTparticipant(1,indexTXTFiles).groupName;

                        %Record file type
                        textFileArray{indexTotalFileEntries,2} = group(1,indexMainFolder).TXTparticipant(1,indexTXTFiles).fileType;

                        %Record file name
                        textFileArray{indexTotalFileEntries,3} = group(1,indexMainFolder).TXTparticipant(1,indexTXTFiles).name;

                        %Record trial number
                        textFileArray{indexTotalFileEntries,4} = indexTrial;

                        %Record Choice
                        textFileArray{indexTotalFileEntries,5} = group(1,indexMainFolder).TXTparticipant(1,indexTXTFiles).choiceArray{indexTrial,1};

                        %Record Win
                        textFileArray{indexTotalFileEntries,6} = group(1,indexMainFolder).TXTparticipant(1,indexTXTFiles).winArray(indexTrial,1);

                        %Record Loss
                        textFileArray{indexTotalFileEntries,7} = group(1,indexMainFolder).TXTparticipant(1,indexTXTFiles).lossArray(indexTrial,1);
                    end
                end
            end
        end



        %==============================================
        %This chunk of code try to extract IQDAT files.
        %==============================================
        if isempty(group(1,indexMainFolder).IQDATparticipant) == 0
            %Loop through all the IQDAT files.
            for indexIQDATFiles = 1:intIQDATFiles

                arrayMatchingLocation =[];

                %Do a check to avoid duplicated entries from 2nd entry onward and only
                %this new entry is not EMPTY
                if indexIQDATFiles > 2 && isempty(group(1,indexMainFolder).IQDATparticipant(1,indexIQDATFiles).choiceArray)==0
                    %Get current file name
                    currentFileName = group(1,indexMainFolder).IQDATparticipant(1,indexIQDATFiles).name;

                    %Try to see if it matches anything, if matched to anything,intXLSFiles
                    %will skip analyses.
                    arrayMatchingLocation = strmatch(currentFileName,textFileArray(:,3));
                end


                %CHeck if any location matches, only analyse when no existing
                %match. Only analyze when choice array is not empty.
                if isempty(arrayMatchingLocation)==1 && isempty(group(1,indexMainFolder).IQDATparticipant(1,indexIQDATFiles).choiceArray)==0

                    %Loop through all 100th trials
                    for indexTrial = 1:100
                        %Increase total file index by 1
                        indexTotalFileEntries = indexTotalFileEntries+1;

                        %Record main folder name.
                        textFileArray{indexTotalFileEntries,1} = group(1,indexMainFolder).IQDATparticipant(1,indexIQDATFiles).groupName;

                        %Record file type
                        textFileArray{indexTotalFileEntries,2} = group(1,indexMainFolder).IQDATparticipant(1,indexIQDATFiles).fileType;

                        %Record file name
                        textFileArray{indexTotalFileEntries,3} = group(1,indexMainFolder).IQDATparticipant(1,indexIQDATFiles).name;

                        %Record trial number
                        textFileArray{indexTotalFileEntries,4} = indexTrial;

                        %Record Choice
                        textFileArray{indexTotalFileEntries,5} = group(1,indexMainFolder).IQDATparticipant(1,indexIQDATFiles).choiceArray{indexTrial,1};

                        %Record Win
                        textFileArray{indexTotalFileEntries,6} = group(1,indexMainFolder).IQDATparticipant(1,indexIQDATFiles).winArray(indexTrial,1);

                        %Record Loss
                        textFileArray{indexTotalFileEntries,7} = group(1,indexMainFolder).IQDATparticipant(1,indexIQDATFiles).lossArray(indexTrial,1);
                    end
                end
            end
        end







        %==============================================
        %This chunk tries to extract XLS data 
        %==============================================
        if isempty(group(1,indexMainFolder).XLSparticipant) == 0
            %Loop through all the XLS files.
            for indexXLSFiles = 1:intXLSFiles

                %Check duplicated entry if they have more than 0 entries and only
                %this new entry is not EMPTY
                if indexTotalFileEntries > 0 && isempty(group(1,indexMainFolder).XLSparticipant(1,indexXLSFiles).choiceArray)==0
                    %Get current file name
                    currentFileName = group(1,indexMainFolder).XLSparticipant(1,indexXLSFiles).name;

                    %Try to see if it matches anything, if matched to anything,
                    %will skip analyses.
                    arrayMatchingLocation = strmatch(currentFileName,textFileArray(:,3));
                end


                %CHeck if any location matches, only analyse when no existing
                %match.
                if isempty(arrayMatchingLocation)==1 && isempty(group(1,indexMainFolder).XLSparticipant(1,indexXLSFiles).choiceArray)==0

                    %Loop through all 100th trials
                    for indexTrial = 1:100
                        %Increase total file index by 1
                        indexTotalFileEntries = indexTotalFileEntries+1;

                        %Record main folder name.
                        textFileArray{indexTotalFileEntries,1} = group(1,indexMainFolder).XLSparticipant(1,indexXLSFiles).groupName;

                        %Record file type
                        textFileArray{indexTotalFileEntries,2} = group(1,indexMainFolder).XLSparticipant(1,indexXLSFiles).fileType;

                        %Record file name
                        textFileArray{indexTotalFileEntries,3} = group(1,indexMainFolder).XLSparticipant(1,indexXLSFiles).name;

                        %Record trial number
                        textFileArray{indexTotalFileEntries,4} = indexTrial;

                        %Record Choice
                        textFileArray{indexTotalFileEntries,5} = group(1,indexMainFolder).XLSparticipant(1,indexXLSFiles).choiceArray{indexTrial,1};

                        %Record Win
                        textFileArray{indexTotalFileEntries,6} = group(1,indexMainFolder).XLSparticipant(1,indexXLSFiles).winArray(indexTrial,1);

                        %Record Loss
                        textFileArray{indexTotalFileEntries,7} = group(1,indexMainFolder).XLSparticipant(1,indexXLSFiles).lossArray(indexTrial,1);
                    end
                end
            end
        end
    end
end
disp('All Participants have been Processed')
filename = 'EVM_Ready_XLS.xlsx';
xlswrite(filename,textFileArray);
