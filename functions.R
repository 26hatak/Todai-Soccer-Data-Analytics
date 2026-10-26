library(showtext)
showtext_auto()

font_add_google(name = "Noto Sans JP", family = "jp")

load_data <- function(path = "data/match_stats.csv"){
  jap_df <- read.csv(path)
  
  jap_df$goal_diff <- jap_df$ゴール数- jap_df$被ゴール数
  jap_df$result <- ifelse(jap_df$goal_diff >0, "W", ifelse(jap_df$goal_diff < 0, "L", "D"))
  
 
  return(jap_df)
}


plot_possession_map <- function(df, x_col, y_col, label_col = "match_label", result_col = "result") {
  result_cols <- c("goal_diff", "result")
  df$match_label <- paste(df$season, df$対戦相手, sep = " vs ")
  
  x_vals <- df[[x_col]]
  y_vals <- df[[y_col]]
  
  x_mean <- mean(x_vals, na.rm = TRUE)
  y_mean <- mean(y_vals, na.rm = TRUE)
  
  x_min <- min(x_vals, na.rm = TRUE) - 0.5
  x_max <- max(x_vals, na.rm = TRUE) + 0.5
  y_min <- min(y_vals, na.rm = TRUE) - 0.5
  y_max <- max(y_vals, na.rm = TRUE) + 0.5
  
  ggplot(df, aes_string(x = x_col, y = y_col, label = label_col)) +
    geom_point(aes_string(color = result_col), alpha = 0.6, size = 3) +
    geom_vline(xintercept = x_mean, linetype = "dashed", color = "gray40") +
    geom_hline(yintercept = y_mean, linetype = "dashed", color = "gray40") +
    geom_text(family = "jp", hjust = 0, vjust = 1.2, size = 2.5, check_overlap = TRUE) +
    scale_color_manual(values = c("W" = "green", "D" = "gray", "L" = "red")) +
    labs(
      title = paste0(x_col, " vs. ", y_col),
      x = x_col,
      y = y_col
    ) +
    xlim(x_min, x_max) +
    ylim(y_min, y_max) +
    theme_minimal(base_family = "jp")
}