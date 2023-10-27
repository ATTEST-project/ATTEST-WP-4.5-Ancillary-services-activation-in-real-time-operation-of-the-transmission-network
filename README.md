## Description
This tool computes TSO-initiated activation of ancillary services as real-time remedial actions to enhance grid security.

## How to run
The tool is run using batch script *run_script.bat*

It requires installation of:
* Julia with packages:
	* PowerModels
	* DataFrames
	* XLSX
* AMPL with Ipopt solver

## Inputs
Inputs are specified in *run_script.bat* script in order:
* MATPOWER network file
* PV production profile
* flexibity devices expected states (output of task 4.4)
* day-ahead curtailment file (output of task 4.4)
* state estimation
* current time period
* distribution node location for output
* flexibility devices characteristics file (EV-PV file)

## Outputs
Transmission decisions (_trans_decisions.xlsx_) which includes for selected distribution node activations for each device and total up and down activations. 
