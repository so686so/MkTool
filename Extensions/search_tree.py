# IMPORT
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
import os
import sys
import subprocess

# PATH
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
HOME_PATH   = os.path.expanduser('~')
SEARCH_PATH = os.path.join(HOME_PATH, 'blackbox/source')
CUT_PATH    = os.path.join(HOME_PATH, 'blackbox')

SAVE_PATH   = os.path.join(HOME_PATH, 'MkTool/Extensions')
SAVE_NAME   = "openDirName.tree"


# CUSTOM DEFINE
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
CODE_EXT    = [ '.c', '.cpp', '.h', 'makefile', 'Makefile' ]
SKIP_DIR    = [ 'mpp', 'ldws_img' ]


# CONST
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
DEPTH               = 0
PATH_NAME           = 1
CODE_COUNT          = 2
FILE_COUNT          = 3
FILE_SIZE           = 4
FULL_PATH           = 5

SHOW_DETAIL_DEPTH   = 2
MAIN_BRANCH         = 1
SUB_BRANCH          = 2
CHILD_BRANCH        = 3

C_SKY               = "\x1b[1;36m"
C_GREEN             = "\x1b[32m"
C_RED               = "\x1b[1;31m"
C_YELLOW            = "\x1b[33m"
C_DIM               = "\x1b[2m"
C_RESET             = "\x1b[0m"

C_SET               = "\x1b[1m[ \x1b[34mSET \x1b[0m\x1b[1m]\x1b[0m"
C_ERROR             = "\x1b[1m[ \x1b[31mERROR \x1b[0m\x1b[1m]\x1b[0m"


