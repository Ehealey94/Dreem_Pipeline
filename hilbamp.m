function hilbdata=hilbamp(EEG)

% calculate power using the Hilbert transform
times = EEG.times;

freqbin = 1:1:46; %original 1:1:31 for thrity bins

hilbdata = runhilbert(EEG,freqbin);
%hilbdata = abs(hilbdata).^2; kills the imaginary part to give power


end

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
