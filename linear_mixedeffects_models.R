#load the csv file 
library(dplyr)
library(tidyr)
library(lme4)
library(lmerTest)
library(ggplot2)
data <- read.csv("/Users/venturelab/Documents/git-papers/nv_rest_network_reboot/Gordon_atlas_results/within_network_means.csv", header = TRUE)
data <- data.frame(data)

long_data <- data %>% 
  pivot_longer(
    cols = 1:13,  # Adjust this if the number or positions of network columns change
    names_to = "network",
    values_to = "value"
  )
# Assuming 'network' is a factor with 13 levels
long_data$network <- factor(long_data$network)



# Get the number of levels
n_levels <- length(levels(long_data$network))

#get unique names of the network and store it in a variable
network_names <- unique(long_data$network)

# Create the custom contrast matrix
contrast_matrix <- matrix(-1 / (n_levels - 1), nrow = n_levels, ncol = n_levels)
diag(contrast_matrix) <- 1

# Ensure the rows sum to zero
for (i in 1:n_levels) {
  contrast_matrix[i, -i] <- -1 / (n_levels - 1)
}

contrasts(long_data$network) <- contrast_matrix

# Print the custom contrast matrix to verify
print(contrasts(long_data$network))

# Fit the linear mixed-effects model
model2_extended <- lmer(value ~ age * network + Gender + hash + alcohol + (session | subject), data = long_data)

summary(model2_extended)


model2_extended_test <- lmerTest::lmer(value ~ age * network + Gender + hash + alcohol + (session | subject), data = long_data)
# Check the summary of the model
summary(model2_extended_test)

model_summary <- summary(model2_extended_test)

model_with_session <- lmer(value ~ session * network + Gender + hash + alcohol + (session | subject), data = long_data)
summary(model_with_session)

#model with just value and age

model4_simple <- lmerTest::lmer(value ~ age * network + (1 | subject) + (0 + age | subject), data = long_data)
summary(model4_simple)

# Define the order of networks based on your image
network_labels <- c("Default", "SMhand", "SMmouth", "Visual", "Auditory",
                    "FrontoParietal", "CinguloParietal", "CinguloOperc",
                    "VentralAttn", "Salience", "DorsalAttn", 
                    "RetrosplenialTemporal", "None")


# Example plot for age by network interactions
ggplot(long_data, aes(x = age, y = value, color = network))  +
  geom_smooth(method = "lm", se = FALSE) +
  facet_wrap(~ network) +
  labs(title = "Trajectories of Network Changes with Age",
       x = "Age",
       y = "Value")


















