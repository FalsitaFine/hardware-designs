In dm_cache_data.sv, to make debug/grading easier, I changed the display so it will output which way the program is actually using.

In dm_cache_fsm, I used a variable named "way" in the dm_cache_fsm.sv. It works well.

Also, because sometimes the fsm goes into tag_compare more than once, I used a variable "controller" to make sure that if it goes into tag_compare for the second time, it won't change anything this time.
