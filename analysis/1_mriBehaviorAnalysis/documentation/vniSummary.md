# VNI summary of behavior and fMRI analysis (Winter 2023)

## PARTICIPANTS
- N=48
- 3 participants excluded based on 4 criteria (subs 16, 42, 43; see QA document for details)
- 33 females; 14 males; 1 non-binary
- Mean age (sd) = 24.47(4.67), median age = 24, age range = 18-35 years


## BEHAVIOR
### Basic behavior data info
- 84 missed trials across 24 participants
- Mean missed trials = 1.75 trials; range = 0-11; median = .5
- None of the trials were consecutive missed trials
- After removing 84 trials, we have 10,428 trials across 48 participants and participants have 208-219 trials.
- p(gamble) = .44; range = .13-.71

### GLMER results
- similar to previous studies with the temporal choice set, we use a conservative two step approach where we first regress choice onto trial-level variables (e.g. risky gain, safe, and EV on trial t). Then we use the residuals (offset function) to allow recent events to account for additional risk-taking behavior. 

Trial-level variables have effects we'd expect with more risk-taking as gain amounts increase (beta = 16.118(1.92), p < 2e-16 ) and less risk-taking as safe amounts increase (beta = -41.078(3.798), p < 2e-16). No effect of magnitude (or ev level). AIC = 8058.9

Immediate timescale:
- in a model alone, past outcome amount is not significant but it does interact with past outcome type. The interaction is difficult to interpret because the difference is with a loss outcome but loss outcomes are $0, so we can't see how the loss outcome would change with outcome amount? We tested whether this could be explained by people treating losses as missed gains or received-not received and no effects of either regressor were present.

Neighborhood timescale:
- from previous work (VIC; Brooks & Sokol-Hessner, in revision), we found a short-lasting effect of positive shift.
- In a model with positive and negative shift amount, there is only a significant effect of positive shift consistent with VIC where there is more risk-taking following a positive shift and this effect is brief only lasting on the trial immediately following a shift and then drops off quickly.
- The effect of positive shift amount does not interact with run size or past outcome (similar to VIC)


