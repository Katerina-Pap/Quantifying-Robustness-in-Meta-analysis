#----------------------------------------------------------------------------------------------------------------------------
#     R code to obtain the Kullback-Leibler Divergence (comparing two normal distributions)
#     R code to obtain the Robustness Index for each possible comparison of interventions
#     Author: Loukia Spineli
#     Date: October 2020
#----------------------------------------------------------------------------------------------------------------------------



## Function for the Kullback-Leibler Divergence (comparing two univariate normal distributions)
KLD.measure.univ <- function(mean.y, sd.y, mean.x, sd.x){

  # x is the 'truth' (e.g. the MAR assumption)
  KLD.xy <- 0.5*(((sd.x/sd.y)^2) + ((mean.y - mean.x)^2)/(sd.y^2) - 1 + 2*log(sd.y/sd.x))
  
  return(list(KLD.xy = KLD.xy))
}



## Robustness index for the Effect Measure (ES) of all possible pairwise comparisons of interventions
RobustnessIndex <- function(ES.mat, primary.scenar, nt){

  
  ## Number of scenarios for the sensitivity analysis
  n.scenar <- length(ES.mat[, 1])/(nt*(nt - 1)/2)
  
  
  ## A matrix of effect estimates of MCMC standard deviations (or standard errors) for all possible comparisons under each scenario
  sd <- mean <- matrix(NA, nrow = n.scenar, ncol = nt*(nt - 1)/2) 
  
  for(i in 1:n.scenar){
    
    for(j in 1:(nt*(nt - 1)/2)){
      
      mean[i, j] <- ES.mat[j + (nt*(nt - 1)/2)*(i - 1), 1]
      
      sd[i, j] <- ES.mat[j + (nt*(nt - 1)/2)*(i - 1), 2]
      
    }
  }
  
  kldxy <- list()
  
  RI <- nt*(nt - 1)/2
  
  for(i in 1:(nt*(nt - 1)/2)){ ## We are interested in all possible pairwise comparisons of the network
    
    kldxy[[i]] <- rep(NA, n.scenar)
    
    for(j in (1:n.scenar)[-primary.scenar]){
      

      ## Returns the KLD of informative scenario j when compared with MAR (MAR as 'true') for comparison i  
      kldxy[[i]][j] <- KLD.measure.univ(mean[j, i], sd[j, i], mean[primary.scenar, i], sd[primary.scenar, i])[[1]]
      
    }
    kldxy[[i]][13] <- 0  ## This refers to the primary analysis (here, the MAR assumption)
    
    ## Returns the Robustness Index of comparison i across all informative scenarios 
    RI[i] <- sqrt(round(t(kldxy[[i]][-primary.scenar]) %*% kldxy[[i]][-primary.scenar], 3))

  }
  
  return(list(RI = RI, kldxy = kldxy))
}

