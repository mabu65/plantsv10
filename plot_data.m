function [M] = plot_data(T)
option = questdlg('Choose a figure type','Make Your Choice','T vs M','F vs M','T vs M');
switch option      
    case 'T vs M'
        keylist = inputdlg({'Channel','Frequency'},'Enter');
        keylist = string(keylist);
        channel = str2num(keylist(1));
        freq = str2num(keylist(2));
        if channel < 9 && channel > 0
            freqsel = T(T.f == freq, :);
            magnitudes = freqsel(freqsel.channel == channel, :);
            array = table2array(magnitudes);
            M = array(:,6);
            plot(M,'color','b');
            xlabel('time (hours)')
            ylabel('magnitude')
            title('Magnitude vs Time');
            legend(sprintf('channel %d',channel))
        end
    case 'F vs M' 
        keylist = inputdlg({'Channel'},'Enter');
        keylist = string(keylist);
        channel = str2num(keylist);
        channelsel = T(T.channel == channel,:);
        array = table2array(channelsel);
        Mag = array(:,6);
        Time = array(:,1);
        M = zeros(100,length(array)/100);
        t = zeros(100,length(array)/100);
        for n = 1:length(array)/100
            M(:,n) = Mag(100*n-99:100*n);
            t(:,n) = Time(100*n-99:100*n);
        end
        plot(M,'color','b')
        xlabel('frequency (KHz)')
        ylabel('magnitude')
        title('Magnitude vs Frequency');
        legend(sprintf('channel %d',channel))
end
M = {M option t};
end