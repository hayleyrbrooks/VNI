# Design parameters for VNI risky decision-making task

#### Goals:
  1. Capture a variety of possible risk-taking behavior (very risk averse to very risk-seeking).
  2. Create context, keep it the same for a bit, then change it (with the least moving parts (confounds) possible).



## Choice set features
- Participants chose between a gamble (50/50 chance of a win ($+) and loss ($0)) and a smaller, guaranteed alternative, or a safe option (+$)
- Possible risky gain values $0 - $60
- Possible loss values $0 
- Possible safe values $0 - $30
- 219 trials 

### Context
- Five discrete levels of context defined by mean expected values
  - mean expcted value is defined as ((risky gain x probability + risky loss x probability) + (safe x probability))/2
    - e.g. (($60 x .5 + $0 x .5) + ($20 x 1))/2 = 25
  - levels, or  mean expected values: 5,10,15,20,25
  - On each trial, the mean expected value is +/- .50 from the mean expected value of the context (to create some noise)
  - Variance at each level is identical
- Context was set up in the task by 4 "runs" of trials at each level 
  - Runs contained 6,9,12,15 trials  
  - The starting context consited of a fifth run with 9 trials to ensure a shift *back* to that level
  - 21 runs total
  - 42 trials at each level of context with the exception of 51 trials at the starting context
    - This number was in part determined by time constraints (i.e. how many trials we could fit in the task) 
    - 28 of 42 trials were sampled from a combination of risky gain and safe combinations that were close to indifference and the other 14 trials were sampled on the edges 
- Context changed following a shift up or down to the next context
  - 20 total shifts to ensure that for each level of context, there was a shift to-and-from the other contexts
- All participants experienced the same shifts and run sizes but the order was random
- Two types of attention check trials
    1. risky gain is very large ( > $50) and safe option is $0 (participants should accept the gamble)
      - there are 0 to 4 of these trials (0 for 3 participants because of coding error that was fixed after the 10th participant)
      - most participants had 2-3
    3. safe option is >= risky gain amount (participants should reject the gamble)
      - there are 12 to 17 trials (most participants had 14)


### Figures: Using a single subject's actual choice set

#### Figure 1. Five levels of context defined by a mean expected value (each point is a trial).
![singleSubLevelsOfcontext](https://user-images.githubusercontent.com/19710394/118754277-f0e77980-b823-11eb-9cb3-8afe9505d9cb.png)

#### Figure 2. Mean expected values across the task.
![singleSubMeanEVacrossTask](https://user-images.githubusercontent.com/19710394/118754287-f5ac2d80-b823-11eb-8f5b-69960cbbaede.png)

#### Figure 3. Safe values across the task
![singleSubSafeacrossTask](https://user-images.githubusercontent.com/19710394/118754296-f9d84b00-b823-11eb-90ae-e9303217ee48.png)




## Task structure and timing

#### Figure 4 Structure and timing of a single trial
![trialStructure](https://user-images.githubusercontent.com/19710394/118421794-096a5f00-b67f-11eb-98bc-6728b0a90ad3.png)

######
ISIs: 1.75 to 5.75s
ITIs: .75 to 4.75s (+ 2s-RT from choice display)
Task was split up into 3 blocks of 73 trials
Each block was 12.025 minutes
Average trial time is 9.88s 




