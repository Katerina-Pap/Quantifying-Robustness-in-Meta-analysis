#----------------------------------------------------------------------------------------------------------------------------
#     R code to create the heatmap on Robustness Index for all possible comparisons of interventions in the network
#     Author: Loukia Spineli
#     Date: October 2020
#----------------------------------------------------------------------------------------------------------------------------



HeatMap.AllComparisons.RI <- function(RI, drug.names, threshold){
  
  
  
  ## Lower triangular heatmap matrix - Comparisons are read from the left to the right 
  ## CAREFUL: The interventions in the drug.names should follow the order you considered to run NMA pattern-mixture model!
  mat <- matrix(NA, nrow = length(drug.names) - 1, ncol = length(drug.names) - 1)
  mat[lower.tri(mat, diag = T)] <- round(RI, 2)
  colnames(mat) <- drug.names[1:(length(drug.names) - 1)]; rownames(mat) <- drug.names[2:length(drug.names)]
  mat.new <- melt(mat, na.rm = T)
  
  
  ## Create the heatmap for one network of interventions
  p <- ggplot(mat.new, aes(Var2, factor(Var1, level = drug.names[length(drug.names):2]), fill = ifelse(value < threshold, "high", "poor"))) + 
         geom_tile(colour = "white") + 
         geom_text(aes(Var2, Var1, label = value, fontface = "bold"), size = rel(5)) +
         scale_fill_manual(breaks = c("high", "poor"), values = c("green3", "firebrick1")) +
         scale_x_discrete(position = "top") +
         labs(x = "", y = "") +
         theme(legend.position = "none", axis.text.x = element_text(size = 13), axis.text.y = element_text(size = 13))
  
  return(p)
}

