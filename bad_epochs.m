function [EEG,RejTrials]=bad_epochs(path)

inpath=[path '2channels/'];
outpath=[path 'rej_by_epochs/'];

cd (inpath)
files=dir('*2chan.set')

for i=1:length(files)
    filename=files(i).name
    [pathstr,name,ext] = fileparts([inpath filename])
    EEG=[];
    EEG = pop_loadset('filename',filename,'filepath',inpath);
    RejTrials(1,i)=EEG.trials;
    opts.reject = 1; opts.recon = 0;
    opts.threshold = 1; opts.slope = 0;
    try
        [EEG,rejtrialcount] = preprocess_manageBadTrials(EEG,opts);
        RejTrials(2,i)=rejtrialcount;
        
        EEG = pop_saveset( EEG, 'filename',[name '_rej_epoch.set'],'filepath', outpath);
        RejTrials(3,i)=EEG.trials
    catch
        RejTrials(2,i)=EEG.trials;
        fprintf(['error in file ' filename])
    end
    
end
end
