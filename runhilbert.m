
function hilbdata = runhilbert(EEG,freqbin)
nbin = length(freqbin)-1;

hilbdata = zeros(nbin,EEG.nbchan,EEG.pnts,EEG.trials);

for f = 1:nbin
    filtEEG = pop_eegfiltnew(EEG,freqbin(f),freqbin(f+1));
    hilbdata(f,:,:,:) = filtEEG.data;
    for t = 1:EEG.trials
        hilbdata(f,:,:,t) = hilbert(squeeze(hilbdata(f,:,:,t))')';
    end
end
end

