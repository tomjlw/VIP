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
For a small raw data, with length smaller than 10000, Matlab and GPU actually
makes no much difference. However, if the data length is bigger than 10000,
CPU will run much fastr than Matlab. One thing to notice is that, here I just
measure the time of running calculation with GPU, thw whole process cost
more time actually and most of it comes from the process of copying data from
and to between GPU and CPU.  
