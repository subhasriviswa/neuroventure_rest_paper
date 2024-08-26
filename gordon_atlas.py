import os
import pandas as pd
from nilearn import image
from nilearn.input_data import NiftiLabelsMasker
from nilearn.connectome import ConnectivityMeasure
from nilearn.interfaces.fmriprep import load_confounds_strategy

# Load and process confounds
def load_and_process_confounds(img_path, strategy=["high_pass", "motion", "wm_csf", "scrub"], motion="basic", wm_csf="basic", scrub=5, fd_threshold=0.5, std_dvars_threshold=1.5):
    confounds, sample_mask = load_confounds_strategy(
        img_path,
        strategy=strategy,
        motion=motion,
        wm_csf=wm_csf,
        scrub=scrub,
        fd_threshold=fd_threshold,
        std_dvars_threshold=std_dvars_threshold
    )
    return confounds, sample_mask

# Extract time series data using NiftiLabelsMasker
def extract_time_series(img_path, confounds, labels_img):
    masker = NiftiLabelsMasker(
        labels_img=labels_img,
        smoothing_fwhm=6,
        detrend=True,
        standardize="zscore_sample",
        low_pass=0.1,
        high_pass=0.01,
        t_r=2
    )
    time_series = masker.fit_transform(img_path, confounds=confounds)
    return time_series

# Compute the correlation matrix
def compute_correlation_matrix(time_series):
    correlation_measure = ConnectivityMeasure(kind="correlation")
    correlation_matrix = correlation_measure.fit_transform([time_series])[0]
    np.fill_diagonal(correlation_matrix, 0)
    return correlation_matrix

# Main function to process all data
def main():
    directory_path = "/home/subhasri/projects/def-patricia/data/neuroventure/derivatives/fmriprep/derivatives/fmriprep/"
    output_dir = "/home/subhasri/scratch/gordon_atlas/"
    os.makedirs(output_dir, exist_ok=True)

    # Load the Gordon atlas NIfTI image
    labels_img = image.load_img('/home/subhasri/scratch/gordon_atlas/Parcels_release/Parcels_MNI_333.nii')

    available_subjects = [f"{i:03d}" for i in range(1, 156) if os.path.exists(os.path.join(directory_path, f'sub-{i:03d}'))]
    sessions = [f"{i:02d}" for i in range(1, 4)]

    for subject in available_subjects:
        for session in sessions:
            try:
                img_file = f'sub-{subject}_ses-{session}_task-rest_run-01_space-MNI152NLin2009cAsym_desc-preproc_bold.nii.gz'
                img_path = os.path.join(directory_path, f'sub-{subject}', f'ses-{session}', 'func', img_file)
                confounds, _ = load_and_process_confounds(img_path)
                
                time_series = extract_time_series(img_path, confounds, labels_img)
                correlation_matrix = compute_correlation_matrix(time_series)

                csv_file_path = os.path.join(output_dir, f'sub-{subject}_ses-{session}_correlation_matrix.csv')
                pd.DataFrame(correlation_matrix).to_csv(csv_file_path, index=False, header=False)
                
                print(f"Correlation matrix saved for subject {subject}, session {session}")
            except Exception as e:
                print(f"Error processing subject {subject}, session {session}: {e}")

if __name__ == "__main__":
    main()