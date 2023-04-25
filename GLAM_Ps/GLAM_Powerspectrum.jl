#using DelimitedFiles
using HDF5

include("../Bispectrum/src/grid.jl")
include("../Bispectrum/src/powerspectrum.jl")

# function read_glam(filename)
#     jj = readdlm(filename, skipstart=8)
#     x = jj[:,1]
#     y = jj[:,2]
#     z = jj[:,3]
#     return x, y, z
# end

function read_glam(filename)
    jj = h5open(filename, "r") do file
        read(file)
    end
    x = jj["X"]
    y = jj["Y"]
    z = jj["Z"]
    return x, y, z
end

# GLAM directory
dir = "/global/project/projectdirs/desi/mocks/GLAM/JFE_files/z_Raw_boxes/PMILL/z1.198/"

# For each file in GLAM directory
for filename in readdir(dir)
    # Make sure its the sumulation file
    if filename[1:9] == "CatshortV"
        try
            outfile = string("/global/u1/s/shreeb/GLAM_Ps/z1.198/BAO/Pk_",chop(filename,tail=2),"DAT")
            if isfile(outfile) continue end
            println(string(dir,filename))
            # Extract x, y, z
            x, y, z = read_glam(string(dir,filename))
            gr = grid_r(512, x, y, z, 4)
            gk = grid_k(gr)
            pk = power_spectrum(gk, 0.01, 30, 1000)
            write_powerspectrum(pk, 0.01,outfile)
        catch error
            println("Exception occurred :",error)
        end
    end
end

# GLAM directory
dir = "/global/project/projectdirs/desi/mocks/GLAM/JFE_files/z_Raw_boxes/PMILL_noBAO/z1.198/"

# For each file in GLAM directory
for filename in readdir(dir)
    # Make sure its the sumulation file
    if filename[1:9] == "CatshortV"
        try
            outfile = string("/global/u1/s/shreeb/GLAM_Ps/z1.198/noBAO/Pk_",chop(filename,tail=2),"DAT")
            if isfile(outfile) continue end
            println(string(dir,filename))
            # Extract x, y, z
            x, y, z = read_glam(string(dir,filename))
            gr = grid_r(512, x, y, z, 4)
            gk = grid_k(gr)
            pk = power_spectrum(gk, 0.01, 30, 1000)
            write_powerspectrum(pk, 0.01,outfile)
        catch error
            println("Exception occurred :",error)
        end
    end
end

