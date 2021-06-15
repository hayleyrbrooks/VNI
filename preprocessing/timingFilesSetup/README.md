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

Onset files contain three columns: onset, duration, parametric modulation

For each participant, there are 3 onset files (corresponding to each run) for all of the following onset files listed below (i.e. a lot of timing files for each participant)

### Choice display (onset = stimulus window onset, duration = stimulus window + decision window):
1) Choice display modulated by mean expected value
2) Choice display modulated by risky gain amount
3) Choice display modulated by safe amount

### Outcome display 
1) Outcome display modulated by outcome amount
2) Outcome display for risky win outcome, modulated by amount
3) Outcome display for risky loss outcome, modulated by amount (?? this is zero, change to received-not received)
4) Outcome display for safe outcome, modulated by amount

### Decision
~ coming soon

### handling scanner settling (15 seconds fixation etc)
~ coming soon

### handing missed trials
~ coming soon

### adding onset files to RDAC
~ coming soon
