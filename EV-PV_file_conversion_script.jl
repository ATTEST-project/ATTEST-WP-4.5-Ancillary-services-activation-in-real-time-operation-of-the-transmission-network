println("Start of EV-PV file conversion script")
using PowerModels, DataFrames, XLSX

source_files=ARGS[1]
destination_files=".\\data\\"


xf = XLSX.readxlsx(source_files)
sn = XLSX.sheetnames(xf)

for i in 1:length(sn)
println("Iter ",i)

ln1 = [replace(xf[sn[i]]["A2:D2"][1,j]," "=>"_") for j in 1:length(xf[sn[i]]["A2:D2"][1,:])]
df1 = DataFrame(XLSX.gettable(xf[sn[i]],"A:D",first_row=2, column_labels=ln1))

ln2 = [replace(xf[sn[i]]["F2:I2"][1,j]," "=>"_") for j in 1:length(xf[sn[i]]["F2:I2"][1,:])]
df2 = DataFrame(XLSX.gettable(xf[sn[i]],"F:I",first_row=2, column_labels=ln2))
df2."Time_(h)"=[join(["t",string(n)]) for n in df2."Time_(h)"]


XLSX.writetable(destination_files*sn[i]*".xlsx",
    PV_Storage        =(collect(DataFrames.eachcol(df1)), DataFrames.names(df1) ),
    EV                =(collect(DataFrames.eachcol(df2)), DataFrames.names(df2) ),
    overwrite=true)

end

println("End of EV-PV file conversion script")
