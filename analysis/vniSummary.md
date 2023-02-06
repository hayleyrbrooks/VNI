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
- mean p(gamble) = .44; range = .13-.71

### GLMER results
- similar to previous studies with the temporal choice set, we use a conservative two step approach where we first regressed choice onto trial-level variables (e.g. risky gain, safe, and EV on trial t). Then we use the residuals (offset function) to allow recent events to account for additional risk-taking behavior. 

Trial-level variables have effects we'd expect with more risk-taking as gain amounts increase (beta = 16.118(1.92), p < 2e-16 ) and less risk-taking as safe amounts increase (beta = -41.078(3.798), p < 2e-16). No effect of magnitude (or ev level). AIC = 8058.9

Immediate timescale:
- in a model alone, past outcome amount is not significant but it does interact with past outcome type. The interaction is difficult to interpret because the difference is with a loss outcome but loss outcomes are $0, so we can't measure how the loss outcome effect would change with outcome amount? We tested whether this could be explained by people treating losses as missed gains or received-not received and no effects of either regressor were present.

Neighborhood timescale:
- from previous work (VIC; Brooks & Sokol-Hessner, in revision), we found a short-lasting effect of positive shift amount ($).
- In a model with positive and negative shift amount, there is only a significant effect of positive shift amount consistent with VIC where there is more risk-taking as positive shift amount increases (this is risk-taking immediately following a shift) and this effect is brief only lasting on the trial immediately following a shift and then drops off quickly.
- The effect of positive shift amount does not interact with run size or past outcome (similar to VIC)


