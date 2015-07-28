#include "MemoryCount.h"

// 获取当前设备剩余内存（单位：KB）
float availableMemory()
{
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(),
                                               HOST_VM_INFO,
                                               (host_info_t)&vmStats,
                                               &infoCount);
    
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    
    return ((vm_page_size *vmStats.free_count) / 1024.0);
}

// 获取当前任务所占用的内存（单位：KB）
float usedMemory()
{
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)&taskInfo, &infoCount);
    
    if (kernReturn != KERN_SUCCESS)
    {
        return NSNotFound;
    }
    
    return taskInfo.resident_size / 1024.0;
}

static Memory* s_instance = NULL;

Memory* Memory::sharedInstance()
{
    if (s_instance == NULL)
    {
        s_instance = new Memory();
    }
    return s_instance;
}

float Memory::getFreeMemoryKB()
{
    return availableMemory();
}

float Memory::getUsedMemoryKB()
{
    return usedMemory();
}

float Memory::getFreeMemoryMB()
{
    return availableMemory() / 1024;
}

float Memory::getUsedMemoryMB()
{
    return usedMemory() / 1024;
}