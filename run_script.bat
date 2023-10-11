::Transmission network file
set matpower_network_file="data\\Transmission_Network_PT_2020.m"

::Daily PV profile
set PV_production_profile_file=data\PV_production_diagram.xlsx

::T4.4 data
set flexibity_devices_states_file=data\procured_flexibility_PT_2050_wf_W.xlsx
set DA_curtailment_file=data\PT_2050_wf_Normal_W.xlsx

::State estimation in form of T4.3
set state_estimation_csv_file=data\state_estimation\SE_PT2050_W\state_estimation_PT2050_W_t1.csv

::T4.5 parameters
set current_time_period=t1
set output_distribution_bus=n1

::EV_PV file conversion script
::set EV_PV_file=".\\data\\EV-PV-Storage_Data_for_Simulations_old.xlsx"
::julia EV-PV_file_conversion_script.jl %EV_PV_file%

::Select network and year from EV_PV file
set flex_devices_tech_char_file=data\PT_Tx_2050.xlsx

::Convert matpower network file
julia MATPOWER_to_XLSX.jl %matpower_network_file%

ampl main.run