Global timescale:
- comparing earnings relative to linear expectations (note: using earnings that allow individuals to vary performs better, i.e. when participants earnings are not normalized but just scaled by max earnings across participants so their earnings don't all end at the same place - 1)
- in a model with earnings and expectations, the betas for both variables are similar but in opposite directions (i.e. they are pulling risk-taking in opposite directions with a similar weight). Earnings beta = 2.3615(.8053), p = 0.00336 and expectations beta =-2.2802(.7945), p = 0.00411. The opposite effects here mean that when earnings are roughly equal to expectations, there is not net effect on risk-taking. When earnings are more than expectations, there is more risk-taking and when earnings are less than expectations, there is less risk-taking.
- no significant interaction between earnings and expectations.


- Immediate x Global timescale:
  - Because outcomes accumulate to make earnings, we checked for an interaction between the past outcome amount and earnings (in a model with expectations, expectations x outcome, and positive shift). In this model, there is a negative effect of past outcome (beta = -.7730(.17), p = 4.46e-06) and a positive effect of positive shift (beta = 2.3304(.75), p = .00181) and a trending interaction between earnings and outcome (beta = 5.201(2.9242), p = .07530). No main effects of earnings or expectations and no interaction bewteen past outcome and expectations.
  - Working out the effects and potential interaction between outcome and earnings: Overall, when participants did worse than expected, they took less risks and when earnings are more than expected, they took more risks and this pattern is stronger following a large outcome relative to a small outcome. It is possible that past outcome is the vehicle for the interaction between earnings and outcome, and trial and outcome. Likely a discussion for the supplement as a possible "why" for the interaction between two timescales. Could it be the other way around? Instead of past outcome being the driver, perhaps earnings relative to expectations is the driver for the past outcome effect (i.e. people treat each outcome differently depending on how they are doing overall)?

- Level-tracking (vs. linear expectation)??
    - Because our task includes small --> large shifts up and down, this could add to how people may expect to be doing (are they adjusting their expectations differently across the levels of context)? One way to account for this is by a 'level-tracking' variable (just adding up level on each trial, which will be a very similar variable to cumulative earnings). This variable is scaled between 0 and 1 for each participant (normalized within participant).
    - adding level tracking variable to the model above shows no significant effect of level tracking but everything else remains significant.
    - replacing earnings with level tracking, all main effects and interactions are significant but the AIC is larger for the model with level-tracking. model fails to converge
    - The best model includes linear expectations and cumulative earnings (not level tracking). It looks like people are not significantly adjusting their expectations (as in Khaw (2017) where people adjust after hundreds of trials). If it is the case that people are not adjusting their expectations, are they not adjusting their reference point?

- Relative earnings??
    - There is a sign that there is something happening at the third level but the effect is happening across several regressors (earnings, expectations, earnings x outcome, and possibly expectations x outcome). It is not a nicely itemized effect like shift amount and past outcome effects and this effect could be happening as a result of the first level (past outcome). While it seems like one thing is happening, previous outcome effect changes based on how you're doing relative to expectations but it is so spread out across the variables that it makes the model with everything in it (the model including trial * poc) challenging. We could create a variable that captures the difference between earnings and expected earnings but the issue here is that we have to estimate the weighting. 
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

Across these base models, we saw similar areas of activation across choice display (no modulation), decision and outcome display (with and without modulation of outcome amount).
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
3. relative earnings (choice display): this variable uses the betas for earnings and expectations in the behavior analysis to calculate the difference between earnings and expectations. We see a lot of occipital activity (all red/increased activity with earnings), left thalamus and hippocampus, tiny bit of right thalamus, this could be that earnings are doing something (modulating the extent to which people are engaged on the trial, e.g. looking more intently, slowing down. Or it could be epiphenomenal where it might be reflecting something else like time, people slowing down with time or getting tired.) One other note - it seems like RTs are slower when earnings are more than expected which makes the window of choice display bigger when earnings are more than expected but this should be accounted for by the timing files in the model already.
4. past outcome amount (choice display): decrease in cingulate gyrus, not seeing meaningful increases in activity
5. earnings (outcome display): this earnings variable includes the outcome displayed on the current trial. a whole bunch of decrease in activity across the brain - like a lot! with earning variables, there is so much activity it may mean that we are capturing something that tracking time and/or stuff we aren't interested it. It might make sense to put in linear term that is related to time to help us deal with this isssue. So we give the linear term a chance to account for this activity that might be confounded with earnings.




## Follow up analyses (both behavior and BOLD)
In the results for relative earnings modeled at choice display in model 5, we see a bunch of activity all over the brain, but esp. occipital activity. This makes us wonder if relative earnings variable as in model in 4 and 5 (relative earnings = earnings beta * earnings(t) + expectations beta * expectations (t); these are added (vs subtracted) because beta estimate for expectations is negative) is also capturing something else that is tracking time, task engagement or other epi-phenomenal things that we aren't interested in for this analysis. 

We checked looked for things potentially correlated with time in the behavior data in 3 ways:
1. _Is there a relationship between relative earnings and reaction time?_ 
  - Note that our reaction times are somewhat restrictive because participants had a 2s forced viewing period. In a linear mixed effects model regression with relative earnings (weighted by betas as created in timing files for BOLD analysis) there is a positive relationship between relative earnings and reaction time. As earnings are more than expected, reaction time increases. 
  - There is a long tail on the distribution of RTs (that could be leading to this relationship), but taking the sqaure root of the RTs (making the distribution more normal) also showed a positive relationship between earnings and reaction time. 
  - It does look like the the variability in reaction time is greater when earnings are less than expected relative to the variability in RTs when earnings are more than expected. 
  - Wondering whether we should account for this relationship between RT and relative earnings hemodynamically, we looked at deviations from the median RT given best and worst situations (earnings much higher than expected and much lower than expected) and the difference in deviation from median across the worst to best situation is 160ms (or 1/6th of a second). This is very small and we have temporal deriviatives in our BOLD models that should account for some of this. This suggests that we do not need to change our BOLD model to account for this. 
  *Take away*: we are not well-equipped to look at reaction time and figure out what exactly is going on given our study design (forced viewing period). 
  
2. _Does a context-dependent model with trial (linear term) do better than a model with earnings?_ In these two models, we regress choice on past outcome, positive shift and trial or earnings. The model with earnings outperforms the model with trial, but neither have main effects (of earnings or trial). That a linear term does not outperform earnings is a potential sign that the effect of earnings>expectations is not strictly a time thing.

3. _Does our task have any inherent features that change with time?_ 
  - In two separate models, we regressed risky gain and safe amounts on trial. There is a positive relationship between risky gain and trial (where risky gain values are, on average, increasing as the task progresses) and a trending, positive relationship between safe and trial. 
  - This could be a result of randomization and the run lengths (e.g. long and short runs are more likely to be in certain places of the task). This could be a thing to put in the supplement.
  - Calculated the effect size for risky gain ~ trial and there is 2.4% shift in value (risky gain) over the course of the entire study. Max gain is $61. So $61 * 2.4% = $1.46 change over the entire task (219 trials). Behaviorally, this doesn't really present an issue but for imaging, we do have to consider how this could impact us as we looking for signals of value (and here signals of value are correlated with time on a small level). For the safe ~ trial effect size, there is less than 1% change in value (safe) over the course of the study or a chance of $0.49 in safe value.
  - Part of this is taken care of by accounting for risky gain and safe values on the current trial in our BOLD analysis.


4. _Is past outcome as model in our BOLD analysis missing something?_ 
  - Maybe we should be taking into consideration other things like choice difficulty? We looked at this by plotting predicted p(gamble) for trial-level model which includes gain, safe and magnitude (or ev level) regressed on choice (0/1) and then we plotted predicted p(gamble) for past outcome model (which is just past outcome regressed on to choice (0/1) with the offset command). 
  - The predicted values are _very_ similar and the differences between the two models (trial-level - past outcome) range from -.00171 to .00483 and the mean difference is 0.00011. It seems like on a participant-basis, the differences go in one or the other directions where trial-level model either consistency under or over predicted gambling for a given participant. Figures for the group and participants are [here](./1_mriBehaviorAnalysis/figures/triLevModel_pocModel_predPgam_all.pdf).
  - PSH: The graphs of the change in p(gamble) from trial-level vs. potc are a little confusing to me (that they’re all almost uniquely pos. or neg. on an individual basis is initially unexpected, but the more I reflect on it, this may make sense. The regressor is strictly positive, soooo… of course it pushes things only one direction on a per-person basis. Enh this approach may not be as fruitful as I thought it might be.


Based on these results above, we are going to move forward with our BOLD model 5, but including a linear term (0 to 1; mean-centered ACROSS runs) modeled at choice display to try to account for other linear things that could be happening at the same time that we are trying to understand relative earnings. We also modified the timing files for relative earnings (at choice display) and earnings (at outcome display) so that these variables were mean-centered ACROSS runs (whereas most variables are mean-centered within run).

**model 6: 3 timescales plus linear term (choice display)**
