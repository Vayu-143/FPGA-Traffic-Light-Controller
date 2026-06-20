# Simulation Guide

## Compile

iverilog -g2012 -o traffic_sim rtl/traffic_light_controller.sv tb/traffic_light_tb.sv

## Run

vvp traffic_sim

## View Waveform

gtkwave traffic_light.vcd

## Signals to Observe

- state
- timer
- pedestrian_req
- emergency_vehicle
- PED_WALK
- NS Signals
- EW Signals