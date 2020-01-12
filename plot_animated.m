function [datareg] = plot_animated(handles)
t = handles.t;
s = handles.s;
text = handles.text;  
datareg = handles.datareg;
if t.NumBytesAvailable > 0
    getData = readline(t);
    getData = strsplit(getData,','); 
    pdata = str2num(join(getData));
   if isempty(pdata) == 0
      time = pdata(1)/100;
      Mag = pdata(6);      
      addpoints(s, time, Mag);
      drawnow
      datareg = [datareg;pdata];
      text.String = ['channel:',num2str(pdata(2)),10,'time:',...
                    num2str(pdata(1)/100),10,'Mag:',num2str(pdata(6))];
   end
end
end
