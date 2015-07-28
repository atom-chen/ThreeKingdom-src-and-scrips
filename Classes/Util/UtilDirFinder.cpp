//#include "Include/UtilDirFinder.h"
//
//bool UtilDirFinder::isDirExist(const char* dir, int type)
//{
//	_finddata_t fileInfo;
//	long file = _findfirst(dir, &fileInfo);
//	bool res = (file != -1 || (fileInfo.attrib & type));
//	_findclose(file);
//	return res;
//}
//
//bool UtilDirFinder::isFileExist(const char* dir)
//{
//	bool res = isDirExist(dir, ~_A_SUBDIR);
//	return res;
//}
//
//void UtilDirFinder::enterSubDir(const char* dir)
//{
//	_chdir(dir);
//}
//
//UtilDirFinder::UtilDirFinder()
//{
//	m_file = 0;
//}
//
//UtilDirFinder::~UtilDirFinder()
//{
//
//}
//
//bool UtilDirFinder::findFirst(const char* dir)
//{
//	m_file = _findfirst(dir, &m_findData);
//	return (m_file != -1);
//}
//
//bool UtilDirFinder::findNext()
//{
//	bool res = findNext(ANY_DIR_TYPE);
//	return res;
//}
//
//bool UtilDirFinder::findNext(int type)
//{
//	int res = _findnext(m_file, &m_findData);
//	bool isSame = (m_findData.attrib & type);
//	return (res == 0 && isSame);
//}
//
//char* UtilDirFinder::getDirName()
//{
//	char* res = m_findData.name;
//	return res;
//}
//
//bool UtilDirFinder::isSubDir()
//{
//	bool res = (m_findData.attrib & _A_SUBDIR);
//	return res;
//}
//
