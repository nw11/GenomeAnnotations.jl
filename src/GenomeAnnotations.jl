# Install/Manage Genome Annotations
# currently downloads annotation files to a local space

module GenomeAnnotations
 using Base.Intrinsics
 importall Base

# downloads to a local store geneAnnotations and processes them into a state that is amenable
# setup_genome_annotatons
# setup_annotations
# make the store directory and files

# install_annotation("mm10","gene")

# list_installed

# list organisms to install

export setup_genome_annotations
export install_ucsc_annotation
export install_gencode_annotation
export current_annotation_files

# Config.jl
export SET_LOCAL_STORE_PATH

include(Pkg.dir("GenomeAnnotations","src","Config.jl"))
include(Pkg.dir("GenomeAnnotations","src","Store.jl"))
include(Pkg.dir("GenomeAnnotations","src","UCSCGB.jl"))
include(Pkg.dir("GenomeAnnotations","src","Gencode.jl"))
end # module
