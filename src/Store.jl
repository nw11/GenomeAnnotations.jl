include( Pkg.dir("GenomeAnnotations", "src","Config.jl") )


function setup_genome_annotations( config_ini_path = Pkg.dir("GenomeAnnotations", "conf","conf.ini"))

    local_store_path = LOCAL_STORE_PATH( config_ini_path )

    #mkdir if it doesn't exist
    make_localstore(local_store_path)
    println("Made local GenomeAnnotation store at $local_store_path")

    # create a db description file
    db_names_file = joinpath(local_store_path,"db.names")
    if isfile(db_names_file)
        println("$db_names_file already exists")
    else
        touch( db_names_file )
        println("created db description file at $db_names_file")
    end
end

function make_localstore(local_store_dir)
    if ! isdir(local_store_dir)
        mkpath(local_store_dir)
    else
       println("$local_store_dir exists, no need to create")
    end
end

function download_url ( url, dest)
    println("Running curl_cmd")
    if !isfile(dest)
        run(`curl -o $dest -L $url`)
        println("Downloaded $ensgene_url to $dest")
    else
        println("$dest exists no need to download")
    end
end

function current_annotation_dirs( )
   local_store_path = LOCAL_STORE_PATH()
   dirs = readdir( local_store_path )
   return dirs
end

function current_annotation_files()
   dirs = current_annotation_dirs()
   local_store_path = LOCAL_STORE_PATH()

   annotation_dict = Dict()
   for dir in dirs
       path = joinpath( local_store_path, dir )
       if isdir(path)
           paths = readdir( path )
           full_paths = map( x -> joinpath( path,x), paths )
           annotation_dict[dir] = full_paths
       end
   end
   return annotation_dict
end
