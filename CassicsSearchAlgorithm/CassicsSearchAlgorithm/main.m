//
//  main.m
//  CassicsSearchAlgorithm
//
//  Created by peixin liu on 3/9/13.
//  Copyright (c) 2013 peixin liu. All rights reserved.
//

#import <Foundation/Foundation.h>

//二分查找/折半查找
int binarySearch(NSArray *arr, id obj, int low, int high);

int main(int argc, const char * argv[])
{

    @autoreleasepool
    {
        NSArray *arr = @[@4,@8,@7,@9,@3,@5,@6,@2];
        arr = [arr sortedArrayUsingSelector:@selector(compare:)];
        NSLog(@"origin arr:\n%@",arr);
        int result = binarySearch(arr, @8, 0, (int)arr.count - 1);
        if(result != -1)
        {
            NSLog(@"finded index is %i, value is %i", result, [arr[result] intValue]);
        }
        else
        {
            NSLog(@"not find!");
        }
    }
    return 0;
}

int binarySearch(NSArray *arr, id obj, int low, int high)
{
    if(low < high)
    {
        int mid = (int)((low + high)/2);
        if(arr[mid] == obj)
        {
            return mid;
        }
        else if(arr[mid] > obj)
        {
            return binarySearch(arr,obj, low, mid-1);
        }
        else
        {
            return binarySearch(arr,obj, mid + 1, high);
        }
    }
    else
    {
        return -1;
    }
}

