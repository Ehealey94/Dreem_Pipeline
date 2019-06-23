function EEG=bad_epochs(path)

%[EEG, RejTrials]=bad_epochs(path)

inpath=[path '4-epoch8secs/'];
outpath=[path '5-rej_epoch/'];

cd (inpath)
files=dir('*8sec.set')

for i=1:length(files)
    filename=files(i).name
    [pathstr,name,ext] = fileparts([inpath filename])
    EEG=[];
    EEG = pop_loadset('filename',filename,'filepath',inpath);
    RejTrials(1,i)=EEG.trials;
    opts.reject = 1; opts.recon = 0;
    opts.threshold = 1; opts.slope = 0;
    %try
        %[EEG,rejtrialcount] = preprocess_manageBadTrials(EEG,opts);
        %RejTrials(2,i)=rejtrialcount;
        EEG = preprocess_manageBadTrials(EEG,opts);
        EEG = pop_saveset( EEG, 'filename',[name '_rej_epoch.set'],'filepath', outpath);
        %RejTrials(3,i)=EEG.trials
%     catch
%         RejTrials(2,i)=EEG.trials;
%         fprintf(['error in file ' filename])
%     end
    
end
end
