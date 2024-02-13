# Reproduciblity script
# DO NOT RUN WITHOUT DOWNLOADING main_islands.dta as instructed, and place the file inside inputs/data.
library(haven)
library(zip)
library(knitr)

head(data)
library(dplyr)

# Load necessary libraries
library(ggplot2)

data =  read_dta("inputs/data/main_islands.dta")
# Generate island_dup variable similar to Stata code
data <- data %>%
  group_by(island) %>%
  mutate(island_dup = ifelse(row_number() == 1, 0, row_number()))

# Drop observations where island_dup > 1
data <- data %>% filter(island_dup <= 1)

# Plot 1: Island size vs Number of gas stations
plot1 <- ggplot(data, aes(x = size, y = gs,)) +
  geom_point(color="darkgreen") +
  geom_smooth(method = "lm", se = FALSE, color = "blue") +
  xlab("Island size (km sq)") +
  ylab("Number of gas stations") +
  theme_minimal()

# Plot 2: Island population vs Number of gas stations
plot2 <- ggplot(data, aes(x = population, y = gs)) +
  geom_point(color="darkgreen") +
  geom_smooth(method = "lm", se = FALSE, color = "blue") +
  xlab("Island population") +
  ylab("Number of gas stations") +
  theme_minimal()

# Display plots
plot1
plot2
####
# Load data
df = read_dta("inputs/data/main_islands.dta")
# Filter data for the specified date ranges
filtered_data <- df %>%
  filter((date >= 18293 & date <= 18313) |
           (date >= 18315 & date <= 18335) |
           (date >= 18375 & date <= 18395))

# Calculate summary statistics by product_type
summary_stats <- filtered_data %>%
  group_by(product_type) %>%
  summarize(Mean = mean(new_price, na.rm = TRUE),
            SD = sd(new_price, na.rm = TRUE),
            Median = quantile(new_price, 0.50, na.rm = TRUE),
            "10th percentile" = quantile(new_price, 0.10, na.rm = TRUE),
            "90th percentile" = quantile(new_price, 0.90, na.rm = TRUE))


summary_stats = summary_stats %>%
  arrange(desc(row_number()))

# swap rows
tmp_row  <- summary_stats[4,]
summary_stats[4,]  <- summary_stats[5,]
summary_stats[5,]  <- tmp_row
summary_stats

# Convert to kable
my_kable <- knitr::kable(summary_stats)

# Print the kable output
print(my_kable)



