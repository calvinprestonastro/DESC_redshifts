#!/bin/bash

#SBATCH -p icelake-himem                                                                                        
#SBATCH --nodes=2
#SBATCH --ntasks=76                                                               
#SBATCH --cpus-per-task=2                                                   
#SBATCH -t 12:00:00                                                         
#SBATCH -J DESCY1_FREECOSMO_DESCSRD_NOHIGHZ_SC_TATT_STAGE3                                                         
#SBATCH -A ASTRONOMY-SL3-CPU                                                     
#SBATCH --mail-user=cp662@cam.ac.uk                                     
#SBATCH --mail-type=ALL                                                                  
#SBATCH --error=./error_files/DESCY1_FREECOSMO_DESCSRD_NOHIGHZ_SC_TATT_STAGE3.err                                   
#SBATCH --output=./out_files/DESCY1_FREECOSMO_DESCSRD_NOHIGHZ_SC_TATT_STAGE3.out                                                                    

export USER=cp662

numnodes=$SLURM_JOB_NUM_NODES
numtasks=$SLURM_NTASKS
mpi_tasks_per_node=$(echo "$SLURM_TASKS_PER_NODE" | sed -e  's/^\([0-9][0-9]*\).*$/\1/')
np=$[${numnodes}*${mpi_tasks_per_node}]
export I_MPI_PIN_DOMAIN=omp:compact # Domains are $OMP_NUM_THREADS cores in size
export I_MPI_PIN_ORDER=scatter # Adjacent domains have minimal sharing of caches/sockets
export OMP_NUM_THREADS=1

#! Number of MPI tasks to be started by the application per node and in total (do not change):
np=$[${numnodes}*${mpi_tasks_per_node}]

. /etc/profile.d/modules.sh
module purge
module load rhel8/default-icl
source ~/.bashrc


conda activate /home/$USER/env
source cosmosis-configure

export BASE=/home/$USER
export Y6METHODSDIR=$BASE/DES/DESC_redshifts
cd $Y6METHODSDIR
export CSL_DIR=$BASE/env/bin/cosmosis-standard-library
export CSLEXTRA_PATH=$Y6METHODSDIR/cosmosis-modules

export INCLUDEFILE=inis/blank_include.ini
export VALUESINCLUDE=inis/values_DESCY1_FREECOSMO_DESCSRD_NOHIGHZ_SC_TATT_STAGE3.ini
export SCALE_CUTS=LSST_masa_scalecuts.ini
export DATA_VECTOR=lsst_simulation_simple_xipm_Y1_Amod1_NOSETTINGCHANGE_HMCODE.fits
export DATA_TAG=d1
export PK_TYPE=hm20
export IA_MODEL=nla
export SOURCE_TAG=sy3
export LENS_TAG=ml4
export SAMPLER=multinest
export OUTPUT_DIR=$Y6METHODSDIR/chains 
export EXTRA_OUTPUT=
export MODEL_TAG=${PK_TYPE}-${IA_MODEL}-DESCY1_FREECOSMO_DESCSRD_NOHIGHZ_SC_TATT_STAGE3
export SAVE=                     

mpirun -ppn $mpi_tasks_per_node -np $np cosmosis --mpi inis/pipeline_SRDREDSHIFTSHEAR_NOHIGHZ_LSSTY1.ini -p runtime.sampler='multinest' multinest.resume=T multinest.live_points=500 multinest.tolerance=0.1 multinest.max_iterations=50000 multinest.efficiency=0.3 multinest.constant_efficiency=F



