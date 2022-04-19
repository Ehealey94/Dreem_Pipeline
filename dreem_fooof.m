function [Offset_mean,Exponent_mean]=dreem_fooof(EEG,channelselection)

nchan= size (EEG.data,1);

existingchannels=1:nchan;

Offset=[];
Exponent=[];

for ch=1:nchan

    escape=1;
    channels=squeeze(EEG.data(ch,:,:));
    
    %while escape==1
    
    if sum(channels,'all')==0
        existingchannels(existingchannels==ch)=[];
        escape=0;
        continue
    end
    
    
    % Calculate power spectra with Welch's method
    s_rate=250;
    
    [psds, freqs] = pwelch(channels, 125, [], [], s_rate);
    
    %[psds, freqs] = pwelch(channels, 250, [], [], s_rate);
    % Transpose, to make FOOOF inputs row vectors
    freqs = freqs';
    
    % FOOOF settings
    settings = struct();
    f_range = [1, 50];
    
    % Run FOOOF across a group of power spectra
    
     try
         fooof_results = fooof_group(freqs, psds, f_range, settings);
         
     catch
         %  didntwork{d}=FileID{s}
         existingchannels(existingchannels==ch)=[];
         %             d=d+1;
         %             fprintf('did not work for %s', FileID)
     end
     %
     % Check out the FOOOF Results
    %        fooof_results;
    
    for i=1:length(fooof_results)
        Offset(i,ch)=fooof_results(i).aperiodic_params(1);
        Exponent(i,ch)=fooof_results(i).aperiodic_params(2);
    end
end

chans=intersect(channelselection,existingchannels);

%average across all channels
Offset_mean=mean(Offset(:,chans),2);
Exponent_mean=mean(Exponent(:,chans),2);

end