include(Pkg.dir("GenomeAnnotations","src","Config.jl"))
include(Pkg.dir("GenomeAnnotations","src","utils.jl"))

function install_ucsc_annotation(organism, annotation_to_install=["ensGene"] )

    local_store_path = LOCAL_STORE_PATH()
    println("make directory $organism")
    organism_path = joinpath( local_store_path, organism )

    if isdir(organism_path)
         println("$organism_path already exists, skip mkdir")
    else
         mkdir( organism_path )
    end

    for annotation in annotation_to_install
        if annotation == "ensGene"
            println("Installing ensGene for $organism")
            download_ensgene(organism,organism_path)
        else
           println("No installation code for $annotation")
        end
    end
end

function download_ensgene ( organism, download_dir )
    ucsc_ensgene_url = "http://hgdownload.cse.ucsc.edu/goldenPath/$organism/database/ensGene.txt.gz"
    println("Download to $download_dir")
    download_path = joinpath(download_dir,"ensGene.txt.gz")
    if isfile(download_path )
       println("Download path exists: $download_path")
    else
        download_with_curl(ucsc_ensgene_url, download_path)
    end
end
