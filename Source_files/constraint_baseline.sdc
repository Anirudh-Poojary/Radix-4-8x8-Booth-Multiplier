# 1. Create a Virtual Clock
# We define a 100MHz clock (10ns period) as a starting point.
# You can decrease this value (e.g., to 2ns) to push the tool harder.
create_clock -name VCLK -period 10.0

# 2. Set Input/Output Delays
# We assume 20% of the period is consumed outside this block.
set_input_delay 2.0 -clock VCLK [all_inputs]
set_output_delay 2.0 -clock VCLK [all_outputs]

# 3. Set Design Constraints
# 'Max Delay' is the most critical for your paper results.
# This represents the "Target Latency" you want for the multiplier.
set_max_delay 10.0 -from [all_inputs] -to [all_outputs]

# 4. Environment Attributes
# Setting a load helps the tool calculate realistic power and transition times.
set_load 0.1 [all_outputs]

