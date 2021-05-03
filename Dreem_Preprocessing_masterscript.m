%Dreem EEG analysis script
% This script loads the eeg data from h5 files into variable 'data'
%insert these folders into the path
%Files are sorted by participants:
% pathdirectory/participantname/file.h5, then directed to subfolders
% pathdirectory/participantname/subfolder/EEGfile

eeglab

% adapt this
participant='8725';
path=['/Users/jachs/Desktop/Jamyang_Project/DreemEEG/' participant '/']
cd (path)

% make directories
mkdir ('1-matfiles')
mkdir ('2-setfiles')
mkdir ('3-cutfiles')
mkdir ('4-epoch4secs')

%create mat file from .h5
[data,start_time]=h5tomat(path)

%create set file
mattoeeg(path)

%highpass filter to minimise drift = 1
hp=1;
dreem_highpass(path,hp)

%length of each recording
%rec_length=dreemlength(path,part) %n datapoints
%rec_length(2,:)=rec_length(1,:)/250 % length in seconds
%rec_length(3,:)=rec_length(2,:)/60 % length in minutes


%epoch
inpath=[path '/3-cutfiles/']
outpath=[path '/4-epoch4secs/']

epoch_length=4;

dreem_8secs(inpath,outpath,epoch_length)

%% cut the files to correct start/end location
% to cut manually, open eeglab > edit > selectdata by epoch or time
% then save the file into a folder called 5-cut

participant='8725';
path=['/Users/jachs/Desktop/Jamyang_Project/DreemEEG/' participant '/'];
cd (path);

mkdir ('5-cut')
mkdir ('6-rej_epoch')
mkdir ('6-removechan')
% 
% close all
% i=44;
% 
% newlength=301;
% inpath=[path '/4-epoch4secs/'];
% outpath=[path '/5-cut/'];
% 
% EEG=cut20minutes(inpath,outpath,i,newlength);
%% now clean the data by rejecting bad epochs using an adapted version
% of Sri's bad_epochs script
i=1
inpath=[path '/5-cut/'];
outpath=[path '/6-rej_epoch/'];

EEG=bad_epochs(inpath,outpath,i);
ep=(EEG.rejepoch)';

eeglab redraw
EEG.setname
%% Get the epoch count
participant='5644_YaroslaveFalcon/';
folder='/5-rej_epoch/';
inpath=['/Users/jachs/Desktop/Jamyang_Project/DreemEEG/' participant folder];

epoch_count=countepochs(inpath);


%% remove channels
%participant='7135_TampicoWallaby/';
folder='/5-cut/';
inpath= ['/Users/jachs/Desktop/Jamyang_Project/DreemEEG/' participant folder];

name=['646516'];
filename=[name '_hp_4sec_labelled.set'];

EEG = pop_loadset('filename',filename,'filepath',inpath);
eeglab redraw

% Once you have checked your data again in eeglab,
% select channels to be removed 
chan=[];
EEG.data(chan,:,:)=0;
eeglab redraw
%save dataset
mkdir ('6-removechan')
outfolder=['/6-removechan/']
outpath=['/Users/jachs/Desktop/Jamyang_Project/DreemEEG/' participant outfolder];
EEG = pop_saveset( EEG, 'filename',[name '_rmchan.set'],'filepath', outpath);

%% clean again
%path=cd;

inpath=[path '/6-removechan/'];
outpath=[path '/6-rej_epoch/'];
%select which number of file in this folder
i=1
EEG=bad_epochs(inpath,outpath,i);
ep=EEG.rejepoch';
eeglab redraw

%% Run Hilbert
inpath=[path '6-rej_epoch']
outpath=[path '12-alphadata']
mkdir(outpath)
% dreemhilbert calls runhilbert, third input is desired frequency band
% choose from alpha beta theta delta gamma
hilbdata = dreemhilbert(inpath,outpath,'alpha');

%%
% Creating three ROIs
%Frontal, local
% FPz - F2 = EEG.data(3,:,:)
% FPz - F8 = EEG.data(7,:,:)
% F8 - F2 = EEG.data(4,:,:)

% Global
% FPz - O1 = EEG.data(1,:,:)
% FPz - O2 = EEG.data(2,:,:)
% F7 - O1 = EEG.data(5,:,:)
% F8 - O2 = EEG.data(6,:,:)

% Occipital, local
% = 2 - 1
% = (FPz - O2) - (FPz - O1)
% = FPz- O2 - FPz + O1
% = -O2 + O1
%
% O1-O2 = EEG.data(2,:,:)-EEG.data(1,:,:)
% EEG.data(8,:,:)=EEG.data(2,:,:)-EEG.data(1,:,:)


% TEST: use the same calculation to calculate existing channel 4;
%
% (chan 3 - chan 7) should be the same as channel 4

% EEG.data(9,:,:)=EEG.data(3,:,:)-EEG.data(7,:,:)
%% calculate wPLI
eeglab

%Jamyang
ParticipantList={'1425','1733_BandjarmasinKomodoDragon', '1871','1991_MendozaCow','2222_JiutaiChicken',...
    '2743_HuaianKoi','2965','3604','3614','3938_UlsanAlligator','8683_CotonouFox','8725'};

