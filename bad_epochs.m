function EEG=bad_epochs(inpath,outpath,i)

%[EEG, RejTrials]=bad_epochs(path)


cd (inpath)
files=dir('*.set')

for i=i
    %:length(files)
    filename=files(i).name
    [pathstr,name,ext] = fileparts([inpath filename])
    EEG=[];
    EEG = pop_loadset('filename',filename,'filepath',inpath);
    RejTrials(1,i)=EEG.trials;
    optns.reject = 1; optns.recon = 0;
    optns.threshold = 1; optns.slope = 0;
    try
        %[EEG,rejtrialcount] = preprocess_manageBadTrials(EEG,opts);
        %RejTrials(2,i)=rejtrialcount;
        EEG = preprocess_manageBadTrials(EEG,optns);
        EEG = pop_saveset( EEG, 'filename',[name '_rej_epoch.set'],'filepath', outpath);
        %RejTrials(3,i)=EEG.trials
     catch
%         RejTrials(2,i)=EEG.trials;
         fprintf(['error in file ' filename])
     end
    
end
end
