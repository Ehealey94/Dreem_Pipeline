function hilbfaa=dreem_faa(EEG)

LeftChanID= 3 ;%F7-FPz
RightChanID= 7 ;%F8-FPZ

times = EEG.times;

freqbin = 8:13; %original 1:1:31 for thrity bins

hilbdata = runhilbert(EEG,freqbin);
hilbdata = abs(hilbdata).^2; %kills the imaginary part to give power

try
%Average across alpha, select channel, average across time,keep trials
Pow_L=mean(squeeze(mean(hilbdata(:,LeftChanID,:,:),3)));
Pow_R=mean(squeeze(mean(hilbdata(:,RightChanID,:,:),3)));
hilbfaa=log(Pow_R)-log(Pow_L);
catch
    fprintf('Could not compute FAA')
end
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
