#include <cuda.h>
#include <cstddef>
#include <iostream>
#include <stdlib.h>
#include <stdio.h>
#include <chrono> 

using namespace std;
using namespace std::chrono; 

__global__ void filterData(const float *d_data,
                           const float *d_numerator, 
                           float *d_filteredData, 
                           const int numeratorLength,
                           const int filteredDataLength)
{
    int i = blockDim.x * blockIdx.x + threadIdx.x;

    if (i < filteredDataLength)
    {   float sum = 0.0f;
        for (int j = 0; j < numeratorLength; j++)
        {
            // The first (numeratorLength-1) elements contain the filter state
            sum += d_numerator[j] * d_data[i + numeratorLength - j - 1];
        }
        d_filteredData[i] = sum;
    }

    //d_filteredData[i] = sum;
}

int main(void)
{
    // (Skipping error checks to make code more readable)
    clock_t start, end;
    unsigned long micros = 0;
    int dataLength = 1024;
    int filteredDataLength = 1024;
    int numeratorLength= 1024;

    // Pointers to data, filtered data and filter coefficients
    // (Skipping how these are read into the arrays)
    float *h_data = new float[dataLength];
    float *h_filteredData = new float[filteredDataLength];
    float *h_filter = new float[numeratorLength];
      
    for (int i=0;i<dataLength;i++){
    h_data[i] = (float)rand()/(float)(RAND_MAX/2);
    }
    for (int j=0;j<numeratorLength;j++){ 
    h_filter[j] = (float)rand()/(float)(RAND_MAX/0.5);
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
    cout<<micros;

    // Copy results to host
    cudaMemcpy(h_filteredData, d_filteredData, filteredDataLength * sizeof(float), cudaMemcpyDeviceToHost);
    //for (int i=0;i<filteredDataLength;i++){
	//printf("%lf\n",h_filteredData[i]);}
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
