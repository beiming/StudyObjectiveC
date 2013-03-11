//
//  main.m
//  CassicsSortAlgorithm
//
//  Created by peixin liu on 3/9/13.
//  Copyright (c) 2013 peixin liu. All rights reserved.
//

#import <Foundation/Foundation.h>

void testMemoryLackForReplaceElement();
//交换数组两个位置对象
void swapElementFromArray(NSMutableArray *arr, int i, int j);
//快速排序
int partition(NSMutableArray *arr, int low, int high);
void quickSort(NSMutableArray *arr, int low, int high);
void quickSort2(NSMutableArray *arr, int low, int high);
void quickSort3(NSMutableArray *arr, int low, int high);
//选择排序
void selectSort(NSMutableArray *arr);
//冒泡排序
void bubbleSort(NSMutableArray *arr);
//直接插入排序
void straightInsertSort(NSMutableArray *arr);
//链表插入排序
void listInsertSort(NSMutableArray *arr);
//二分插入排序
void binarySearchInsertSort(NSMutableArray *arr);
//二分查找/折半查找
int binarySearch(NSMutableArray *arr, id obj, int low, int high);
//希尔排序
void shellSort(NSMutableArray *arr);
void shellSort2(NSMutableArray *arr);

int main(int argc, const char * argv[])
{
    
    @autoreleasepool
    {
        NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:@4,@8,@7,@9,@3,@5,@6,@2,nil];
        NSLog(@"origin arr:\n%@",arr);
        //selectSort(arr);
        //bubbleSort(arr);
        //straightInsertSort(arr);
        //listInsertSort(arr);
        //binarySearchInsertSort(arr);
        //quickSort1(arr, 0, (int)arr.count - 1);
        //quickSort2(arr, 0, (int)arr.count - 1);
        //quickSort3(arr, 0, (int)arr.count - 1);
        //shellSort(arr);
        shellSort2(arr);
        NSLog(@"after sort:%@",arr);
        [arr release];
    }
    return 0;
}

void testMemoryLackForReplaceElement()
{
    NSMutableString *str1 = [[NSMutableString alloc] initWithString:@"str1"];
    NSMutableString *str2 = [[NSMutableString alloc] initWithString:@"str2"];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [arr addObject:str1];
    //这个等同于replace，会release原来的值，不会造成内存泄漏
    arr[0] = str2;
    NSLog(@"str1 retainCount=%lu, str2 retainCount=%lu", str1.retainCount, str2.retainCount);
    [arr release];
    [str1 release];
    [str2 release];
}

void swapElementFromArray(NSMutableArray *arr, int i, int j)
{
    id temp = arr[i];
    arr[i] = arr[j];
    arr[j] = temp;
}

int partition(NSMutableArray *arr, int low, int high)
{
    //NSLog(@"quickSort1 range:[%i, %i]", low, high);
    NSNumber *pivot = arr[low];
    while (low < high)
    {
        while (low < high && arr[high] >= pivot)
        {
            high--;
        }
        arr[low] = arr[high];
        while (low < high && arr[low] <= pivot)
        {
            low++;
        }
        arr[high] = arr[low];
    }
    arr[low] = pivot;
    return low;
}

void quickSort(NSMutableArray *arr, int low, int high)
{
    if(low < high)
    {
        int position = partition(arr, low, high);
        quickSort(arr, low, position - 1);
        quickSort(arr, position + 1, high);
    }
}

void quickSort2(NSMutableArray *arr, int low, int high)
{
    if(low < high)
    {
        int originLow = low, originHigh = high;
        //NSLog(@"quickSort2 range:[%i, %i]", low, high);
        NSNumber *pivot = arr[low];
        while (low < high)
        {
            while (low < high && arr[high] >= pivot)
            {
                high--;
            }
            arr[low] = arr[high];
            while (low < high && arr[low] <= pivot)
            {
                low++;
            }
            arr[high] = arr[low];
        }
        arr[low] = pivot;
        quickSort2(arr, originLow, low - 1);
        quickSort2(arr, low + 1, originHigh);
    }
}

void quickSort3(NSMutableArray *arr, int low, int high)
{
    if(low < high)
    {
        //NSLog(@"quickSort2 range:[%i, %i]", low, high);
        //左右两个指针分别向中间游走，直到遇到low > pivot high < pivot停止，交换两者，再次循环
        int originLow = low, originHigh = high;
        id pivot = arr[low];
        while (low < high)
        {
            while(low < high && arr[high] > pivot)
            {
                high--;
            }
            while (low < high && arr[low] < pivot)
            {
                low++;
            }
            swapElementFromArray(arr, low, high);
        }
        arr[low] = pivot;
        quickSort3(arr, originLow, low - 1);
        quickSort3(arr, low + 1, originHigh);
    }
}

void selectSort(NSMutableArray *arr)
{
    //每次选一个最小or最大的，放在数组首位（交换位置），以此类推
    for(int i = 0; i < arr.count; i++)
    {
        int minIndex = i;
        for(int j = i + 1; j < arr.count; j++)
        {
            if(arr[j] < arr[minIndex])
            {
                minIndex = j;
            }
        }
        //NSLog(@"selectSort minElement: %i", [arr[minIndex] intValue]);
        swapElementFromArray(arr, i, minIndex);
    }
}

void bubbleSort(NSMutableArray *arr)
{
    //两两比较，每次冒出一个最大or最小的数字
    for(int i = 0; i < arr.count; i++)
    {
        for(int j = 0; j < arr.count - i - 1; j++)
        {
            if(arr[j] > arr[j+1])
            {
                swapElementFromArray(arr, j, j+1);
            }
        }
        NSLog(@"bubbleSort index %i reslut:\n %@", i, arr);
    }
}

