module StoreTest

using FactCheck

include(Pkg.dir("GenomeAnnotations", "src","Config.jl"))
include(Pkg.dir("GenomeAnnotations", "src", "Store.jl" ) )
local_store_path =  Pkg.dir("GenomeAnnotations", "testdata","store", "annotation")

SET_LOCAL_STORE_PATH(local_store_path)
setup_genome_annotations( )

# test ucscgb
include( Pkg.dir("GenomeAnnotations", "src","UCSCGB.jl") )
install_ucsc_annotation ( "mm10" )

# test annotation list now we have some annotations
a = current_annotation_files( )
println(a)
end
