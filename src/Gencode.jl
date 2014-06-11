include(Pkg.dir("GenomeAnnotations","src","Config.jl"))
include(Pkg.dir("GenomeAnnotations","src","utils.jl"))

# db_id is normally associated with an organism, e.g. M2, H19
# it's tempting to call this organism_id or org_id or org_db or something
# but leave it general
function install_gencode_annotation( db_id )
    println("Installing annotations for $db_id")
    download_gencode(db_id)
end

function list_gencode_annotations()
   return ["GCM2","GCH19"]
end

# Can be M2 or H19
function download_gencode( db_id )
    LOCAL_STORE = LOCAL_STORE_PATH()
    local_store_dir = joinpath( LOCAL_STORE, "")
    path = ""
    if(db_id == "GCM2")
        ftp = "ftp://ftp.sanger.ac.uk/pub/gencode/Gencode_mouse/release_M2/gencode.vM2.annotation.gtf.gz"
        local_store_dir = joinpath( LOCAL_STORE, db_id)
        make_localstore(local_store_dir)
        basename_gencode = basename(ftp)
        path = joinpath(local_store_dir, basename_gencode)
        download_with_curl(ftp, path)
    elseif( db == "GCH19")
        error("Not implemented yet for Gencode $db")
    else
        error("Gencode db is not one of GCH19 or GCM2 (you gave $db)")
    end
end


# create some feature specific files for convenience, especially a gene coordinates file
# A non coding file?
