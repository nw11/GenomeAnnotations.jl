module ConfigTest

using FactCheck

include(Pkg.dir("GenomeAnnotations", "src","Config.jl"))

test_store_path = Pkg.dir("GenomeAnnotations","testdata","store", "annotation")
SET_LOCAL_STORE_PATH(test_store_path)

facts("local_store_path") do
    @fact LOCAL_STORE_PATH() => test_store_path
end

# set back to the original default
SET_LOCAL_STORE_PATH()

end
