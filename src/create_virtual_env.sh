# python3 -m venv .venv: Creates the isolated folder named .venv.
# source .venv/bin/activate: Turns on the environment in your terminal.
# pip install ...: Installs the core data science stack (Pandas/Jupyter) plus the bioinformatics essentials (scipy for stats, seaborn for heatmaps, and scikit-learn for PCA).

python3 -m venv .venv && source .venv/bin/activate && pip install pandas jupyter ipykernel scipy seaborn matplotlib scikit-learn

---
# activate
source .venv/bin/activate

---
# source already existing venv for another venv
python3 -m venv .venv && source .venv/bin/activate && pip install pandas ipykernel

---
# Use 'freeze' to capture exact versions
python -m pip freeze > requirements.txt

 ---
# If you ever want to replicate this "perfect" setup for a new study, you don't have to install packages one by one.
source .venv/bin/activate && pip install -r requirements.txt