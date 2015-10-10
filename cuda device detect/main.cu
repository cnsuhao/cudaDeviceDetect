#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include <cuda_runtime.h>

int main (int argc,char** argv)
{
	int deviceCount;   //the numbers of cudaDevive
	cudaError_t cudaStatus;  //catch the error
	
	cudaStatus = cudaGetDeviceCount(&deviceCount);      //get the numbers of the cudaDevice

	if(cudaStatus != cudaSuccess){
		printf("get cudaDevice numbers Error %d\n",cudaStatus);
		return false;
	}

	if(0 == deviceCount){
		printf("There is no device supporting CUDA\n");
	}

	int dev;

	for(dev = 0; dev < deviceCount; ++dev ){
		cudaDeviceProp deviceProp;
		cudaStatus = cudaGetDeviceProperties(&deviceProp,dev);

		if(cudaStatus != cudaSuccess){
			printf("Get cudaDeviceProperties error: %d",cudaStatus);
			return false;
		}

		if( 0 == dev ){
			if(deviceProp.major == 9999 && deviceProp.minor == 9999)
				printf("This is no device supporting CUDA.\n");
			else if(1 == deviceCount)
				printf("There is 1 device supporting CUDA.\n");
			else
				printf("There are %d devices supporting CUDA\n",deviceCount);
		}
		printf("\nDevice %d:\"%s\"\n", dev,deviceProp.name);
		printf("	Major revision number:				%d\n",
					deviceProp.major);
		printf("	Minor revision number:				%d\n",
			        deviceProp.minor);

		printf("	Total amount of global memory:			%u bytes\n",
					deviceProp.totalGlobalMem);


#if CUDART_VERSION >= 2000
	printf("	Number of multiprocessors			%d\n",
				deviceProp.multiProcessorCount);						//numbers of SM
	printf("	Number of cores:				%d\n",
				8*deviceProp.multiProcessorCount);                      //numbers of SP
#endif


		printf("	Total amount of constant memory:		%u bytes\n",
					deviceProp.totalConstMem);

		printf("	Total amount of shared memory per block:	%u bytes\n",
					deviceProp.sharedMemPerBlock);

		printf("	Total number of registers available per block:	%d\n",
					deviceProp.regsPerBlock);

		printf("	Maximum sizes of each dimemsion of a block:	%d x %d x %d\n",
			deviceProp.maxThreadsDim[0],
			deviceProp.maxThreadsDim[1],
			deviceProp.maxThreadsDim[2]);

		printf("	Maximum sizes of each dimemsion of a grib:	%d x %d x %d\n",
			deviceProp.maxGridSize[0],
			deviceProp.maxGridSize[1],
			deviceProp.maxGridSize[2]);


		printf("	Maximum memproy pitch:				%u bytes\n",
					deviceProp.memPitch);

		printf("	Texture alignment:				%u bytes\n",
					deviceProp.textureAlignment);

		printf("	Clock rate:					%.2f GHz\n",
					deviceProp.clockRate * 1e-6f);
#if CUDART_VERSION >= 2000
	printf("	Concurrent copy and execution:			%s\n",
		deviceProp.deviceOverlap ? "Yes" : "No");
#endif
	}
	printf("\nTest PASSED\n");
	
	return true;
}
