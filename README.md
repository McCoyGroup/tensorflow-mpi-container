
# Tensorflow MPI Container

Just a base container with tensorflow-gpu support and MPI built together.
MPI takes a long time to build so it's nice to have right off the bat.
Auto-pushes to DockerHub (`mccoygroup/tensorflow-mpi`) so you can build off of that image.
If you need a different version of MPI you can make a branch and build/push that branch to the appropriately tagged DockerHub image.