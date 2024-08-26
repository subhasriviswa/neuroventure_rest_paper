#this python file is to process the connectivity matrixes after distance thresholding 
# parcel nodes with less than <30 mm geodesic distance is been marked zero 
# load the connectivity matrixes and the distance matrixes as csv for each subject and each session
# multiply the connectivity matrixes with the distance matrixes to get the distance thresholded connectivity matrixes
# save the distance thresholded connectivity matrixes as csv files for each subject and each session
# the output files are saved in the same directory as the input files

import numpy as np
import pandas as pd
import os
import nilearn
from nilearn import plotting



#load the csv files for the connectivity matrixes

import numpy as np
import pandas as pd
import os

def apply_distance_mask(input_dir, output_dir, distance_mask_path):
    """
    Applies a binary distance mask to connectivity matrices for each subject and session,
    where connections marked by '0' in the mask are set to zero.

    Parameters:
        input_dir (str): Directory containing the connectivity matrices.
        output_dir (str): Directory to save the filtered connectivity matrices.
        distance_mask_path (str): Path to the binary distance mask CSV file.
    """
    # Load the binary distance mask
    distance_mask = pd.read_csv(distance_mask_path, header=None).values

    # Ensure the output directory exists
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    # Process each subject and session
    for subject_id in range(1, 156):  # Subjects 001 to 155
        for session_id in range(1, 4):  # Sessions 01 to 03
            # Format subject and session IDs
            formatted_subject_id = f"sub-{subject_id:03}"
            formatted_session_id = f"ses-{session_id:02}"
            file_name = f"{formatted_subject_id}_{formatted_session_id}_correlation_matrix.csv"
            file_path = os.path.join(input_dir, file_name)
            
            # Check if the file exists before processing
            if os.path.exists(file_path):
                # Load the connectivity matrix
                connectivity_matrix = pd.read_csv(file_path, header=None).values
                
                # Apply the distance mask
                filtered_matrix = connectivity_matrix * distance_mask

                # Save the filtered connectivity matrix
                output_file_name = f"{formatted_subject_id}_{formatted_session_id}_filtered_correlation_matrix.csv"
                output_path = os.path.join(output_dir, output_file_name)
                pd.DataFrame(filtered_matrix).to_csv(output_path, header=False, index=False)

                print(f'Processed and saved: {output_path}')
            else:
                print(f'File not found: {file_path}')

# Example usage
input_directory = '/Users/venturelab/Downloads/gordon_atlas'  # Adjust to your directory
output_directory = '/Users/venturelab/Documents/git-papers/nv_rest_network_reboot/gordon_atlas_afterdistance'  # Adjust to your desired output directory
distance_mask_file = '/Users/venturelab/Downloads/iamdamion-Demeter_etal_2023-735a8f6/COMBINED333_LR_Distance_MULTIPLICATION_MASK.csv'  # Adjust to your mask file path
apply_distance_mask(input_directory, output_directory, distance_mask_file)