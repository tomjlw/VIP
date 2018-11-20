# VIP Project 
Basically, this is a small project based on cuda, which is used to design a 
FIR filter and compare run-time of GPU and that of normal method thus that 
we can get a basic idea about how well GPU can behave in dealing with massive
data calculation.

# Development Process  
First, I used matlab to design a filter as a kind of proof of concept. 
By using the matlab built-in filtering function, I can measure the time of
calculation by simply using CPU. Then I used cuda and record the run-time 
of GPU, so that I can compare runtime of both. 

# Result
For raw data with length 1201, GPU takes 11.6 microseconds to execute the kernel while matlab needs 197 mcroseconds.
