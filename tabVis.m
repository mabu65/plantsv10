% clear
% clc
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
            
ploted = uibutton(uf,...
                'Text','Plot',...
                'Position',[450 80 100 22],...
                'ButtonPushedFcn',@(hObject,event) PlotedButtonCallback(hObject,uit));
            
test = uibutton(uf,...
                'Text','test',...
                'Position',[50 50 100 22],...
                'ButtonPushedFcn',@(hObject,event) testCallback(hObject,uit));
            
            
%     function CellEdit(hObject,event)
%         if eventdata.NewData < 0 || eventdata.NewData > 120
%             tableData = src.Data;
%             tableData{eventdata.Indices(1),eventdata.Indices(2)} = eventdata.PreviousData;
%             src.Data = tableData;                              % set the data back to its original value
%             warning('Age must be between 0 and 120.')          % warn the user
%         end
%     end

    function testCallback(hObject,uit)
        row = 5;
        col = 5;
        
        jUIScrollPane = findjobj(uit);
        jUITable = jUIScrollPane.getViewport.getView;
        jUITable.changeSelection(row-1,col-1, false, false);
    end
    
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
            datT = uit.UserData;
            if datT{2} == 1
                col = datT{1};
                dat(:,col) = [];
                uit.Data = dat;
            else
                warning('Have Not Selected Data Yet');
            end
    end
    
    function SavedButtonCallback(hObject,uit)
            filename=['Plants',datestr(now,30),'.txt'];
            writetable(uit.Data,filename);
    end
    
    function PlotedButtonCallback(hObject,uit)
            dat = uit.Data;
            datT = uit.UserData;
            if datT{2} == 2
                row = datT{1};
                plot(table2array(dat(row,1)),table2array(dat(row,6)));
            elseif datT{2} == 3
                row = datT{1};
                plot(table2array(dat(row,3)),table2array(dat(row,6)));
            end
    end
    
    function CellSelection(hObject,event)
    dat = event.Indices; 
        if dat(1) == 1 && length(dat(:,1)) == height(hObject.Data)
            col = dat(1,2);
            hObject.UserData = {col,1};
        elseif dat(:,2) == 1
            row = dat(:,1);
            hObject.UserData = {row,2};
        elseif dat(:,2) == 3
            row = dat(:,1);
            hObject.UserData = {row,3};            
        end
    end