# CLASS
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
class BlackBoxTree:
    def __init__(self, SrchWord=None) -> None:
        self.resultList     = []
        self.maxDepth       = 0
        self.baseName       = CUT_PATH
        self.lineFinishList = []
        self.fullPathList   = []
        self.selectNum      = -1
        self.searchWord     = ""
        
        if SrchWord is not None:
            self.searchWord = SrchWord

        self.check_path()        
        
    def check_path(self):
        if os.path.isdir(SEARCH_PATH) is False:
            print(f'[ {SEARCH_PATH} ] Not Exist!')
            sys.exit(-1)
            
    def recursive_search(self, parent:str, depth=0):
        try:
            fileList    = os.listdir(parent)
            fileCount   = 0
            codeCount   = 0
            fileSize    = 0
            
            for fileName in fileList:
                
                if fileName in SKIP_DIR:
                    continue
                
                fullName = os.path.join(parent, fileName)
                
                if os.path.isdir(fullName):
                    self.recursive_search(fullName, depth+1)
                    
                else:
                    _, ext = os.path.splitext(fullName)
                    
                    if ext in CODE_EXT:
                        codeCount += 1
                    else:
                        fileCount += 1
                    
                    try:
                        fileSize += os.path.getsize(fullName)
                    except Exception:
                        pass
                        
            shortenPath = parent.split(CUT_PATH)[-1]
            self.resultList.append([depth, shortenPath, codeCount, fileCount, fileSize, parent])
        
        except PermissionError:
            pass
        
        
    def calc_branch_icon(self) -> str:
        res         = ""
        curDepth    = self.resultList[-1][DEPTH]
        
        NONE_BRANCH = "   "
        LINE_BRANCH = " │ "
        FORK_BRANCH = " ├─"
        END_BRANCH  = " └─"
        
        if curDepth == MAIN_BRANCH:
            res     += END_BRANCH
            return res
        
        res         += NONE_BRANCH
        
        # Set Check Depth List
        branchCheckList = self.resultList.copy()
        branchCheckList.reverse()
        depthList       = []
        
        for eachArg in branchCheckList:
            eachDth = eachArg[DEPTH]
            
            if eachDth == SUB_BRANCH:
                break
            
            depthList.append(eachArg[DEPTH])
            
        for idx in range(2, self.maxDepth+1):
            if idx > curDepth:
                break
            
            curDepthList = self.get_tmp_depth_list(depthList, curDepth)

            if curDepth not in depthList:
                self.set_lineFinishList(curDepth, True)
            
            if idx == curDepth:
                if curDepthList.count(idx) == 1:
                    self.set_lineFinishList(curDepth, True)
                    res += END_BRANCH
                else:
                    if self.get_next_depth(depthList) < curDepth:
                        res += END_BRANCH
                        
                    elif self.get_next_depth(depthList) > curDepth:
                        if self.is_depth_jump(depthList, curDepth):
                            self.set_lineFinishList(curDepth, True)
                            res += END_BRANCH
                        else:
                            self.set_lineFinishList(curDepth, False)
                            res += FORK_BRANCH
                    else:
                        res += FORK_BRANCH
            else:
                if self.is_lineFinished(idx):
                    res += NONE_BRANCH
                else:
                    res += LINE_BRANCH

        return res
    
    def is_depth_jump(self, depthPlist:list, curDepth:int) -> bool:
        for eachDepth in depthPlist[1:]:
            if eachDepth == curDepth:
                return False
            if eachDepth < curDepth:
                return True
                
    
    def get_next_depth(self, depthList:list) -> int:
        if len(depthList) >= 2:
            return depthList[1]
        else:
            return 1
    
    
    def get_tmp_depth_list(self, depthList:list, curDepth:int) -> list:
        res = []
        dList = depthList.copy()
        isFinish = False
        
        for eachDepth in dList:
            res.append(eachDepth)
            if eachDepth == curDepth:
                if isFinish:
                    break
                else:
                    isFinish = True
        
        return res
    
    
    def calc_max_depth(self) -> None:
        self.maxDepth       = max(each[DEPTH] for each in self.resultList)
        self.lineFinishList = [ False for _ in range(self.maxDepth+1) ]
        
    def reset_lineFinishList(self):
        self.lineFinishList = [ False for _ in range(self.maxDepth+1) ]
        
    def set_lineFinishList(self, depth, bTrue=True):
        self.lineFinishList[depth] = bTrue
        
    def is_lineFinished(self, depth):
        return self.lineFinishList[depth]
        
    def show_by_depth(self):
        DFLT_NAME_LEN   = 60
        DFLT_DASH_LEN   = 100
        forLen          = len(self.resultList)
        
        for idx in range(forLen):
            branchIcon      = self.calc_branch_icon()
            curArg          = self.resultList.pop()
            curDepth  :int  = curArg[DEPTH]
            curPath   :str  = curArg[PATH_NAME]
            curCCount :int  = curArg[CODE_COUNT]
            curFCount :int  = curArg[FILE_COUNT]
            curSize   :float= curArg[FILE_SIZE] / (1024)
            curFullPath:str = curArg[FULL_PATH]
            
            self.fullPathList.append(curFullPath)
            
            isValidSearch   = True
            SearchValue     = self.searchWord
            
            if curFullPath.find(SearchValue) == -1:
                isValidSearch = False
            
            if curDepth == MAIN_BRANCH:
                self.reset_lineFinishList()

            curSlashCount   = curPath.count('/')
            fileName        = curPath.replace(self.baseName, '.')
            MsgLen          = DFLT_NAME_LEN - ( (curSlashCount - SHOW_DETAIL_DEPTH) * 3 )
            dashLen         = MsgLen - len(fileName) - 2
            
            if idx % 5 == 0:
                if curDepth == SHOW_DETAIL_DEPTH:
                    dashLine = f" {C_DIM}" + ( "-" * (MsgLen - 3) ) + f"{C_RESET} "
                else:
                    dashLine = f" {C_DIM}" + ( "-" * dashLen ) + f"{C_RESET} "
            else:
                dashLine = ""
            
            if curSize > 1024:
                curSize = curSize / 1024
                curSizeStr = f"{C_YELLOW}{round(curSize, 2):>8}Mb{C_RESET}"
            else:
                curSizeStr = f"{round(curSize, 2):>8}Kb"
                
            
            fileName += dashLine
            
            if curDepth == SHOW_DETAIL_DEPTH:
                self.baseName   = curPath
                fileName        = fileName.replace(self.baseName, '.')
                
                if isValidSearch is False:
                    continue
                
                print(f'\n  [{C_GREEN}{self.baseName}{C_RESET}]')
                print(f'{branchIcon} {fileName:<{MsgLen}} #{idx:>3}.  {curCCount:>3} Codes {curFCount:>3} Files {curSizeStr}')
                
            elif curDepth > SHOW_DETAIL_DEPTH:
                if isValidSearch is False:
                    continue

                if curCCount + curFCount == 0:
                    print(f'{branchIcon} {fileName:<{MsgLen}} #{idx:>3}.  ---------- Only Dir ----------')
                else:
                    print(f'{branchIcon} {fileName:<{MsgLen}} #{idx:>3}.  {curCCount:>3} Codes {curFCount:>3} Files {curSizeStr}')
                    
            else:
                dashLen = DFLT_DASH_LEN - len(curPath)
                print(f'\n == {C_SKY}{curPath}{C_RESET} ', '='*dashLen)
                print(f'{branchIcon} {".":<{DFLT_NAME_LEN}} #{idx:>3}.  {curCCount:>3} Codes {curFCount:>3} Files {curSizeStr}')
        print()
        
        self.save_open_dir_name(self.select_num_to_open_file(forLen))
        
    def save_open_dir_name(self, selectNum):
        if os.path.isdir(SAVE_PATH) is False:
            os.makedirs(SAVE_PATH, exist_ok=True)
        
        savePath = os.path.join(SAVE_PATH, SAVE_NAME)
        
        if selectNum == -1:
            if os.path.isfile(savePath):
                os.remove(savePath)
            return

        with open(savePath, 'w') as wf:
            wf.write(f'{self.fullPathList[selectNum]}')
    

    def select_num_to_open_file(self, maxLen):
        while True:
            num = input(f"\n{C_SET} Select Num To Open Dir ( quit : q ) - ")
            
            if num == "q" or num == "Q":
                print(f"{C_SET} Tree Exit")
                return -1
                
            try:
                num = int(num)
                
                if num <= maxLen:
                    return num
                else:
                    print(f"{C_ERROR} Not Valid Select Num")
                    
            except Exception:
                pass


    def run(self):
        self.recursive_search(SEARCH_PATH)
        self.calc_max_depth()
        self.show_by_depth()
        
        
def set_param_by_argv():
    if len(sys.argv) >= 2:
        return sys.argv[1]
    else:
        return None
        
if __name__ == "__main__":
    app = BlackBoxTree(set_param_by_argv())
    app.run()