Global timescale:
- comparing earnings relative to linear expectations (note: using earnings that allow individuals to vary performs better, i.e. when participants earnings are not normalized but just scaled by max earnings across participants so their earnings don't all end at the same place - 1)
- in a model with earnings and expectations, the betas for both variables are similar but in opposite directions (i.e. they are pulling risk-taking in opposite directions with a similar weight). Earnings beta = 2.3615(.8053), p = 0.00336 and expectations beta =-2.2802(.7945), p = 0.00411. The opposite effects here mean that when earnings are roughly equal to expectations, there is not net effect on risk-taking. When earnings are more than expectations, there is more risk-taking and when earnings are less than expectations, there is less risk-taking.
- no significant interaction between earnings and expectations.


- Immediate x Global timescale:
  - Because outcomes accumulate to make cumulative earnings, we checked for an interaction between the past outcome amount and earnings (in a model with expectations, expectations x outcome, and positive shift). In this model, there is a negative effect of past outcome (beta = -.7730(.17), p = 4.46e-06) and a positive effect of positive shift (beta = 2.3304(.75), p = .00181) and a trending interaction between earnings and outcome (beta = 5.201(2.9242), p = .07530). No main effects of earnings or expectations and no interaction bewteen past outcome and expectations.
  - Working out the effects and potential interaction between outcome and earnings: Overall, when participants did worse than expected, they took less risks and when earnings are more than expected, they took more risks and this pattern is stronger following a large outcome relative to a small outcome. It is possible that past outcome is the vehicle for the interaction between earnings and outcome, and trial and outcome. Likely a discussion for the supplement as a possible "why" for the interaction between two timescales.

- Level-tracking (vs. linear expectation)??
    - Because our task includes small --> large shifts up and down, this could add to how people may expect to be doing (are they adjusting their expectations differently across the levels of context)? One way to account for this is by a 'level-tracking' variable (just adding up level on each trial, which will be a very similar variable to cumulative earnings). This variable is scaled between 0 and 1 for each participant (normalized within participant).
    - adding level tracking variable to the model above shows no significant effect of level tracking but everything else remains significant.
    - replacing earnings with level tracking, all main effects and interactions are significant but the AIC is larger for the model with level-tracking. model fails to converge
    - The best model includes linear expectations and cumulative earnings (not level tracking). It looks like people are not significantly adjusting their expectations (as in Khaw (2017) where people adjust after hundreds of trials). If it is the case that people are not adjusting their expectations, are they not adjusting their reference point?

- Relative earnings??
    - There is a sign that there is something happening at the third level but the effect is happening across several regressors (earnings, trial, earnings x outcome, and possibly trial x outcome). It is not a nicely itemized effect like shift and past outcome effects and this effect could be happening as a result of the first level (past outcome). While it seems like one thing is happening, previous outcome effect changes based on how you're doing relative to expectations but it is so spread out across the variables that it makes the model with everything in it (the model including trial * poc) challenging. We could create a variable that captures the difference between earnings and expected earnings but the issue here is that we have to estimate the weighting. 
    -   We created a relative earnings variable (earnings - expectation) and put that variable in a model with past outcome, shift and expectations (we need to include expectations again because we don't really know the best way to account for the weighting of earnings and expectations in the relative earnings variable). There is no significant effect of relative earnings or interaction between earnings and outcomes in this model.

All three timescales (simultaneously):
- In a model with past outcome, positive shift, earnings and expectations and an interaction between earnings and past outcome, all regressors are significant.(NOTE: THIS IS THE MODEL WE USE BETAS FROM TO MAKE TIMING FILES FOR EXPECTATIONS AND EARNINGS FOR FMRI BOLD ANALYSIS; model5_potc_posshift_earn_trial)
      - outcome beta = -0.7804(0.1684), p = 3.57e-06 
      - earnings beta = 2.3959(0.7464), p = 0.001327
      - positive shift beta = 2.3774(0.7463), p=0.001444 
      - expectations beta = -2.1927(0.6397), p= 0.000609
      - outcome x earnings beta = 1.9885(0.3768), p = 1.31e-07


  
### Individual-level analysis
- see vniRDManalysis.Rmd

## BOLD ANALYSIS
*each model described has 2x the number of variables that we are modeling because we modeled both positive and negative versions to capture both increases and decreases in activity associated with the variable (an FSL thing).
### Base models
First, we ran four "base" models accounting for basic task events including choice display, decision, and outcome display. The goal was to find a base model that we could complicate with adding recent event variables.

In each of the base models, we model choice display with no modulation, decision with no modulation, and outcome display with both no modulation and modulation by outcome amount. The following base models vary by what is the modulator during choice display.

**Base model 1**: choice display modulated by dollar amount of both the mean expected value of the risky gamble and safe options (i.e. what happens as values across choice options increase vs. decrease).

**Base model 2**: choice display modulated by mean expected value of the risky gamble amount vs. safe amount (i.e. relative value of the risky option compared to the safe option).

**Base model 3:** choice display modulated by relative choice (chosen vs unchosen: choice * (risky gain $ * .5) - safe (where choice is -1/1).

Across these base models, we saw similar areas of activation across choice display (no modulation), decision and outcome display (with and without modulatio of outcome amount).
  - choice display (no modulation): people were processing information and value; activity in areas including insula, occipital cortex, caudate, putamen, thalamus)
  - outcome display (no modulation): areas like thalamus, insula and frontal areas. These results are very similar across the 3 models.
  - decision period: results were less clear/promising with only some intracalcerine cortex and this is probably due to the task where choice display and decision are tightly coupled (decision ends choice display). Because of this, we have decided to not model decision in addition to choice display in subsequent models.
  - outcome display (modulated by outcome amount): across the 3 base models, we saw similar results with increased activation in vmPFC and bilateral striatum with increaseed outcome amount.
  - choice display with different modulators: The results were pretty different across the choice display modulators with no significant clusters of activity showing up for choice display modulated by EV amount across the options (model 1), some increased activity in cingulate gyrus and decreased activity in bilateral insula for EV gamble vs safe (model 2), and some increased activity in the angular gyrus and anterior dmPFC (although coordinates don't exactly line up with prev. work e.g. Jeuchems 2017) and a tiny bit of increased activity in the insula.

We decided to stick with base model 3 because it appears most consistent with previous research that uses relative choice but will drop decision (base model 4).


**Base model 4:** similar to model 3 with choice display modulated by relative choice but we no longer model decision. This is our main model that we are moving forward with to complicate by adding recent event variables!


### Temporal context (adding recent event variables)

**model 5: 3 timescales**
This model is base model 4 with additional recent event variables including:
1. positive shift (choice display) with no modulation: really nothing showing up here, very small clusters here and there
2. positive shift (choice display) modulated by shift amount: only seeing activation for negative (decrease activity as shift increases) in the left putamen, some left insula, some superior frontal gyrus, cingulate gyrus, lateral pfc. Shift amount is important here which is consistent with our behavior.
3. relative earnings (choice display): this variable uses the betas for earnings and expectations in the behavior analysis to calculate the difference between earnings and expectations. We see a lot of occipital activity (all red/increased activity with earnings), left thalamus and hippocampus, tiny bit of right thalamus, this could be that earnings are doing something (modulating the extent to which people are engaged on the trial, e.g. looking more intently, slowing down. Or it could be epiphenomenal wher it might be reflecting something else like time, people slowing down with time or getting tired.)
4. past outcome amount (choice display): decrease in cingulate gyrus, not seeing meaningful increases in activity
5. earnings (outcome display): this earnings variable includes the outcome displayed on the current trial. a whole bunch of decrease in activity across the brain - like a lot! with earning variables, there is so much activity it may mean that we are capturing something that tracking time and/or stuff we aren't interested it. It might make sense to put in linear term that is related to time to help us deal with this isssue. So we give the linear term a chance to account for this activity that might be confounded with earnings.


To do: 
1) relative earnings at choice display could be related to something like RT, so we’d expect an positive relationship between RT and relative earnings (so it would suggest slower responses as earnings increase and could suggest that there is more being processed at choice display when earnings>expectations). Need to follow up with this behaviorally.
2) put in model 4 results above






