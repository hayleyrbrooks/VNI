VNI Analysis of RDM behavior
================
Hayley Brooks

Tips/Tricks from template: 1) Try executing this chunk by clicking the
*Run* button within the chunk or by placing your cursor inside it and
pressing *Cmd+Shift+Enter*. 2) Add a new chunk by clicking the *Insert
Chunk* button on the toolbar or by pressing *Cmd+Option+I*. 3) When you
save the notebook, an HTML file containing the code and output will be
saved alongside it (click the *Preview* button or press *Cmd+Shift+K* to
preview the HTML file). 4) The preview shows you a rendered HTML copy of
the contents of the editor. Consequently, unlike *Knit*, *Preview* does
not run any R code chunks. Instead, the output of the chunk when it was
last run in the editor is displayed.

# Config

``` r
library(config)
```

    ## Warning: package 'config' was built under R version 4.0.2

    ## 
    ## Attaching package: 'config'

    ## The following objects are masked from 'package:base':
    ## 
    ##     get, merge

``` r
config::get()
```

    ## $path
    ## $path$data
    ## [1] "/Volumes/shlab/Projects/VNI/data/"
    ## 
    ## $path$raw
    ## [1] "mriBehaviorRaw/groupLevelFiles/"
    ## 
    ## $path$clean
    ## [1] "mriBehaviorClean"
    ## 
    ## $path$quality_analysis_output
    ## [1] "mriBehaviorQAoutput"
    ## 
    ## 
    ## $group_files
    ## $group_files$group_clean_csv
    ## [1] "group_mriBehavior_clean.csv"
    ## 
    ## 
    ## attr(,"config")
    ## [1] "default"
    ## attr(,"file")
    ## [1] "/Users/hayley/Documents/GitHub/vni/config.yml"

Set up the environment

``` r
rm(list=ls());  # clear environment
load("/Volumes/shlab/Projects/VNI/data/mriBehaviorClean/group_mriBehavior_clean.Rdata"); # load cleaned RDM dataset with Qualtrics responses
```

Subject information

``` r
subIDs = unique(mriBehClean$subjectIndex);
nSub = length(subIDs);
print(nSub)
```

    ## [1] 48
