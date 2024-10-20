# Server logic for the Game of Thrones Pedigree tree

library(kinship2)

# Render the family tree plot in the new tab
output$family_tree_plot <- renderPlot({
  # Create the pedigree object
  ped <- pedigree(
    id = pedigree_data$id,
    dadid = pedigree_data$dadid,
    momid = pedigree_data$momid,
    sex = pedigree_data$sex,
    affected = rep(0, nrow(pedigree_data))  # Set to 0 for now, or adjust if needed
  )
  # Temporarily suppress warnings while plotting, as some pedigrees may not be fully connected
  suppressWarnings({
    plot(ped, cex = 0.6, id = pedigree_data$label)
  })
})