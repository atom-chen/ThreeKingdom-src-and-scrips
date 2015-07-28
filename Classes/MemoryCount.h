#import <sys/sysctl.h>
#import <mach/mach.h>

float availableMemory();
float usedMemory();

class Memory
{
public:
    static Memory* sharedInstance();
    float getFreeMemoryKB();
    float getUsedMemoryKB();
    float getFreeMemoryMB();
    float getUsedMemoryMB();
};

