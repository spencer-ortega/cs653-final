#!/bin/bash




# must set path of src

# HPC
# home="/home/rcf-proj/an2/sportega"
# wd="$home/ML4MD/spencer/"
# lmpsrc="$home/lammps/lammps/src"

# Local
wd="/home/sportega/Desktop/dr/spencer"
lmpsrc="/home/rcf-proj/an2/sportega/lammps/lammps/src/lmp_foo"

# lammps mpi execution command
lmprun="srun --mpi=pmi2 $lmpsrc"
material="C"


cd $wd
datafiles=($(ls data_file))
# datafiles=("C_25_7_14")

for file in ${datafiles[*]}; do
	echo $file

	# remove file extension for label
	label="${file%.*}"

	# mkdir and cd into new dir
	mkdir -p sim/$label/therm && cd "$_" 

	# copy input file and slurm script to new dir
	cp $wd/slurm/$material/therm.slurm $label.slurm
	cp $wd/input_file/$material/therm.in $label.in

	# edit files
	sed -i "s/variable label string/variable label string $label/1" $label.in
	sed -i "s/<label>/$label/1" $label.slurm
	echo "cd $wd/sim/$label/therm" >> $label.slurm
	echo "${lmprun} < $label.in" >> $label.slurm

	# submit to slurm
	# sbatch $label.slurm

	# reset to wd
	cd $wd

done