function [gainSet,commandStr] = PreSetting
gainList = {'1 Mohm','100 Kohm','10 Kohm','1 Kohm'};
[indx,tf] = listdlg('PromptString',{'Set a gain'},...
    'SelectionMode','single','ListString',gainList);
if tf == 1
    switch indx
        case 1
            gainSet = 1;
        case 2
            gainSet = 2;
        case 3
            gainSet = 3;
        case 4
            gainSet = 4;
    end
    commandCell = inputdlg({'Start Frequency (Hz)','Is Start Freq Fraction','Increment Frequency (Hz)',...
                        'Is Increment Freq Fraction','Num of Increment','Ref resistance (Ohm)',...
                        'Output range','PGA gain','Setting Cycles','Setting Cycle Multiplier',...
                        'Is Clock External'},'Enter');
    s = ['<',commandCell(1),',',commandCell(2),',',commandCell(3),',',commandCell(4),',',...
        commandCell(5),',',commandCell(6),',',commandCell(7),',',commandCell(8),'>'];
    commandStr = string([s{:}]);
    
end
end