println("Start of MATPOWER_to_XLSX script")
using PowerModels, DataFrames, XLSX

source_files=ARGS[1]
destination_files="data\\network_data.xlsx"


    network_data = PowerModels.parse_file(source_files, import_all=true)
    data=PowerModels.build_ref(network_data)[:it][:pm][:nw][0]

    Name_df = DataFrames.DataFrame(name = [String(data[:name])])

    bus_sort=sort(collect(keys(data[:bus])))

    bus = [parse(Int,"$(n)") for n in bus_sort]
    vmax = [data[:bus][n]["vmax"] for n in bus_sort]
    vmin = [data[:bus][n]["vmin"] for n in bus_sort]
    area = [data[:bus][n]["area"] for n in bus_sort]
    vm = [data[:bus][n]["vm"] for n in bus_sort]
    va = [data[:bus][n]["va"] for n in bus_sort]
    vbase = [data[:bus][n]["base_kv"] for n in bus_sort]
    btype = [data[:bus][n]["bus_type"] for n in bus_sort]

    Bus_df = DataFrames.DataFrame(n=bus, vmax=vmax, vmin=vmin, area=area, vm=vm, va=va, vbase=vbase, btype=btype)

    gen_sort = sort(collect(keys(data[:gen])))

    gen = ["g$(g)" for g in gen_sort]
    pg_max = [data[:gen][g]["pmax"] for g in gen_sort]
    pg_min = [data[:gen][g]["pmin"] for g in gen_sort]
    qg_max = [data[:gen][g]["qmax"] for g in gen_sort]
    qg_min = [data[:gen][g]["qmin"] for g in gen_sort]
    c2 = [if get(data[:gen][g],"ncost",0)==3 data[:gen][g]["cost"][1] else 0 end for g in gen_sort]
    c1 = [if get(data[:gen][g],"ncost",0)==2 data[:gen][g]["cost"][1] elseif get(data[:gen][g],"ncost",0)==3 data[:gen][g]["cost"][2] else 0 end for g in gen_sort]
    c0 = [if get(data[:gen][g],"ncost",0)==1 data[:gen][g]["cost"][1] elseif get(data[:gen][g],"ncost",0)==2 data[:gen][g]["cost"][2] elseif get(data[:gen][g],"ncost",0)==3 data[:gen][g]["cost"][3] else 0 end for g in gen_sort]
    pg = [data[:gen][g]["pg"] for g in gen_sort]
    qg = [data[:gen][g]["qg"] for g in gen_sort]
    vg = [data[:gen][g]["vg"] for g in gen_sort]

    Gen_df = DataFrames.DataFrame(g=gen, pg_max=pg_max, pg_min=pg_min, qg_max=qg_max, qg_min=qg_min, c2=c2, c1=c1, c0=c0, pg=pg, qg=qg, vg=vg )

    branch_sort = sort(collect(keys(data[:branch])))

    branch = ["l$(l)" for l in branch_sort]
    bl = [-data[:branch][l]["br_x"]/(data[:branch][l]["br_x"]^2 + data[:branch][l]["br_r"]^2) for l in branch_sort]
    gl = [ data[:branch][l]["br_r"]/(data[:branch][l]["br_x"]^2 + data[:branch][l]["br_r"]^2) for l in branch_sort]
    bl_fr = [data[:branch][l]["b_fr"] for l in branch_sort]
    bl_to = [data[:branch][l]["b_to"] for l in branch_sort]
    gl_fr = [data[:branch][l]["g_fr"] for l in branch_sort]
    gl_to = [data[:branch][l]["g_to"] for l in branch_sort]
    Sl_max = [get(data[:branch][l], "rate_a", 0) for l in branch_sort]
    tap = [data[:branch][l]["tap"] for l in branch_sort]
    shift = [data[:branch][l]["shift"] for l in branch_sort]

    Branch_df = DataFrames.DataFrame(l=branch, bl=bl, gl=gl, bl_fr=bl_fr, bl_to=bl_to, gl_fr=gl_fr, gl_to=gl_to, Sl_max=Sl_max, tap=tap, shift=shift )

    #transformer_sort = sort([l for l in keys(data[:branch]) if data[:branch][l]["transformer"]])
    #transformer = ["l$(l)" for l in transformer_sort]

    #Transformer_df = DataFrames.DataFrame(l=transformer)

    load_sort = sort(collect(keys(data[:load])))

    load = ["lo$(lo)" for lo in load_sort]
    pd = [data[:load][lo]["pd"] for lo in load_sort]
    qd = [data[:load][lo]["qd"] for lo in load_sort]

    Load_df = DataFrames.DataFrame(lo=load, pd=pd, qd=qd)

    shunt_sort = sort(collect(keys(data[:shunt])))

    shunt = ["sh$(sh)" for sh in shunt_sort]
    bs = [data[:shunt][sh]["bs"] for sh in shunt_sort]
    gs = [data[:shunt][sh]["gs"] for sh in shunt_sort]

    Shunt_df = DataFrames.DataFrame(sh=shunt, bs=bs, gs=gs)

    buspair_sort = sort(collect(keys(data[:buspairs])))
    buspair1 = [parse(Int,"$(n)") for (n,m) in buspair_sort]
    buspair2 = [parse(Int,"$(m)") for (n,m) in buspair_sort]
    angmax = [data[:buspairs][(n,m)]["angmax"] for (n,m) in buspair_sort]
    angmin = [data[:buspairs][(n,m)]["angmin"] for (n,m) in buspair_sort]

    Buspair_df = DataFrames.DataFrame(n=buspair1, m=buspair2, angmax=angmax, angmin=angmin)

