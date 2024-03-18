library(DBI)
library(duckdb)
library(ggplot2)
library(dplyr)

# Connect to DuckDB
con <- dbConnect(duckdb::duckdb(), dbdir = "storm_invasion.duckdb",
                                read_only = TRUE

                                # Execute the query and fetch the result into a data frame
                                query <- "
                                    SELECT gen, avtes, y, z
                                    FROM simulations
                                    WHERE rep NOT IN (
                                        SELECT rep
                                        FROM simulations
                                        WHERE popstat = 'fail'
                                        GROUP BY rep
                                    )
                                    AND y BETWEEN -50 AND 49 AND z BETWEEN -49 AND 50
                                "
                                df <- dbGetQuery(con, query)

                                # Close the connection
                                dbDisconnect(con)

                                # Generate a unique identifier for each y-z pair efficiently
                                df <- df %>%
                                    mutate(yz_id = paste(y, z, sep = "_"))

                                # Map each unique yz_id to a color
                                df$color <- as.factor(df$yz_id)

                                # Plotting with ggplot2
                                p <- ggplot(df, aes(x = gen, y = avtes, color = color)) +
                                    geom_point(alpha = 0.6, size = 1) +
                                    scale_color_viridis_d() +
                                    labs(
                                        title = "Avtes vs Gen Scatter Plot with Y-Z Color Coding",
                                        x = "Gen", y = "Avtes"
                                    ) +
                                    theme_minimal() +
                                    theme(legend.position = "none") # Remove the legend to avoid clutter

                                # Save the plot
                                ggsave(
                                    "avtes_vs_gen_color_coded_R.png",
                                    plot = p,
                                    width = 12, height = 10, dpi = 150
                                )
