function hilbdata=dreemhilbert(inpath, outpath,freqband)
if freqband=='alpha'
    freqbin=[8:0.5:13];
elseif freqband=='beta'
    freqbin=[16:0.5:31];
elseif freqband=='theta'
    freqbin=[4:0.5:7];
elseif freqband=='delta'
    freqbin=[0.5:0.5:4];
else 
    disp('not a valid frequency band')
end
cd (inpath)
files=dir('*.set')
mkdir(outpath)
for i=1:length(files)
    filename=files(i).name
    [pathstr,name,ext] = fileparts([inpath filename])
    EEG=[];
    EEG = pop_loadset('filename',filename,'filepath',inpath);
    hilbdata=runhilbert(EEG,freqbin);
    hilbdata = abs(hilbdata).^2; %kills the imaginary part to give power
    SqueezeFrequencies=squeeze(mean(hilbdata)); % averages across the  frequency bin
    hilbdata=squeeze(mean(SqueezeFrequencies,2)); %Averages across the 1000 seconds in the epoch
    newname=[outpath '/hilbdata_' freqband ];
    save(newname,'hilbdata')
end
end
