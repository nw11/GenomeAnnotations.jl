function download_with_curl(  url, dest)
    println("Running curl_cmd")
    if !isfile(dest)
        run(`curl -o $dest -L $url`)
        println("Downloaded $url to $dest")
    else
        println("$dest exists no need to download")
    end
end

function list_annotations()
 # UCSC
 # GENCODE
 # ENSEMBL
end
