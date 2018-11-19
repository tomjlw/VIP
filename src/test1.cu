#include <cuda.h>
#include <stddef.h>
#include <cstddef>
#include <iostream>
#include <stdlib.h>
#include <stdio.h>
#include <chrono> 
#include "read.h"

using namespace std;
using namespace std::chrono; 

#define Lh 65 //filter length
#define Lx 1201 //input signal length

__global__ void filterData(const float *d_data,
                           const float *d_numerator, 
                           float *d_filteredData, 
                           const int numeratorLength,
                           const int filteredDataLength)
{
   int i = blockDim.x * blockIdx.x + threadIdx.x;
   float sum = 0;

    if (i < filteredDataLength)
    {
        for (int j = 0; j < numeratorLength; j++)
        {
            sum += d_numerator[j] * d_data[i + numeratorLength - j - 1];
        }
    }

    d_filteredData[i] = sum;
}


int main(void)
{   float z[10000], b[10000]; 
    read(z, b);
   
    // (Skipping error checks to make code more readable)
    clock_t start, end;
    unsigned long micros = 0;
    int dataLength = Lx;
    int filteredDataLength = Lx;
    int numeratorLength= Lh;
    
    // Pointers to data, filtered data and filter coefficients
    // (Skipping how these are read into the arrays)
    float *h_data = new float[dataLength];
    float *h_filteredData = new float[filteredDataLength];
    float *h_filter = new float[numeratorLength];
      
    for (int i=0;i<dataLength;i++){
    h_data[i] = z[i];
    }
    for (int j=0;j<numeratorLength;j++){
    h_filter[j] = b[j];
    }

    // Create device pointers
    float *d_data = nullptr;
    cudaMalloc((void **)&d_data, dataLength * sizeof(float));

    float *d_numerator = nullptr;
    cudaMalloc((void **)&d_numerator, numeratorLength * sizeof(float));

    float *d_filteredData = nullptr;
    cudaMalloc((void **)&d_filteredData, filteredDataLength * sizeof(float));


    // Copy data to device
    cudaMemcpy(d_data, h_data, dataLength * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(d_numerator, h_filter, numeratorLength * sizeof(float), cudaMemcpyHostToDevice);  

    // Launch the kernel
    int threadsPerBlock = 256;
    int blocksPerGrid = (filteredDataLength + threadsPerBlock - 1) / threadsPerBlock;
    start = clock();
    filterData<<<blocksPerGrid,threadsPerBlock>>>(d_data, d_numerator, d_filteredData, numeratorLength, filteredDataLength);
    end = clock();
    micros = end - start;
    //cout<<micros;

    // Copy results to host
    cudaMemcpy(h_filteredData, d_filteredData, filteredDataLength * sizeof(float),  cudaMemcpyDeviceToHost);
    for (int i=0;i<filteredDataLength;i++){
    printf("%lf\n",h_filteredData[i]);}
    // Clean up
    cudaFree(d_data);
    cudaFree(d_numerator);
    cudaFree(d_filteredData);

    // Do stuff with h_filteredData...

    // Clean up some more
    delete [] h_data;
    delete [] h_filteredData;
    delete [] h_filter;
}
