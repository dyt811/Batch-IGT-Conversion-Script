%This script try to read a XLS/TXT/WIN/IQDAT file from IGT task and and
%convert them into a variable that is ready to be extracted and analyzed by
%Expectancy Valence Model script as written by Dr. Eldad Yachiam

%By Yang Ding. 2014-03-04

clc
clear

%Declare main folder path that will loop thorugh to collect.
arrayMainDirPath{1}='D:\Yang\Dropbox\Test\Données brutes IGT CS Genève I et II (et clinique)';
arrayMainDirPath{2}='D:\Yang\Dropbox\Test\Données brutes IGT CS Montpellier I (Fabrice)';
arrayMainDirPath{3}='D:\Yang\Dropbox\Test\Données brutes IGT CS Montpellier II (Annukka)';
arrayMainDirPath{4}='D:\Yang\Dropbox\Test\Données brutes IGT CS Montpellier II (Carine)';
arrayMainDirPath{5}='D:\Yang\Dropbox\Test\Données brutes IGT CS Montpellier III (Sébastien)';
arrayMainDirPath{6}='D:\Yang\Dropbox\Test\Données brutes IGT CS Montpellier IV (Adéla)';
arrayMainDirPath{7}='D:\Yang\Dropbox\Test\Données brutes IGT témoins affectifs Montpellier I (Fabrice)';
arrayMainDirPath{8}='D:\Yang\Dropbox\Test\Données brutes IGT témoins affectifs Montpellier I (PM)';
arrayMainDirPath{9}='D:\Yang\Dropbox\Test\Données brutes IGT témoins affectifs Montpellier III (Sébastien)';
arrayMainDirPath{10}='D:\Yang\Dropbox\Test\Données brutes IGT témoins sains Montpellier I (Fabrice)';
arrayMainDirPath{11}='D:\Yang\Dropbox\Test\Données brutes IGT témoins sains Montpellier I (PM)';
arrayMainDirPath{12}='D:\Yang\Dropbox\Test\Données brutes IGT témoins sains Montpellier III (Sébastien)';
arrayMainDirPath{13}='D:\Yang\Dropbox\Test\Julien Data\Test 2';


%Specify search range
searchColumnRange=20;
searchRowRange=130;

failedSubjectArray{1} = [];
failSubjectCount = 0;



%Preallocated space for estimated subjects