void straightInsertSort(NSMutableArray *arr)
{
    //数组分为两部分，有序和无序，从无序中每次取一个往有序中插入，在有序中search位置，然后插入（后续元素整体后移），算法开始认为第一个元素是有序的，其他都是无序的。
    for(int i = 1; i < arr.count; i++)
    {
        id addElement = arr[i];
        int j = i - 1;
        while(j != -1 && arr[j] > addElement)
        {
            arr[j+1] = arr[j];
            j--;
        }
        arr[j+1] = addElement;
        //NSLog(@"straightInsertSort index %i reslut:\n %@", i, arr);
    }
}

void listInsertSort(NSMutableArray *arr)
{
    for(int i = 1; i < arr.count; i++)
    {
        id addElement = arr[i];
        int j = i - 1;
        while (j >= 0 && arr[j] < addElement)
        {
            j--;
        }
        //用数组代替链表演示
        [arr removeObject:addElement];
        [arr insertObject:addElement atIndex:j+1];
        NSLog(@"listInsertSort index %i reslut:\n %@", i, arr);
    }
}

int binarySearch(NSMutableArray *arr, id obj, int low, int high)
{
    if(low < high)
    {
        int midIndex = (low + high) / 2;
        //NSLog(@"binarySearch range:[%i, %i], %i", low, high, midIndex);
        if(arr[midIndex] == obj)
        {
            return midIndex;
        }
        /*
         这里如果数组是倒序排列，则大的在前，小的在后，所以这里可以换改变< 号 为 > 来改变查找的顺序
        与之对应的，如果逆序，后面 obj < arr[low] low + 1
         */
        //数组正序
        else if(obj < arr[midIndex])
        {
            return binarySearch(arr, obj, low, midIndex - 1);
        }
        else
        {
            return binarySearch(arr, obj, midIndex + 1, high);
        }
    }
    else
    {
        //NSLog(@"%i, %i", low, high);
        /*
         当返回的区间段 low >= high 的时候，说明没找到，这时候可以通过判断大小，判断出所寻找对象 相对于当前数组对象的index
        low == high 直接判断arr[low]和obj 的大小，if obj > arr[low] index = low + 1 else index = low
        low > high只有一个可能，就是low == midIndex ，然后midIndex － 1，说明是obj < arr[midIndex] 所以，obj要插入的index 就是low
        或者这么理解，因为向下取整，low总是有个有意义的index，只比较arr[low] 和 obj的大小即可
         */
        //数组正序情况
        if(obj > arr[low])
        {
            return low + 1;
        }
        else
        {
            return low;
        }
    }
}
void binarySearchInsertSort(NSMutableArray *arr)
{
    for(int i = 1; i < arr.count; i++)
    {
        id addElement = arr[i];
        int j = i - 1;
        int objIndex = binarySearch(arr, addElement, 0, j);
        while(j >= objIndex)
        {
            arr[j+1] = arr[j];
            //printf("swap %i, %i\n", j + 1, j);
            j--;
        }
        arr[j+1] = addElement;
        //[arr removeObject:addElement];
        //[arr insertObject:addElement atIndex:objIndex];
        //NSLog(@"binarySearchInsertSort index:%i,finded index %i value %i reslut:\n %@", i, objIndex, [addElement intValue], arr);
    }
}

void shellSort(NSMutableArray *arr)
{
    /*希尔排序是插入排序的变种，把步长为step的element看成一个子数组，进行插入排序
     每次排序后，每个子组在整个数组中元素相对有序，然后step缩小，直至为1，最后一次插入排序完成，整个排序完成
     这样会大大减少元素顺次交换操作，因为在一个相对有序的数组里，插入排序做的交换操作会少
     */
    //这个是在一个循环序列里，对每个分组相对同一位置的元素进行插入排序，待循环完毕，所有分组才会被遍历完成
    
    //分组几次，循环
    for(int step = (int)arr.count/2; step > 0; step /= 2)
    {
        //按步长，可以分成几个组，循环
        //i 指向每个分组未排序的第一个数
        //i++ 遍历每个分组的后续数字，每次＋1，每个分组的下一个数字插入完成
        //j －= step 保证每个分组各自排序，虽然是在一次循环序列里
        for(int i = step; i < arr.count; i++)
        {
            //j指向每个分组已经排序好的最后一个数
            int j = i - step;
            id addElement = arr[i];
            //插入排序，用待插入数字和已排序号的数字里每个数字比较，逆向，逐个移动
            //printf("insertSort ordered:(... -> %i,%i)\n", j, i);
            while (j >= 0 && arr[j] > addElement)
            {
                arr[j+step] = arr[j];
                //printf("swap %i, %i\n", j + step, j);
                j -= step;
            }
            arr[j+step] = addElement;
        }
        //NSLog(@"\nstep=%i\n%@",step, arr);
    }
}

void shellSort2(NSMutableArray *arr)
{
    //这个是在一个循环序列里，先针对一个分组排序完毕，然后下一个分组，上shellSort略有不同
    
    //步长，循环
    for(int step = (int)arr.count/2; step > 0; step /=2)
    {
        //分组个数，按每个小组循环
        for(int groupCount = 0; groupCount < step; groupCount++)
        {
            //每个组，逐个进行插入排序
            for(int i = step + groupCount; i < arr.count; i += step)
            {
                int j = i - step;
                id addElement = arr[i];
                //这里刚开始少了个＝号，让我调试半天。。。j >= 0
                while(j >= 0 && arr[j] < addElement)
                {
                    arr[j+step] = arr[j];
                    j -= step;
                }
                arr[j+step] = addElement;
            }
        }
    }
}