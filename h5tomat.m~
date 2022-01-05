function [data,start_time]=h5tomat(path)
cd (path)
files=dir('*.h5')
for i=1:length(files)
    filename=files(i).name
    [pathstr,name,ext] = fileparts([path filename]);
    data=[];
    
%     starttime
    start(i)=h5readatt([path filename], '/', 'start_time');  

    datasetname='/eeg1/filtered';
    data(:,1) = h5read([path filename], datasetname);
    datasetname='/eeg2/filtered';
    data(:,2) = h5read([path filename ], datasetname);
    datasetname='/eeg3/filtered';
    data(:,3) = h5read([path filename ], datasetname);
    datasetname='/eeg4/filtered';
    data(:,4) = h5read([path filename ], datasetname);
    try
        datasetname='/eeg5/filtered';
        data(:,5) = h5read([path filename ], datasetname);
        datasetname='/eeg6/filtered';
        data(:,6) = h5read([path filename ], datasetname);
        datasetname='/eeg7/filtered';
        data(:,7) = h5read([path filename ], datasetname);
        disp ('7 channels')
    catch
        disp('4 channels')
    end
    
    start_time=h5readatt([path filename ],'/','start_time');
    changedate=1522108800; % from 27 March 2018, signal=signal*2
    
    if start_time<changedate
        data=data*2;
    end
    
    save([path '/1-matfiles/' name '.mat'],'data')
    
end

start_time=datetime(start,'ConvertFrom','posixtime')  

end