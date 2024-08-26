This folder has all the codes that are used in the Paper < add paper title >

Here are the step by step process that was taken with the corresponding python file 

1. After the fmriprep pipeline was applied as pre processing step, Gordon_atlas.py file was ran to get 333X333 correlation matrix for each subject session based on the Gordon atlas parcellation
2. distance_corrected_gordonatlas.py : Distance censoring step : Multiplying a binary mask with 333 X333 matrix to make parcels with < 30 mm geodesic distance to 0. 
3. Linear_mixed_effects_models.R : R script to run lmer models for within network changes with time and plot network trajectories. 
4. Updated_Identidy_Hubs.py python file runs the following steps 
    1. Loads z transformed 333 X 333 matrix and distance censors them
    2. Runs Infomap to get community affiliation 
    3. Runs PC for each parcel and computes PC percentage ranking
    4. Gets hub indices based on top 20% of PC scores for each subject 
    5. Get Dlabel nii images with highlighted hubs for each subject 
5. Create_hub_profiles.py : Python file to create hub to other node connectivity profiles (mapping hub to other node connectivity from 333 x333 matrix)
6. Pretty_graphs_trial.ipynb : Graphs of pc and hubs on glass brain to add to the paper 
7. Focused_Hub_Indicies_analysis.ipynb : Looks into hub stability measures ( visualizations and statistics)
8. Hub_connectivity_profiles_linear_mixed_models.R : Lmer based models to look into differences in hub to other node connectivity with time. 
