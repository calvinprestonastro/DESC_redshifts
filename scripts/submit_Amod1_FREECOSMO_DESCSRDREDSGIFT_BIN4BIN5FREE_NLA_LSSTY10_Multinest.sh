#!/bin/bash

#SBATCH -p icelake-himem                                                                                        
#SBATCH --nodes=2
#SBATCH --ntasks=76                                                               
#SBATCH --cpus-per-task=2                                                   
#SBATCH -t 12:00:00                                                         
#SBATCH -J LSSTY10AMOD1_FREECOSMOLOGY_DESCSRDREDSHIFT_BIN4BIN5FREE                                                            
#SBATCH -A ASTRONOMY-SL3-CPU                                                     
#SBATCH --mail-user=cp662@cam.ac.uk                                     
#SBATCH --mail-type=ALL                                                                  
SBATCH --error=./error_files/LSSTY10AMOD1_FREECOSMOLOGY_DESSRDREDSHIFT_BIN4BIN5FREE_NLA.err                                   
#SBATCH --output=./out_files/LSSTY10AMOD1_FREECOSMOLOGY_DESCSRDREDSHIFT_BIN4BIN5FREE_NLA.out                                                                    

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
export Y6METHODSDIR=$BASE/DES/powerPKZ
cd $Y6METHODSDIR
export CSL_DIR=$BASE/env/bin/cosmosis-standard-library
export CSLEXTRA_PATH=$Y6METHODSDIR/cosmosis-modules

export INCLUDEFILE=inis/pipeline_Amod.ini
export VALUESINCLUDE=inis/values_FREECOSMO_SRDREDSHIFT_Amod1_LSSTY10.ini
export SCALE_CUTS=LSST_noscalecuts.ini
export DATA_VECTOR=lsst_simulation_simple_xipm_Y10_Amod1_NOSETTINGCHANGE_HMCODE.fits
export DATA_TAG=d1
export PK_TYPE=hm20
export IA_MODEL=nla
export SOURCE_TAG=sy3
export LENS_TAG=ml4
export SAMPLER=multinest
export OUTPUT_DIR=$Y6METHODSDIR/chains 
export EXTRA_OUTPUT=
export MODEL_TAG=${PK_TYPE}-${IA_MODEL}-AMOD1LSSTY10AMOD1_FREECOSMOLOGY_DESCSRDREDSHIFT_BIN4BIN5FREE_NLA
export SAVE=                     
#srun -n 96 cosmosis --mpi inis/pipeline_shear_fid.ini -p runtime.sampler='polychord' polychord.resume=T polychord.live_points=250 polychord.tolerance=0.1 polychord.num_repeats=30

mpirun -ppn $mpi_tasks_per_node -np $np cosmosis --mpi inis/pipeline_LSSTY10SRDREDSHIFTS_BIN4BIN5FREE.ini -p runtime.sampler='multinest' multinest.resume=T multinest.live_points=500 multinest.tolerance=0.1 multinest.max_iterations=50000 multinest.efficiency=0.3 multinest.constant_efficiency=F



