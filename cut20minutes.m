function EEG=cut20minutes(inpath,outpath,i,newlength)


cd (inpath)
files=dir('*.set');
unusedpath=['/Users/jachs/Desktop/Jamyang_Project/DreemEEG/8725/unused recordings/'];

for i=i
    
    filename=files(i).name;
    [pathstr,name,ext] = fileparts([inpath filename]);
    EEG=[];
    EEG = pop_loadset('filename',filename,'filepath',inpath);
    originallength=EEG.trials;
    if originallength<=100
        movefile([inpath filename '*'], unusedpath );
        disp ("too short, file moved")
    elseif originallength > 100 && originallength <newlength
        disp ("the meditation is shorter than 20 minutes")
        
        for ii=1:length(EEG.event)
            EEG.event(ii).type='Med';
        end
        EEG = pop_saveset( EEG, 'filename',[name '_labelled.set'],'filepath', outpath);
       
    else
        eegplot(EEG.data, 'spacing',300,'winlength',10,'position',[100 100 1400 600]);
        
        
        prompt=[num2str(originallength-newlength) ' superfluous epochs./ When did meditation start (epoch number)']
        x = input(prompt);
        
        for ii=1:length(EEG.event)
            if EEG.event(ii).epoch >= x && EEG.event(ii).epoch<(newlength+x)
                EEG.event(ii).type='Med';
            end
        end
        
        prompt='When did rest start (epoch number)'
        y = input(prompt);
        
        for ii=1:length(EEG.event)
            if EEG.event(ii).epoch >= y && EEG.event(ii).epoch<(15+y)
                EEG.event(ii).type='Rest';
            end
        end
        EEG.epochdescription={'MedStartEpoch',x;'RestStartEpoch',y};
        
        EEG = pop_saveset( EEG, 'filename',[name '_labelled.set'],'filepath', outpath);
       
    end
    
end
end
