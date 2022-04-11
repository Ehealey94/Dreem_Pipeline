# Dreem_Pipeline

This is a preprocessing pipeline for dreem data files. Start out with the _master_ script, which rules them all.

The pipeline also contains some additional analysis options, such as calculating wpli, frontal alpha asymmetry and slope/offset

To run this script you need to download and add to your matlab path:
[title](https://www.example.com)
- [EEGLAB](https://sccn.ucsd.edu/eeglab/download.php)
- Sri's [manage_badTrials](https://github.com/SridharJagannathan/manage_badTrials)
- The matlab wrapper for [fooof tools](https://fooof-tools.github.io/fooof/auto_tutorials/index.html)

Additionally, make sure the [MATLAB signal processing toolbox](https://uk.mathworks.com/products/signal.html) is installed 

#### Update to .h5 file structure

Files recorded after July 2021 may have a new structure, so that the EEG data location has changed from
'/channel1/visualization'
to
'/eeg1/filtered' (3 notch filters+ bandpass filtered betweeb 0.4Hz and 35Hz)
or 
'/eeg1/raw'

for more information https://support.dreem.com/hc/en-gb/articles/360021664499-How-to-read-H5-file
