function [M] = plot_data(T)
option = questdlg('Choose a figure type','Make Your Choice','T vs M','F vs M','T vs M');
switch option      
    case 'T vs M'
        keylist = inputdlg({'Channel','Frequency'},'Enter');
        keylist = string(keylist);
        if isempty(keylist) == 0
            channel = str2num(keylist(1));
            freq = str2num(keylist(2));
            if channel < 9 && channel > 0
                freqsel = T(T.f == freq, :);
                magnitudes = freqsel(freqsel.channel == channel, :);
                array = table2array(magnitudes);
                M = array(:,6);
                t = array(:,1);
                plot(M,'color','b');
                xlabel('time')
                ylabel('magnitude')
                title('Magnitude vs Time');
                legend(sprintf('channel %d',channel))
            end
        else
            M = 0;
            t = 0;
        end
    case 'F vs M' 
        keylist = inputdlg({'Channel'},'Enter');
        keylist = string(keylist);
        if isempty(keylist) == 0
            channel = str2num(keylist);
            channelsel = T(T.channel == channel,:);
            array = table2array(channelsel);
            Mag = array(:,6);
            Time = array(:,1);
            Freq = array(:,3);
            Divisor = numel(unique(Freq));
            M = zeros(Divisor,length(array)/Divisor);
            t = zeros(Divisor,length(array)/Divisor);
            for n = 1:length(array)/Divisor
                M(:,n) = Mag(Divisor*(n-1)+1:Divisor*n);
                t(:,n) = Time(Divisor*(n-1)+1:Divisor*n);
            end
            plot(M,'color','b')
            xlabel('frequency (KHz)')
            ylabel('magnitude')
            title('Magnitude vs Frequency');
            legend(sprintf('channel %d',channel))
        else
            M = 0;
            t = 0;
        end
    otherwise
        M = 0;
        option = 0;
        t = 0;
end
M = {M option t};
end