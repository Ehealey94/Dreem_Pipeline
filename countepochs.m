function epoch_count=countepochs(inpath)

cd (inpath)
files=dir('*.set')

for i=1:length(files)
    filename=files(i).name
    [pathstr,name,ext] = fileparts([inpath filename])
    EEG=[];
    EEG = pop_loadset('filename',filename,'filepath',inpath);
    epoch_count(i)=length(EEG.epoch)
  
end


end