for indexMainFolder = 13:13
    
    %==============
    %Get file name.
    %==============
    
    %Source: http://stackoverflow.com/questions/7287723/process-a-list-of-pathXLSFiles-with-a-specific-extension-name-in-matlab
    
    %Extract folder name
    dirName = arrayMainDirPath{indexMainFolder};
    
    %folderPosition = strfind(dirName,'\',)
    [folderPath,folderName,ext] = fileparts(dirName);
    
    %Store all XLS files.
    pathXLSFiles = dir( fullfile(dirName,'*.XLS') );
    
    %Store all txt files.
    pathTXTFiles = dir( fullfile(dirName,'*.txt') );
    
    %Store all WIN files. Same type as txt exactly.
    pathWINFiles = dir( fullfile(dirName,'*.win') );
    
    %Store all WIN files. Same type as txt exactly.
    pathIQDATFiles = dir( fullfile(dirName,'*.iqdat') );
    
    %Combine both paths:
    pathTXTFiles=[pathWINFiles;pathTXTFiles];
    
    %Store names  in an array.
    arraystrXLSFileName = {pathXLSFiles.name}';
    
    %Store names  in an array.
    arraystrTXTFileName = {pathTXTFiles.name}';
    
    %Store names  in an array.
    arraystrIQDATFileName = {pathIQDATFiles.name}';
    
    group(indexMainFolder).Name = folderName;
    %     group(indexMainFolder).XLSparticipant(600).name = [];
    %     group(indexMainFolder).XLSparticipant(600).choiceArray=[];
    %     group(indexMainFolder).XLSparticipant(600).winArray=[];
    %     group(indexMainFolder).XLSparticipant(600).lossArray=[];
    %     group(indexMainFolder).TXTparticipant(600).name = [];
    %     group(indexMainFolder).TXTparticipant(600).choiceArray=[];
    %     group(indexMainFolder).TXTparticipant(600).winArray=[];
    %     group(indexMainFolder).TXTparticipant(600).lossArray=[];
    %Need to insert a numel(pathTXTFiles check here.
    
    %===========================
    %Process '.TXT' files
    %===========================
    if numel(pathTXTFiles) > 0
        %Loop through the name array, process each file the same way.
        for indexFile=1:numel(pathTXTFiles)
            %Obtain XLS file name without the extension, which carries subject
            %numbe
            strTXTFileName = arraystrTXTFileName{indexFile};
            
            %Reconstruct full path file name
            strTXTFullPathName = [dirName,'/',strTXTFileName];
            
            %Extract path, filename, extension array from the file.
            [strTXTPath,strTXTFileNameNoExtension,ext] = fileparts(strTXTFullPathName);
            
            %Obtain file ID.
            idFile = fopen(strTXTFullPathName);
            
            %Read the data row by row into an array.
            for intRowIndex = 1:searchRowRange
                
                %Check for end of file. If not at the end of file, then carry
                %out these analyses.
                if feof(idFile)== 0
                    %Read the raw data from next line.
                    strIndexRowData = fgets(idFile);
                    
                    %Convert the data into cells.
                    strIndexRowData = textscan(strIndexRowData,'%s',4);
                    
                    %Need to make sure it is not an empty cell
                    if isempty(strIndexRowData{1})~=true
                        %Record information about WHICH row the header data come from.
                        if strcmpi(strIndexRowData{1}{1},'TRIAL')==true
                            intHeaderRow = intRowIndex;
                            %Record information about WHICH row the 100th row data
                            %come from. This ensures data completion
                        elseif strcmpi(strIndexRowData{1}{1},'100')==true
                            intHundredthRow = intRowIndex;
                        end
                    end
                    
                    %Check to ensure header row information exist AND there are
                    %information coming from FOUR columns. (Idealy, we should
                    %check for 100th row, but at this point, as we progress
                    %through, not likely.
                    if exist('intHeaderRow','var')==1 && size(strIndexRowData{1},1)== 4
                        
                        
                        %Check for numeric number in these 1st, 3rd, 4th
                        %entries.1st, 3rd, 4th cell must contain NUMERIC VALUES
                        %(order, WIN/LOSS!)
                        binaryNumericCheck1 = ~isnan(str2double(strIndexRowData{1}{1}));
                        binaryNumericCheck3 = ~isnan(str2double(strIndexRowData{1}{3}));
                        binaryNumericCheck4 = ~isnan(str2double(strIndexRowData{1}{4}));
                        
                        %The trial number can be deduced from the first column.
                        intTrialNumber = str2double(strIndexRowData{1}{1});
                        %Check make sure the reported trial number is correct.
                        binaryTrialNumberCheck1 = intTrialNumber > 0;
                        binaryTrialNumberCheck2 = intTrialNumber < 101;
                        
                        %Check actual row index is within the proper range, >
                        %header row, less than 100th row.
                        binaryCurrentRowCheck1 = intRowIndex > intHeaderRow;
                        binaryCurrentRowCheck2 = intRowIndex < (intHeaderRow +101);
                        
                        %Combine all the binary checks together.
                        binaryTotalRowCheck = binaryNumericCheck1 + binaryNumericCheck3 + binaryNumericCheck4 + binaryTrialNumberCheck1 + binaryTrialNumberCheck2 + binaryCurrentRowCheck1 + binaryCurrentRowCheck2;
                        
                        %All check has to pass, so totally SEVEN binary checkchecks here.
                        if binaryTotalRowCheck == 7
                            %store data into array
                            rawTXTColumnAData(intTrialNumber,1) = str2double(strIndexRowData{1}{1});
                            rawTXTColumnBData{intTrialNumber,1} = strIndexRowData{1}{2};
                            rawTXTColumnCData(intTrialNumber,1) = str2double(strIndexRowData{1}{3});
                            rawTXTColumnDData(intTrialNumber,1) = str2double(strIndexRowData{1}{4});
                        end
                    end
                end
            end
            
            %Must clear the headerRow variable to prevent carry over effect.
            
            
            
            %By now, all information should have been read into the array.
            
            %Send information to GROUP variable ONLY if both header row and
            %hunderdth row exist!
            if exist('intHeaderRow','var')==1 && exist('intHundredthRow','var')==1
                %Stparticipantore infromation inside a structure array.
                group(indexMainFolder).TXTparticipant(indexFile).groupName = folderName;
                group(indexMainFolder).TXTparticipant(indexFile).fileType = 'TXT';
                group(indexMainFolder).TXTparticipant(indexFile).name = strTXTFileNameNoExtension;
                group(indexMainFolder).TXTparticipant(indexFile).choiceArray = rawTXTColumnBData;
                group(indexMainFolder).TXTparticipant(indexFile).winArray = rawTXTColumnCData;
                group(indexMainFolder).TXTparticipant(indexFile).lossArray = rawTXTColumnDData;
            else
                disp(['Data import FAILED for Subject: ',strTXTFileName])
                failSubjectCount = failSubjectCount + 1;
                failedSubjectArray{failSubjectCount,1} = folderName;
                failedSubjectArray{failSubjectCount,2} = strTXTFileName;
            end
            disp(['All data import has been done for Subject: ', strTXTFileName])
            
            %Close file ID or else might have overflow issue with incorrect
            %idFile
            fclose(idFile);
            
            %Need to clear variables to ensure no problem.
            clearvars intHundredthRow intHeaderRow rawTXTColumnAData rawTXTColumnBData rawTXTColumnBData rawTXTColumnCData strIndexRowData
            
            %More variables to clear.
            clearvars strTXTFileName strTXTFullPathName strTXTPath strTXTFileNameNoExtension idFile
        end
    else 
        group(indexMainFolder).TXTparticipant=[];
    end
    
    
    
    %===========================
    %Process '.XLS' files
    %===========================
    if numel(pathXLSFiles) > 0
        %Loop through the name array, process each file the same way.
        for indexFile=1:numel(pathXLSFiles)
            
            
            %Obtain XLS file name without the extension, which carries subject
            %numbe
            strXLSFileName = arraystrXLSFileName{indexFile};
            
            
            %Reconstruct full path file name
            strXLSFullPathName = [dirName,'/',strXLSFileName];
            
            %Extract path, filename, extension array from the file.
            [strXLSPath,strXLSFileNameNoExtension,ext] = fileparts(strXLSFullPathName);
            
            
            
            %==============
            %Read all data from first four columns of the XLS file.
            %==============
            
            [intXLSColumnAData, textXLSColumnAData, rawXLSColumnAData ]= xlsread(strXLSFullPathName,['A1',':A',int2str(searchRowRange)]);
            [intXLSColumnBData, textXLSColumnBData, rawXLSColumnBData ]= xlsread(strXLSFullPathName,['B1',':B',int2str(searchRowRange)]);
            [intXLSColumnCData, textXLSColumnCData, rawXLSColumnCData ]= xlsread(strXLSFullPathName,['C1',':C',int2str(searchRowRange)]);
            [intXLSColumnDData, textXLSColumnDData, rawXLSColumnDData ]= xlsread(strXLSFullPathName,['D1',':D',int2str(searchRowRange)]);
            
            %Get 'TRIAL' position.
            [isMemberBinary, trialRow] = ismember('TRIAL',textXLSColumnAData);
            
            %Get 100th position.
            [isMemberBinary, HundredthRow] = ismember(100,intXLSColumnAData);
            
            
            %Get 'Deck' position.
            [isMemberBinary, deckChoiceRow] = ismember('DECK',textXLSColumnBData);
            
            %Get 'Win' position.
            [isMemberBinary, winRow] = ismember('WIN',textXLSColumnCData);
            
            %Get 'Loss' position.
            [isMemberBinary, lossRow] = ismember('LOSS',textXLSColumnDData);
            
            
            %Check all row consistency.
            %     if trialRow == deckChoiceRow && winRow ==lossRow && winRow == deckChoiceRow
            %         disp('All rows good to go.')
            %     end
            
            %These are predefined column information.
            
            %Preallocate
            trialData = zeros(100,1);
            deckChoiceData = repmat({''},100,1);
            winData = zeros(100,1);
            lossData = zeros(100,1);
            
            %If trial or 100th row not found, do not record entry.
            if trialRow~=0 && HundredthRow ~=0
                
                %For the next 100 rows, read the data and input into array.
                for rowIndex = 1:100
                    trialData(rowIndex) = rawXLSColumnAData{trialRow+rowIndex};
                    deckChoiceData{rowIndex}= textXLSColumnBData{deckChoiceRow+rowIndex};
                    winData(rowIndex)= rawXLSColumnCData{winRow+rowIndex};
                    lossData(rowIndex)= rawXLSColumnDData{lossRow+rowIndex};
                end
                
                %         %Extract the data rows.
                %         trialData = rawXLSColumnAData{(trialRow+1):(trialRow+100)};
                %         deckChoiceData= textXLSColumnBData((trialRow+1):(trialRow+100));
                %         winData= rawXLSColumnCData{(trialRow+1):(trialRow+100)};
                %         lossData= rawXLSColumnDData{(trialRow+1):(trialRow+100)};
                
                
                
                %Store participantore infromation inside a structure array.
                group(indexMainFolder).XLSparticipant(indexFile).groupName = folderName;
                group(indexMainFolder).XLSparticipant(indexFile).fileType = 'XLS';
                group(indexMainFolder).XLSparticipant(indexFile).name = strXLSFileNameNoExtension;
                group(indexMainFolder).XLSparticipant(indexFile).choiceArray = deckChoiceData;
                group(indexMainFolder).XLSparticipant(indexFile).winArray = winData;
                group(indexMainFolder).XLSparticipant(indexFile).lossArray = lossData;
                
                disp(['All data import has been done for Subject: ',strXLSFileName])
            else
                disp(['Data import FAILED for Subject: ',strXLSFileName])
                failSubjectCount = failSubjectCount +1
                failedSubjectArray{failSubjectCount,1} = folderName;
                failedSubjectArray{failSubjectCount,2} = strXLSFileName;
            end
            
            %Need to clear variable at the end of each file
            clearvars strXLSFileNameNoExtension deckChoiceData winData lossData
            clearvars strXLSFileName strXLSFullPathName strXLSPath ext intXLSColumnAData
            clearvars textXLSColumnAData rawXLSColumnAData intXLSColumnBData
            clearvars textXLSColumnBData rawXLSColumnBData intXLSColumnCData
            clearvars textXLSColumnCData rawXLSColumnCData trialRow deckChoiceRow winRowlossRow
            clearvars intXLSColumnDData textXLSColumnDData rawXLSColumnDData
            
        end
    else 
        group(indexMainFolder).XLSparticipant=[];    
    end
    
    %===========================
    %Process '.IQDAT' files
    %===========================
    
    if numel(pathIQDATFiles) > 0
        %Loop through the name array, process each file the same way.
        for indexFile=1:numel(pathIQDATFiles)
            %Obtain XLS file name without the extension, which carries subject
            %numbe
            strIQDATFileName = arraystrIQDATFileName{indexFile};
            
            %Reconstruct full path file name
            strIQDATFullPathName = [dirName,'/',strIQDATFileName];
            
            %Extract path, filename, extension array from the file.
            [strIQDATPath,strIQDATFileNameNoExtension,ext] = fileparts(strIQDATFullPathName);
            
            %Obtain file ID.
            idFile = fopen(strIQDATFullPathName);
            
            %Read the data row by row into an array.
            for intRowIndex = 1:searchRowRange
                
                %Check for end of file. If not at the end of file, then carry
                %out these analyses.
                if feof(idFile)== 0
                    %Read the raw data from next line.
                    strIndexRowData = fgets(idFile);
                    
                    %Convert the data into cells.
                    strIndexRowData = textscan(strIndexRowData,'%s', 10,'delimiter','\t');
                                        
                    %Need to make sure it is not an empty cell
                    if isempty(strIndexRowData{1})==false
                        %Record information about WHICH row the header data come from.
                        if strcmpi(strIndexRowData{1,1}{4,1},'values.cardsselected')==true
                            intHeaderRow = intRowIndex;
                            %Record information about WHICH row the 100th row data
                            %come from. This ensures data completion
                        elseif strcmpi(strIndexRowData{1,1}{4,1},'100')==true
                            intHundredthRow = intRowIndex;
                        end
                    end
                    
                    %Check to ensure header row information exist AND there are
                    %information coming from FOUR columns. (Idealy, we should
                    %check for 100th row, but at this point, as we progress
                    %through, not likely.
                    if exist('intHeaderRow','var')==1 && size(strIndexRowData{1},1)== 10
                        
                        
                        %Check for numeric number in these 1st, 3rd, 4th
                        %entries.1st, 3rd, 4th cell must contain NUMERIC VALUES
                        %(order, WIN/LOSS!)
                        binaryNumericCheck1 = ~isnan(str2double(strIndexRowData{1}{4}));
                        binaryNumericCheck3 = ~isnan(str2double(strIndexRowData{1}{8}));
                        binaryNumericCheck4 = ~isnan(str2double(strIndexRowData{1}{9}));
                        
                        %The trial number can be deduced from the first column.
                        intTrialNumber = str2double(strIndexRowData{1}{4});
                        %Check make sure the reported trial number is correct.
                        binaryTrialNumberCheck1 = intTrialNumber > 0;
                        binaryTrialNumberCheck2 = intTrialNumber < 101;
                        
                        %Check actual row index is within the proper range, >
                        %header row, less than 100th row.
                        binaryCurrentRowCheck1 = intRowIndex > intHeaderRow;
                        binaryCurrentRowCheck2 = intRowIndex < (intHeaderRow +101);
                        
                        %Combine all the binary checks together.
                        binaryTotalRowCheck = binaryNumericCheck1 + binaryNumericCheck3 + binaryNumericCheck4 + binaryTrialNumberCheck1 + binaryTrialNumberCheck2 + binaryCurrentRowCheck1 + binaryCurrentRowCheck2;
                        
                        %All check has to pass, so totally SEVEN binary checkchecks here.
                        if binaryTotalRowCheck == 7
                            %store data into array
                            
                            rawIQDATColumnAData(intTrialNumber,1) = str2double(strIndexRowData{1}{4});
                            switch strIndexRowData{1}{6}
                                case 'deck1'
                                    rawIQDATColumnBData{intTrialNumber,1} = '1';
                                case 'deck2'
                                    rawIQDATColumnBData{intTrialNumber,1} = '2';
                                case 'deck3'
                                    rawIQDATColumnBData{intTrialNumber,1} = '3';
                                case 'deck4'
                                    rawIQDATColumnBData{intTrialNumber,1} = '4';
                            end
                            rawIQDATColumnCData(intTrialNumber,1) = str2double(strIndexRowData{1}{8});
                            rawIQDATColumnDData(intTrialNumber,1) = str2double(strIndexRowData{1}{9});
                        end
                    end
                end
            end
            
            %Must clear the headerRow variable to prevent carry over effect.
            
            
            
            %By now, all information should have been read into the array.
            
            %Send information to GROUP variable ONLY if both header row and
            %hunderdth row exist!
            if exist('intHeaderRow','var')==1 && exist('intHundredthRow','var')==1
                %Stparticipantore infromation inside a structure array.
                group(indexMainFolder).IQDATparticipant(indexFile).groupName = folderName;
                group(indexMainFolder).IQDATparticipant(indexFile).fileType = 'IQDAT';
                group(indexMainFolder).IQDATparticipant(indexFile).name = strIQDATFileNameNoExtension;
                group(indexMainFolder).IQDATparticipant(indexFile).choiceArray=rawIQDATColumnBData;
                group(indexMainFolder).IQDATparticipant(indexFile).winArray=rawIQDATColumnCData;
                group(indexMainFolder).IQDATparticipant(indexFile).lossArray=rawIQDATColumnDData;
            else
                disp(['Data import FAILED for Subject: ',strIQDATFileName])
                failSubjectCount = failSubjectCount + 1;
                failedSubjectArray{failSubjectCount,1} = folderName;
                failedSubjectArray{failSubjectCount,2} = strIQDATFileName;
            end
            disp(['All data import has been done for Subject: ',strIQDATFileName])
            
            %Close file ID or else might have overflow issue with incorrect
            %idFile
            fclose(idFile);
            
            %Need to clear variables to ensure no problem.
            clearvars intHundredthRow intHeaderRow rawIQDATColumnAData rawIQDATColumnBData rawIQDATColumnBData rawIQDATColumnCData strIndexRowData
            
            %More variables to clear.
            clearvars strIQDATFileName strIQDATFullPathName strIQDATPath strIQDATFileNameNoExtension idFile
        end
    else 
        group(indexMainFolder).IQDATparticipant=[]; 
    end
end

disp('All Participants have been processed')
if isempty(group)==false
    save('EVM_Ready_Export','group');
end
disp('Processing results have been saved in current direcotry as "EVM_Ready_Export.mat"')
disp(pwd)



