module traffic_light_controller(

    input  logic clk,
    input  logic rst,

    input  logic pedestrian_req,
    input  logic emergency_vehicle,

    output logic [2:0] state,
    output logic [5:0] timer,

    output logic NS_R,
    output logic NS_Y,
    output logic NS_G,

    output logic EW_R,
    output logic EW_Y,
    output logic EW_G,

    output logic PED_WALK
);

//====================================================
// State Encoding
//====================================================

localparam S0_NS_GREEN    = 3'd0;
localparam S1_NS_YELLOW   = 3'd1;
localparam S2_EW_GREEN    = 3'd2;
localparam S3_EW_YELLOW   = 3'd3;
localparam S4_ALL_RED     = 3'd4;
localparam S5_PED_WALK    = 3'd5;

//====================================================
// Timing Parameters
//====================================================

localparam GREEN_TIME     = 10;
localparam YELLOW_TIME    = 3;
localparam ALL_RED_TIME   = 2;
localparam PED_TIME       = 5;

//====================================================
// Request Storage
//====================================================

logic ped_pending;

//====================================================
// Sequential Logic
//====================================================

always_ff @(posedge clk or posedge rst)
begin

    if(rst)
    begin
        state       <= S0_NS_GREEN;
        timer       <= 0;
        ped_pending <= 0;
    end

    else
    begin

        //------------------------------------------------
        // Store pedestrian request
        //------------------------------------------------
        if(pedestrian_req)
            ped_pending <= 1;

        //------------------------------------------------
        // Emergency Vehicle Override
        //------------------------------------------------
        if(emergency_vehicle)
        begin
            state <= S0_NS_GREEN;
            timer <= 0;
        end

        else
        begin

            case(state)

            //------------------------------------------------
            // S0
            //------------------------------------------------
            S0_NS_GREEN:
            begin
                if(timer == GREEN_TIME-1)
                begin
                    state <= S1_NS_YELLOW;
                    timer <= 0;
                end
                else
                    timer <= timer + 1;
            end

            //------------------------------------------------
            // S1
            //------------------------------------------------
            S1_NS_YELLOW:
            begin
                if(timer == YELLOW_TIME-1)
                begin

                    if(ped_pending)
                        state <= S4_ALL_RED;
                    else
                        state <= S2_EW_GREEN;

                    timer <= 0;
                end
                else
                    timer <= timer + 1;
            end

            //------------------------------------------------
            // S2
            //------------------------------------------------
            S2_EW_GREEN:
            begin
                if(timer == GREEN_TIME-1)
                begin
                    state <= S3_EW_YELLOW;
                    timer <= 0;
                end
                else
                    timer <= timer + 1;
            end

            //------------------------------------------------
            // S3
            //------------------------------------------------
            S3_EW_YELLOW:
            begin
                if(timer == YELLOW_TIME-1)
                begin

                    if(ped_pending)
                        state <= S4_ALL_RED;
                    else
                        state <= S0_NS_GREEN;

                    timer <= 0;
                end
                else
                    timer <= timer + 1;
            end

            //------------------------------------------------
            // S4
            //------------------------------------------------
            S4_ALL_RED:
            begin
                if(timer == ALL_RED_TIME-1)
                begin
                    state <= S5_PED_WALK;
                    timer <= 0;
                end
                else
                    timer <= timer + 1;
            end

            //------------------------------------------------
            // S5
            //------------------------------------------------
            S5_PED_WALK:
            begin
                if(timer == PED_TIME-1)
                begin
                    state <= S0_NS_GREEN;
                    timer <= 0;
                    ped_pending <= 0;
                end
                else
                    timer <= timer + 1;
            end

            default:
            begin
                state <= S0_NS_GREEN;
                timer <= 0;
            end

            endcase
        end
    end
end

//====================================================
// Output Logic
//====================================================

always_comb
begin

    NS_R = 0;
    NS_Y = 0;
    NS_G = 0;

    EW_R = 0;
    EW_Y = 0;
    EW_G = 0;

    PED_WALK = 0;

    case(state)

    //----------------------------------------
    // S0
    //----------------------------------------
    S0_NS_GREEN:
    begin
        NS_G = 1;
        EW_R = 1;
    end

    //----------------------------------------
    // S1
    //----------------------------------------
    S1_NS_YELLOW:
    begin
        NS_Y = 1;
        EW_R = 1;
    end

    //----------------------------------------
    // S2
    //----------------------------------------
    S2_EW_GREEN:
    begin
        NS_R = 1;
        EW_G = 1;
    end

    //----------------------------------------
    // S3
    //----------------------------------------
    S3_EW_YELLOW:
    begin
        NS_R = 1;
        EW_Y = 1;
    end

    //----------------------------------------
    // S4
    //----------------------------------------
    S4_ALL_RED:
    begin
        NS_R = 1;
        EW_R = 1;
    end

    //----------------------------------------
    // S5
    //----------------------------------------
    S5_PED_WALK:
    begin
        NS_R = 1;
        EW_R = 1;
        PED_WALK = 1;
    end

    default:
    begin
        NS_G = 1;
        EW_R = 1;
    end

    endcase
end

endmodule