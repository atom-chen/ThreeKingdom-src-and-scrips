#include "UtilTxtFile.h"

unsigned char* UtilTxtFile::openFile(const char* fileName, unsigned long * pSize)
{
	unsigned char * pBuffer = NULL;
    CCAssert(fileName != NULL && pSize != NULL, "Open file -- Invalid parameters.");
    *pSize = 0;
	int count = 0;

    string fullPath = CCFileUtils::sharedFileUtils()->fullPathForFilename(fileName);
    FILE *fp = fopen(fullPath.c_str(), "r");

	if(fp)
	{
        fseek(fp,0,SEEK_END);

        *pSize = ftell(fp);
        fseek(fp,0,SEEK_SET);
        pBuffer = new unsigned char[*pSize];
		char c;
		while ((c = fgetc(fp)) != EOF)
		{
			pBuffer[count] = c;
			count++;
		}
		pBuffer[count] = 0;
        fclose(fp);
	}
    
    if (!pBuffer)
    {
        string msg = "Get data from file(";
        msg.append(fileName).append(") failed!");
        CCLOG("%s", msg.c_str());
    }
    return pBuffer;
}

void UtilTxtFile::saveFile(const char* fileName, const char* content)
{
	CCAssert(fileName != NULL && content != NULL, "Save File -- Invalid parameters.");

	string fullPath = CCFileUtils::sharedFileUtils()->fullPathForFilename(fileName);
	FILE* fp = fopen(fullPath.c_str(), "w");
    if (fp)
	{
        fputs(content, fp);
        fclose(fp);
    }
}