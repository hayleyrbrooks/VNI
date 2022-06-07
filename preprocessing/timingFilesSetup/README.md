# Setting up timing files for VNI fMRI analysis (using FSL)

## Event files
Onset files (fsl-specific) for the analysis are created from the event files. 

Each participant has an event file for each of the three runs and the event files contain the event name, trial number, event onset, event duration for each event in the task. 

Event files location: /shlab/Projects/VNI/data/mriTimingFiles/eventFiles/
Event file name example: "sub-001_run1_event.csv"
### Event types:
- trial start 
- stimulus start (forced viewing for 2s)
- decision window (up to 2 seconds, changes once participants responds)
- ISI (variable: 1.75-5.75s)
- outcome display (1 second)
- ITI (variable: .75-4.75s, includes left over time from decision window)


## Onset files (for FSL)
Onset files are created by the script [createTimingFiles.Rmd](./createTimingFiles.Rmd)

Onset files location: /shlab/Projects/VNI/data/mriTimingFiles/onsetFiles/
Onset files contain three columns: onset, duration, parametric modulation. Parametric modulations are mean-centered by each functional run for each participant.

For each participant, there are 3 onset files (corresponding to each run) for all of the following onset files listed below (i.e. a lot of timing files for each participant)

Modulation amounts in onset files are mean-centered and scaled by max(riskyGain) which is $60.99. This is consistent with our behavioral analysis.

### Choice display (onset = stimulus window onset, duration = stimulus window + decision window):
1) Choice display modulated by mean expected value
2) Choice display modulated by risky gain amount
3) Choice display modulated by safe amount
4) Choice display with no modulation

### Outcome display 
1) Outcome display modulated by outcome amount
2) Outcome display for risky win outcome, modulated by amount
3) Outcome display for risky loss outcome, modulated by amount (?? this is zero, change to received-not received)
4) Outcome display for safe outcome, modulated by amount
5) Outcome display for all otucomes, no modulation

### Decision
1) Decision modulated by mean EV
2) Decision modulated by risky gain amount
3) Decision modulate by safe amount
4) Gamble decision modulated by mean EV
5) Gamble decision modulated by risky gain amount
6) Gamble decision modulated by safe amount
7) Safe decision modulated by mean EV
8) Safe decision modulated by risky gain amount
9) Safe decision modulated by safe amount

### handling scanner settling (15 seconds fixation etc)
- In the onset files (but *NOT* event files), all onsets are adjusted by .6087 seconds. We had a 15 second fixation prior to the start of the first trial in each run to allow the scanner to "settle". Our TRs were .46s, so 15s/.46s = 32.6087 volumes. We can't remove 32.6087 volumes, so we removed 32 and offset all timing files by the extra .6087s. In fMRIprep, we specified that the first 32 volumes should not be preprocessed (note that fmriprep doesn't remove these volumes, it just doesn't preprocess so we will need to either remove them from the preprocessed functional data or just tell FSL to skip - depends on what FSL does with timing files when you tell it to delete volumes - e.g. does it skip the first 15s of the timing file?).

### handing missed trials
- Missed trials files location: /shlab/Projects/VNI/data/mriTimingFiles/missedTrials/
- For participants who did not miss any trials on a given run, they have all zeroes EV files (3-columns)
- For paricipants who did miss trials on a given run, those files are made for specific analysis (e.g. outcome display)

### adding onset files to RDAC
use Cyber Duck or FUGU to move timing files to RDAC (/data/psychology/sokol-hessnerlab/VNI/timingFiles/)

### note that the onset files don't need to be trimmed because they mark the start AFTER the 32 volumes have been removed.