for p=1:length(ParticipantList)
    
    participant=ParticipantList{p};
    
    %path=['/Users/jachs/Desktop/Valencia/1 Retreat March 2019/EEG-Group1/' participant '/'];;
    %Jamyang
    path=['/Users/jachs/Desktop/Jamyang_Project/DreemEEG/' participant '/']
    
    cd (path)
    
    mkdir ('9-wplidata')
    
    inpath=[path '6-rej_epoch/'];
    outpath=[path '9-wplidata/']
    cd (inpath)
    files=dir('*.set')
    
    for i=1:length(files)
        filename=files(i).name
        [pathstr,name,ext] = fileparts([inpath filename])
        EEG=[];
        EEG = pop_loadset('filename',filename,'filepath',inpath);
        
        %get the session name
        editname=erase(name,'_cut_4sec_rej_epoch');
        newname=erase(editname,'_rmchan_rej_epoch');
        
        hilbdata=hilbamp(EEG);
        wplidata= zeros(size(EEG.data,3),10,4);
        try
            %want matrix trial,frequency for two channel combinations
            %1
            channels=[1,3];
            wplidata(:,1,1:5)=calcwplitrials(hilbdata,channels);
            %2
            channels=[1,4];
            wplidata(:,2,1:5)=calcwplitrials(hilbdata,channels);
            %3
            channels=[1,5];
            wplidata(:,3,1:5)=calcwplitrials(hilbdata,channels);
            %4
            channels=[1,7];
            wplidata(:,4,1:5)=calcwplitrials(hilbdata,channels);
            %5
            channels=[3,4];
            wplidata(:,5,1:5)=calcwplitrials(hilbdata,channels);
            %6
            channels=[3,5];
            wplidata(:,6,1:5)=calcwplitrials(hilbdata,channels);
            %7
            channels=[3,7];
            wplidata(:,7,1:5)=calcwplitrials(hilbdata,channels);
            %8
            channels=[4,5];
            wplidata(:,8,1:5)=calcwplitrials(hilbdata,channels);
            %9
            channels=[4,7];
            wplidata(:,9,1:5)=calcwplitrials(hilbdata,channels);
            %10
            channels=[5,7];
            wplidata(:,10,1:5)=calcwplitrials(hilbdata,channels);
            
            wpli_delta=squeeze(mean(wplidata(:,:,1),2));
            wpli_theta=squeeze(mean(wplidata(:,:,2),2));
            wpli_alpha=squeeze(mean(wplidata(:,:,3),2));
            wpli_beta=squeeze(mean(wplidata(:,:,4),2));
            wpli_gamma=squeeze(mean(wplidata(:,:,5),2));
            
            %         wplidata14=calcwplitrials(hilbdata,channels);
            %         channels=[5,7];
            %         wplidata57=calcwplitrials(hilbdata,channels);
            
            
            save([outpath newname '_wplidata'],'wpli_delta','wpli_theta','wpli_alpha','wpli_beta','wpli_gamma')
        catch
            disp(['could not calc wpli for ' newname])
        end
    end
end

%% calculate the frontal alpha asymmetry FAA
eeglab
%change to your participant name
ParticipantList={'1425', '1871','2965','3604','3614'}

for p=1:length(ParticipantList)
    
    participant=ParticipantList{p};
    path=['/Users/jachs/Desktop/Valencia/1 Retreat March 2019/EEG-Group1/' participant '/'];;
    %Jamyang
    %path=['/Users/jachs/Desktop/Jamyang_Project/DreemEEG/' participant '/']
    
    cd (path)
    
    mkdir ('10-faadata')
    % inpath=[path '7-med/'];
    inpath=[path '5-rej_epoch/']
    outpath=[path '10-faadata/']
    cd (inpath)
    files=dir('*.set')
    
    for i=1:length(files)
        filename=files(i).name;
        [pathstr,name,ext] = fileparts([inpath filename]);
        EEG=[];
        EEG = pop_loadset('filename',filename,'filepath',inpath);
        
        %Valencia
        editname=erase(name,'_cut_4sec_rej_epoch');
        newname=erase(editname,'_rmchan_rej_epoch');
        
        %Jamyang
        %newname=erase(name,'_med');
        try
            faa=dreem_faa(EEG);
            save([outpath newname '_faadata'],'faa')
        catch
            disp(['could not comoute faa for ' newname])
        end
        
    end
end
%% Calculate the offset and slope
% % this requires the fooof toolbox 
ParticipantList={'1425','1733_BandjarmasinKomodoDragon', '1871','1991_MendozaCow','2222_JiutaiChicken',...
   '2743_HuaianKoi','2965','3604','3614','3938_UlsanAlligator','8683_CotonouFox','8725'};


for p=1:length(ParticipantList)
    
    
    participant=ParticipantList{p};
    %Jamyang
    path=['/Users/jachs/Desktop/Jamyang_Project/DreemEEG/' participant '/']
    
    cd (path)
    
    mkdir ('11-fooofdata')
    inpath=[path '7-med/']; %J
    %inpath=[path '5-rej_epoch/']; %R
    outpath=[path '11-fooofdata/']
    cd (inpath)
    files=dir('*.set')
    
    for i=1:length(files)
        filename=files(i).name;
        [pathstr,name,ext] = fileparts([inpath filename]);
        EEG=[];
        EEG = pop_loadset('filename',filename,'filepath',inpath);
        
        %Valencia
        %editname=erase(name,'_cut_4sec_rej_epoch');
        %newname=erase(editname,'_rmchan_rej_epoch');
        
        %Jamyang
        newname=erase(name,'_med');
        
        %try
        channelselection=[1,3,4,5,7];
        [offset,exponent]=dreem_fooof(EEG,channelselection);
            
        save([outpath newname '_fooofdata'],'offset','exponent')
            
        %catch
        
        %disp(['could not compute fooof for ' newname])
        
        %end
        
    end
end