function data=select2channels(path,chan1,chan2)

inpath=[path 'epoch8secs/'];
outpath=[path '2channels/'];

cd (inpath)
files=dir('*8sec.set')

for i=1:length(files)
    filename=files(i).name
    [pathstr,name,ext] = fileparts([inpath filename])
    EEG=[];
    EEG = pop_loadset('filename',filename,'filepath',inpath);
    
    EEG=pop_select(EEG,'channel',[3,4])
    
    EEG = pop_saveset( EEG, 'filename',[name '2chan.set'],'filepath', outpath);

end
end
