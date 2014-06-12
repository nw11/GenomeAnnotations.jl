module ConfigTest

using FactCheck

include(Pkg.dir("GenomeAnnotations", "src","Config.jl"))

conffile = Pkg.dir("GenomeAnnotations","conf","conf.ini")
if( isfile(conffile) )
   rm(conffile)
   rmdir( dirname(conffile ) )
end

LOCAL_STORE_PATH()

test_store_path = Pkg.dir("GenomeAnnotations","testdata","store", "annotation")
SET_LOCAL_STORE_PATH(test_store_path)

facts("local_store_path") do
    @fact LOCAL_STORE_PATH() => test_store_path
end

# set back to the original default
SET_LOCAL_STORE_PATH()

end
