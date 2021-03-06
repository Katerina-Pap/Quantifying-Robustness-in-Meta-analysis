#----------------------------------------------------------------------------------------------------------------------------
#     R code to create a barplot for the Kullback-Leibler divergence measure under all re-analyses 
#     Author: Loukia Spineli
#     Date: October 2020
#----------------------------------------------------------------------------------------------------------------------------



Barplot.KLD <- function(KLD, outcome, title, ylimit){
 
  
  if(outcome == "binary"){
    
    ## Define the scenarios for IMOR
    scenarios <- cbind(rep(c(0.3, 0.50, 1, 2, 3), each = 5), rep(c(0.3, 0.50, 1, 2, 3), times = 5))
    
  } else {
    
    ## Define the scenarios for IMDoM
    scenarios <- cbind(rep(c(-2, -1, 0, 1, 2), each = 5), rep(c(-2, -1, 0, 1, 2), times = 5))
    
  }
  colnames(scenarios) <- c("active", "ctrl")
  
  
  ## Rank the scenarios to calculate their distance in the compared arms
  (ranked.scenarios <- cbind(rep(rank(1:5), each = 5), rep(rank(1:5), times = 5)))
  (distance <- ifelse(abs(ranked.scenarios[, 1] - ranked.scenarios[, 2]) > 1, "more distant", 
                      ifelse(abs(ranked.scenarios[, 1] - ranked.scenarios[, 2]) == 1, "less distant", "no distance")))
  
  
  ## Characterise the scenarios to extreme, sceptical, and optimistic with respect to their position from MAR
  plausibility <- factor(c("Extreme", rep("Sceptical", 3), "Extreme", "Sceptical", rep("Optimistic", 3), "Sceptical", "Sceptical", rep("Optimistic", 3),
                           "Sceptical", "Sceptical", rep("Optimistic", 3), "Sceptical", "Extreme", rep("Sceptical", 3), "Extreme"), 
                         levels = c("Extreme", "Sceptical", "Optimistic"))
  
  
  ## Dataset for the barplot 
  dataset.new <- data.frame(KLD[-13], paste0(scenarios[-13, 1], ",", scenarios[-13, 2]), plausibility[-13], distance[-13])
  colnames(dataset.new) <- c("KLD", "scenarios", "plausibility", "distance")
  
  barplot <- ggplot(dataset.new, aes(x = reorder(scenarios, -KLD), y = KLD, fill = distance)) +
    geom_bar(stat = "identity", width = 0.5) +
    scale_fill_manual(breaks = c("more distant", "less distant", "no distance"), values = c("red", "orange", "green4")) +
    facet_grid(. ~  plausibility, scales = "free_x", space = "free") +
    labs(x = "Scenarios (active vs control)", y = "Kullback-Leibler divergence measure", fill = "Distance between the scenarios") + 
    #geom_hline(yintercept = 0.28, linetype = 2) + 
    ylim(0, ylimit) +
    ggtitle(title) + 
    theme_classic() +
    theme(axis.title = element_text(size = 14, face = "bold"), axis.text = element_text(size = 11), axis.text.x = element_text(size = 11, angle = 45, hjust = 1),
          legend.position = "bottom", legend.title = element_text(size = 13, face = "bold"), legend.text = element_text(size = 12),
          strip.text = element_text(size = 14), plot.title = element_text(size = 14, face = "bold", hjust = 0.5))
  
  return(barplot)
}








