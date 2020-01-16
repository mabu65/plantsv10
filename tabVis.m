clear
clc
[filename,pathname] = uigetfile('*.txt');
t = readtable([pathname filename]);

uf = uifigure;
uf.Position(3:4) = [700 450];


uit = uitable(uf,...
               'Data',t,...
               'Position',[50 120 600 300],...
               'ColumnEditable', true, ...
               'CellSelectionCallback',@CellSelection);
%                'CellEditCallback',@CellEdit,

pushed = uibutton(uf,...
                'Text','Modify',...
                'Position',[50 80 100 22],...
                'ButtonPushedFcn',@(hObject,event) PushedButtonCallback(hObject,uit));
deleted = uibutton(uf,...
                'Text','Delete',...
                'Position',[180 80 100 22],...
                'ButtonPushedFcn',@(hObject,event) DeletedButtonCallback(hObject,uit));

saved = uibutton(uf,...
                'Text','Save',...
                'Position',[310 80 100 22],...
                'ButtonPushedFcn',@(hObject,event) SavedButtonCallback(hObject,uit));
            
            
%     function CellEdit(hObject,event)
%         if eventdata.NewData < 0 || eventdata.NewData > 120
%             tableData = src.Data;
%             tableData{eventdata.Indices(1),eventdata.Indices(2)} = eventdata.PreviousData;
%             src.Data = tableData;                              % set the data back to its original value
%             warning('Age must be between 0 and 120.')          % warn the user
%         end
%     end
    
    function PushedButtonCallback(hObject,uit)
            dat = uit.Data;
            if width(dat) == 8
                dat.Properties.VariableNames = {'t','channel','f', 'R', 'I', 'M', 'temp', 'hum'};
            else
                warning('The VariableNames property must contain one name for each variable in the table.');
            end
            uit.Data = dat;
    end
    
    function DeletedButtonCallback(hObject,uit)
            dat = uit.Data;
            col = uit.UserData;
            dat(:,col) = [];
            uit.Data = dat;
    end
    function SavedButtonCallback(hObject,uit)
            filename=['Plants',datestr(now,30),'.txt'];
            writetable(uit.Data,filename);
    end
    
    function CellSelection(hObject,event)
    dat = event.Indices; 
        if dat(1) == 1 && length(dat(:,1)) > 1
            col = dat(1,2);
            hObject.UserData = col;
        end
    end