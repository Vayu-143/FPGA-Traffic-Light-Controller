`timescale 1ns/1ps

module traffic_light_tb;

logic clk;
logic rst;

logic pedestrian_req;
logic emergency_vehicle;

logic [2:0] state;
logic [5:0] timer;

logic NS_R;
logic NS_Y;
logic NS_G;

logic EW_R;
logic EW_Y;
logic EW_G;

logic PED_WALK;

//====================================================
// DUT
//====================================================

traffic_light_controller DUT(
    .clk(clk),
    .rst(rst),

    .pedestrian_req(pedestrian_req),
    .emergency_vehicle(emergency_vehicle),

    .state(state),
    .timer(timer),

    .NS_R(NS_R),
    .NS_Y(NS_Y),
    .NS_G(NS_G),

    .EW_R(EW_R),
    .EW_Y(EW_Y),
    .EW_G(EW_G),

    .PED_WALK(PED_WALK)
);

//====================================================
// Clock
//====================================================

always #5 clk = ~clk;

//====================================================
// Test Sequence
//====================================================

initial
begin

    clk = 0;
    rst = 1;

    pedestrian_req = 0;
    emergency_vehicle = 0;

    #20;
    rst = 0;

    //----------------------------------------
    // Pedestrian Request
    //----------------------------------------

    #80;
    pedestrian_req = 1;

    #10;
    pedestrian_req = 0;

    //----------------------------------------
    // Emergency Vehicle
    //----------------------------------------

    #200;

    emergency_vehicle = 1;

    #50;

    emergency_vehicle = 0;

    //----------------------------------------

    #400;

    $finish;
end

//====================================================
// VCD
//====================================================

initial
begin
    $dumpfile("traffic_light.vcd");
    $dumpvars(0, traffic_light_tb);
end

//====================================================
// Monitor
//====================================================

initial
begin
    $display("---------------------------------------------------------");
    $display("Time State Timer Ped Emergency Walk");
    $display("---------------------------------------------------------");

    $monitor("%0t  %0d   %0d    %b      %b       %b",
             $time,
             state,
             timer,
             pedestrian_req,
             emergency_vehicle,
             PED_WALK);
end

endmodule