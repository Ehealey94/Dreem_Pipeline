function wpli=calcwplitrials(data,channels)
% 
% loadpathsbi
% loadsubjbi
% 
% data = load([filepath '/epoched/wpli/single_trials/hilbert/' basename '_morse_[1]_hilb.mat'], 'hilbdata');
% hilbdata = data.hilbdata;
hilbdata=data(:,channels,:,:);
nbin = size(hilbdata,1);
nchan = size(hilbdata,2);
npoints = size(hilbdata,3);
ntrials = size(hilbdata,4);

winlen = 300;
winstep = 1;
sampbin = 1:winstep:npoints-winlen;

nchanpairs = ((nchan*nchan)-nchan)/2;
chanlist = zeros(nchanpairs,2);

cpidx = 0;
for chann1 = 1:nchan
    for chann2 = 1:nchan
        if chann1 < chann2
            cpidx = cpidx + 1;
            chanlist(cpidx,:) = [chann1 chann2];
        end
    end
end

for t = 1:ntrials
    conjprod = imag(hilbdata(:,chanlist(:,1),:,t) .* conj(hilbdata(:,chanlist(:,2),:,t)));
    absprod = abs(conjprod);
    hilbwpli = zeros(nbin,nchanpairs,sampbin(end)+winstep-1);
    
    %fprintf('\nTrial %d, timepoint 1',t);
    for winidx = 1:winstep:npoints-winlen
        if mod(winidx,50) == 0
        %    fprintf('..%d',winidx);
        end
        hilbwpli(:,:,winidx) = abs(mean(conjprod(:,:,winidx:winidx+winlen-1),3)) ./ mean(absprod(:,:,winidx:winidx+winlen-1),3);
    end
    
    %average for delta
    wpli(t,1)=mean(hilbwpli(1:3,:,:),'all');
    
    %average for theta
    wpli(t,2)=mean(hilbwpli(4:8,:,:),'all');
    
    %average for alpha
    wpli(t,3)=mean(hilbwpli(8:12,:,:),'all');
    
    %average for beta
    wpli(t,4)=mean(hilbwpli(12:30,:,:),'all');
    
    %average for gamma
    wpli(t,5)=mean(hilbwpli(30:45,:,:),'all');
    
    %fprintf('\n');
    
    %fprintf('\nSaving %s%s_morse_hilbwpli_t%d.mat.\n',[filepath '/epoched/wpli/single_trials/hilbert/stwPLI/'],basename,t);
    %save(sprintf('%s%s_morse_hilbwpli_t%d.mat',[filepath '/epoched/wpli/single_trials/hilbert/stwPLI/'],basename,t),'hilbwpli','chanlist','-v7.3');
end
