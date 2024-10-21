# Server logic for the Game of Thrones Pedigree tree

library(kinship2)

# Observe the input from the dropdown for the dynasty selection
output$family_tree_plot <- renderPlot({
  # Use the input from the dropdown to filter by dynasty
  filtered_family_id <- input$dynasty  # Get selected dynasty from the dropdown

  if (filtered_family_id == 0) {
    # Create the pedigree object using the full pedigree data
    filtered_pedigree <- pedigree_data
    ped <- pedigree(
      id = filtered_pedigree$id,       # Character ID
      dadid = filtered_pedigree$dad_id, # Father ID
      momid = filtered_pedigree$mom_id, # Mother ID
      sex = filtered_pedigree$sex     # Gender (1 = Male, 2 = Female)
    )
  } else {

    # Filter pedigree_data based on the selected dynasty
    filtered_pedigree <- pedigree_data %>%
      unnest(fam_ids) %>%
      filter(filtered_family_id == fam_ids) %>%
      rename(dynasty_id = fam_ids) %>%
      inner_join(pedigree_relations,
                 by = c("id" = "character_id",
                        "dynasty_id" = "dynasty_id")) %>%
      # if the relation is not bloodline then set their dad_id and mom_id to 0
      mutate(dad_id = ifelse(relationship != "bloodline", 0, dad_id),
             mom_id = ifelse(relationship != "bloodline", 0, mom_id))

    # Filter to get only valid spouse relationships
    spouse_relations <- filtered_pedigree %>%
      filter(spouse_id > 0) %>%   # Keep only rows where spouse is present
      select(id, spouse_id)

    # Create the relationship data for the pedigree plot
    relations <- data.frame(
      id1 = spouse_relations$id,     # The individual
      id2 = spouse_relations$spouse_id, # Their spouse
      code = 4,                      # 4 is the code for a marriage/union in kinship2
      famid = 1                      # Family ID (can be 1 for simplicity)
    )

    # Create the pedigree object using the spouse relations
    ped <- pedigree(
      id = filtered_pedigree$id,       # Character ID
      dadid = filtered_pedigree$dad_id, # Father ID
      momid = filtered_pedigree$mom_id, # Mother ID
      relation = relations,       # Marriage/union relationships from spouse column
      sex = filtered_pedigree$sex     # Gender (1 = Male, 2 = Female)
    )
  }

  # Render the family tree plot, suppress warnings for incomplete pedigrees
  suppressWarnings({
    plot(ped, cex = 0.6, id = filtered_pedigree$label)
  })
})
