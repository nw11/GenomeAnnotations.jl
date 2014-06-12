
#
#
#  UNTIL THE IniFile  PKG GETS UPDATED METADATA PASTE IT HERE
#
#

import Base.get,
       Base.haskey,
       Base.read,
       Base.write,
       Base.show

typealias INIVAL Union(String,Number,Bool,Nothing)
typealias HTSS Dict{String,INIVAL}

type Inifile
    sections::Dict{String,HTSS}
    defaults::HTSS
end

Inifile() = Inifile((String=>HTSS)[], HTSS())

defaults(inifile::Inifile) = inifile.defaults

sections(inifile::Inifile) = inifile.sections

function read(inifile::Inifile, stream::IO)
    current_section = inifile.defaults
    for line in EachLine(stream)
        s = strip(line)
        # comments start with # or ;
        if length(s) < 3 || s[1] == '#' || s[1] == ';'
            continue
        elseif s[1] == '[' && s[end] == ']'
            section = s[2:end-1]
            if !haskey(inifile.sections, section)
                inifile.sections[section] = HTSS()
            end
            current_section = inifile.sections[section]
        else
            i = search(s, '=')
            j = search(s, ':')
            if i == 0 && j == 0
                # TODO: allow multiline values
                println("skipping malformed line: $s")
            else
                idx = min(i, j)
                if idx == 0
                    idx = max(i, j)
                end
                key = rstrip(s[1:idx-1])
                val = lstrip(s[idx+1:end])
                current_section[key] = val
            end
        end
    end
    inifile
end

function read(inifile::Inifile, filename::String)
    open(filename) do f
        read(inifile, f)
    end
    inifile
end

show(io::IO, inifile::Inifile) = write(io, inifile)
function write(io::IO, inifile::Inifile)
    for (key, value) in defaults(inifile)
        println(io, "$key=$value")
    end
    for (name, htss) in sections(inifile)
        println(io, "[$name]")
        for (key, value) in htss
            println(io, "$key=$value")
        end
    end
end

get(inifile::Inifile, section::String, key::String) = get(inifile, section, key, :notfound)

function get(inifile::Inifile, section::String, key::String, notfound)
    if haskey(inifile.sections, section) && haskey(inifile.sections[section], key)
        return inifile.sections[section][key]
    elseif haskey(inifile.defaults, key)
        return inifile.defaults[key]
    end
    notfound
end

   # This needs to be fixed to set the "defaults" when necessary
   # If there is nothing in the section just set the default
function set(inifile::Inifile, section::String, key::String, val::INIVAL)
    if !haskey(inifile.sections, section)
        (val == nothing) && return val
        inifile.sections[section] = HTSS()
    end

    sec = inifile.sections[section]
    if val == nothing
        if haskey(sec, key)
            delete!(sec, key)
        end
        return val
    end
    sec[key] = val
    val
end

#
#
#  ===============================================================================
#
#

#function LOCAL_STORE_PATH_STATUS( )
#    ini = Inifile()
#    conf_path = Pkg.dir("GenomeAnnotations", "conf", "conf.ini")
#    read(ini,conf_path)
#    local_store_path = get(ini,"","LOCAL_STORE_PATH")
#    if(local_store_path == "nothing")
#         return "unset"
#    else
#         return "set"
#    end
#end

function setup_ini(conf_path, test=false)
    # implement something to account for when testing
    confdir = dirname(conf_path)
    if !isdir( confdir )
        mkpath(confdir)
        println("Made configuration directory in $confdir")
    end
    writedlm( conf_path, ["LOCAL_STORE_PATH=nothing"])
    println("Writting configuration file in $conf_path")
end

function LOCAL_STORE_PATH( conf_path = Pkg.dir("GenomeAnnotations", "conf", "conf.ini")  )
    ini = Inifile()

    if( !isfile(conf_path) )
        setup_ini(conf_path)
    end

    read(ini,conf_path)
    #println("$conf_path ",ini)

    local_store_path = get(ini,"","LOCAL_STORE_PATH")
    println("Local store path is currently $local_store_path")
    local_store_path = chomp(local_store_path)
    #println("GOT PATH $local_store_path")
    if( local_store_path == "nothing" )
       local_store_path = SET_LOCAL_STORE_PATH()
       println("Set local path to $local_store_path")
    end
    return local_store_path
end

function SET_LOCAL_STORE_PATH( path = joinpath(homedir(), ".GenomeAnnotations.jl", "annotation"),
                               conf_path = Pkg.dir("GenomeAnnotations", "conf", "conf.ini"))
     #default_path =

     #if( path == "" )
     #    path = default_path
     #end


     ini = Inifile()
     read(ini,conf_path)
     println("Setting LOCAL_STORE_PATH=$path in config file ( $conf_path )")
     ini.defaults["LOCAL_STORE_PATH"] = path
     io = open(conf_path,"w")
     write(io, ini)
     close(io)

     return path
end


function current_annotation_chr_names()
    CURRENT_ANNOTATION_ORG_NAMES = load_current_annotation_organisms()
    CURRENT_ANNOTATION_CHR_NAMES = load_current_annotation_chr_names(CURRENT_ANNOTATION_ORG_NAMES)
end


function current_annotation_chr_index()
    CURRENT_ANNOTATION_ORG_NAMES = load_current_annotation_organisms()
    CURRENT_ANNOTATION_CHR_NAMES = load_current_annotation_chr_index(CURRENT_ANNOTATION_ORG_NAMES)
end


function load_current_annotation_organisms()
     # reads a file with a list of genomes on system
    path = joinpath( LOCAL_STORE_PATH(), "organism.names")
    if(!isfile(path))
       error("Expected an organism.names file to exist - path trying to access here: $path")
    end

    iostream = open(path)
    orgs = Array(ASCIIString, 0)
    for line in eachline(iostream)
        push!(orgs, chomp(line) )
    end
    close(iostream)
    return orgs
end

function load_current_annotation_chr_names(orgs)
         # We want to load
         # CURRENT_ANNOTATION_CHR_NAMES
         # CURRENT_ANNOTATION_CHR_INDEX
         # for each folder - look for chr.names and load
         # joinpath(LOCAL_STORE_PATH(),
    org_chr_names = Dict()
    for org in orgs
        path = joinpath(LOCAL_STORE_PATH(), org,"chr.names")
        iostream = open(path)
        if(!isfile(path))
            error("Expected a chr.names file to exist for $org - path trying to access here: $path")
        end
        chrs = Array(ASCIIString,0)
        for line in eachline(iostream)
            #trim whitespace
            push!(chrs, chomp( line ) )
        end
        org_chr_names[org] = chrs
    end
    return org_chr_names
end

function load_current_annotation_chr_index(orgs)

    CURRENT_ANNOTATION_CHR_NAMES = load_current_annotation_chr_names(orgs)
    CURRENT_ANNOTATION_CHR_INDEX = Dict()
    for organism_id in keys(CURRENT_ANNOTATION_CHR_NAMES)
        chromnames = CURRENT_ANNOTATION_CHR_NAMES[organism_id]
        h = Dict()
        idx = 1
        for chr in chromnames
            h[chr] = idx
            idx +=1
        end
        CURRENT_ANNOTATION_CHR_INDEX[organism_id] = h
        idx=1
    end
    return CURRENT_ANNOTATION_CHR_INDEX
end

#LOCAL_CURRENT_ANNOTATIONS = joinpath(LOCAL_STORE_PATH(),"current_annotation.jl")
#include(LOCAL_CURRENT_ANNOTATIONS)