#    branch_from1 = ["l$(l)" for l in branch_sort]
    branch_from2 = [parse(Int,"$(data[:branch][l]["f_bus"])") for l in branch_sort]
    branch_from3 = [parse(Int,"$(data[:branch][l]["t_bus"])") for l in branch_sort]

    Branch_from_df = DataFrames.DataFrame(l=branch, n=branch_from2, m=branch_from3)

    refbus_sort = sort(collect(keys(data[:ref_buses])))
    Refbus_df = DataFrames.DataFrame(n=[parse(Int,"$(n)") for n in refbus_sort])

    bus_gen1 = [parse(Int,"$(n)") for n in bus_sort for g in data[:bus_gens][n]]
    bus_gen2 = ["g$(g)" for n in bus_sort for g in data[:bus_gens][n]]

    Bus_gen_df = DataFrames.DataFrame(n=bus_gen1, g=bus_gen2)

    bus_load1 = [parse(Int,"$(n)") for n in bus_sort for lo in data[:bus_loads][n]]
    bus_load2 = ["lo$(lo)" for n in bus_sort for lo in data[:bus_loads][n]]

    Bus_load_df = DataFrames.DataFrame(n=bus_load1, lo=bus_load2)

    bus_shunt1 = [parse(Int,"$(n)") for n in bus_sort for sh in data[:bus_shunts][n]]
    bus_shunt2 = ["sh$(sh)" for n in bus_sort for sh in data[:bus_shunts][n]]

    Bus_shunt_df = DataFrames.DataFrame(n=bus_shunt1, sh=bus_shunt2)

println("Writing network XLSX file")
    rm(destination_files,force=true)
    XLSX.writetable(destination_files,
        Name        =( collect(DataFrames.eachcol(Name_df)), DataFrames.names(Name_df) ),
        Bus         =( collect(DataFrames.eachcol(Bus_df)), DataFrames.names(Bus_df) ),
        Gen         =( collect(DataFrames.eachcol(Gen_df)), DataFrames.names(Gen_df) ),
        Branch      =( collect(DataFrames.eachcol(Branch_df)), DataFrames.names(Branch_df) ),
#        Transformer =( collect(DataFrames.eachcol(Transformer_df)), DataFrames.names(Transformer_df) ),
        Load        =( collect(DataFrames.eachcol(Load_df)), DataFrames.names(Load_df) ),
        Shunt       =( collect(DataFrames.eachcol(Shunt_df)), DataFrames.names(Shunt_df) ),
        Buspair     =( collect(DataFrames.eachcol(Buspair_df)), DataFrames.names(Buspair_df) ),
        Branch_from =( collect(DataFrames.eachcol(Branch_from_df)), DataFrames.names(Branch_from_df) ),
        Refbus      =( collect(DataFrames.eachcol(Refbus_df)), DataFrames.names(Refbus_df) ),
        Bus_gen     =( collect(DataFrames.eachcol(Bus_gen_df)), DataFrames.names(Bus_gen_df) ),
        Bus_load    =( collect(DataFrames.eachcol(Bus_load_df)), DataFrames.names(Bus_load_df) ),
        Bus_shunt   =( collect(DataFrames.eachcol(Bus_shunt_df)), DataFrames.names(Bus_shunt_df) ),
    )
println("End of MATPOWER_to_XLSX script")

