# Load necessary libraries
library(dplyr)
library(tidyr)
library(lme4)
library(lmerTest)
library(ggplot2)

# Load your data
long_format_data <- read.csv("/Users/venturelab/Documents/git-papers/nv_rest_network_reboot/Gordon_atlas_results/hub_connectivity_profiles_long_format.csv")

# Define the network labels in the desired order
network_labels <- c(
  "Default", 
  "SMhand", 
  "SMmouth", 
  "Visual", 
  "FrontoParietal", 
  "Auditory", 
  "None", 
  "CinguloParietal", 
  "RetrosplenialTemporal", 
  "CinguloOperc", 
  "VentralAttn", 
  "Salience", 
  "DorsalAttn"
)

# Create a factor with the specified levels in the desired order
long_format_data$Network <- factor(long_format_data$Network, levels = paste0("Network_", 1:13))

# Create the custom contrast matrix
n_levels <- length(network_labels)
contrast_matrix <- matrix(-1 / (n_levels - 1), nrow = n_levels, ncol = n_levels)
diag(contrast_matrix) <- 1

# Ensure the rows sum to zero
for (i in 1:n_levels) {
  contrast_matrix[i, -i] <- -1 / (n_levels - 1)
}

# Apply the custom contrasts to the Network factor
contrasts(long_format_data$Network) <- contrast_matrix

# Print the custom contrast matrix to verify
print(contrasts(long_format_data$Network))

# Fit the linear mixed-effects model with custom contrasts
model <- lmer(Connectivity ~ Session * Network + (1 | Subject) + (1 | Hub_Index), data = long_format_data)
summary(model)

# Create the plot with sessions labeled as 1, 2, 3
ggplot(long_format_data, aes(x = factor(Session, levels = c('ses-01', 'ses-02', 'ses-03')), 
                             y = Connectivity, color = Network, group = Network)) +
  geom_line(size=1) +  # Adjust line size for better visibility
  geom_point(size=3) +  # Add points to emphasize data
  scale_x_discrete(labels = c("1", "2", "3")) +  # Change x-axis labels to 1, 2, 3
  labs(title = "Hub Connectivity Across Sessions by Network",
       x = "Session",
       y = "Mean Connectivity") +
  theme_minimal() +
  theme(legend.title = element_text(size = 10),  # Customize legend title size
        legend.text = element_text(size = 8))    # Customize legend text size


# Define the network labels in the desired order
network_labels <- c(
  "Default", 
  "SMhand", 
  "SMmouth", 
  "Visual", 
  "FrontoParietal", 
  "Auditory", 
  "None", 
  "CinguloParietal", 
  "RetrosplenialTemporal", 
  "CinguloOperc", 
  "VentralAttn", 
  "Salience", 
  "DorsalAttn"
)

# Create a factor with the specified levels in the desired order
long_format_data$Network <- factor(long_format_data$Network, 
                                   levels = paste0("Network_", 1:13), 
                                   labels = network_labels)

# Summarize the data to calculate mean Connectivity for each Session and Network
agg_data <- long_format_data %>%
  group_by(Session, Network) %>%
  summarize(mean_connectivity = mean(Connectivity, na.rm = TRUE)) %>%
  ungroup()

# Find the position of the last point for each network
last_point_position <- agg_data %>%
  group_by(Network) %>%
  filter(Session == max(Session)) %>%
  ungroup()

# Create the plot with network names as labels
ggplot(agg_data, aes(x = factor(Session, levels = c('ses-01', 'ses-02', 'ses-03')), 
                     y = mean_connectivity, color = Network, group = Network)) +
  geom_line(size = 1) +  # Line plot to show changes across sessions
  geom_point(size = 3) +  # Add points to emphasize data
  scale_x_discrete(labels = c("1", "2", "3")) +  # Change x-axis labels to 1, 2, 3
  labs(title = "Hub-to-Other-Node Connectivity Across Sessions by Network",
       x = "Session",
       y = "Mean Connectivity") +
  theme_minimal() +
  theme(legend.title = element_text(size = 10),  # Customize legend title size
        legend.text = element_text(size = 8)) +   # Customize legend text size
  # Add network labels at the end of the lines
  geom_text(data = last_point_position, aes(label = Network),
            vjust = -0.5, hjust = 1.2, size = 3.5, show.legend = FALSE)


#consider session as a continuous variable
# Fit the linear mixed-effects model with custom contrasts
model <- lmer(Connectivity ~ Session * Network + (1 | Subject) + (1 | Hub_Index), data = long_format_data)

