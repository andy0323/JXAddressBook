#import "JXAddressBook.h"

@interface JXAddressBook()
@property (nonatomic, copy) JXAddressBookBlock addressBookBlock;
@end

@implementation JXAddressBook

#pragma mark -
#pragma mark - Public Class Method

#pragma mark ____Instance Method

/**
 *  获取用户所有通讯录信息
 */
- (void)getPersonInfo:(JXAddressBookBlock)addressBookBlock
{
    self.addressBookBlock = addressBookBlock;
    [self searchPersonInfo:@""];
}
/**
 *  根据关键字匹配所有用户信息
 */
- (void)searchPersonInfo:(NSString *)keyWord addressBookBlock:(JXAddressBookBlock)addressBookBlock
{
    self.addressBookBlock = addressBookBlock;
    [self searchPersonInfo:keyWord];
}

/**
 *  根据姓名进行数组的重排序
 */
- (NSArray *)sortPersonInfos:(NSArray *)personInfos
{
    if (![personInfos isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableArray *arr = [NSMutableArray array];
    for (NSObject *obj in personInfos) {
        if (![obj isKindOfClass:[JXPersonInfo class]]) {
            continue;
        }
        
        JXPersonInfo *personInfo = (JXPersonInfo *)obj;
        
    }
    
    return arr;
}

#pragma mark -
#pragma mark ____Class Method

/**
 *  获取用户所有通讯录信息
 */
+ (void)getPersonInfo:(JXAddressBookBlock)addressBookBlock
{
    [[self alloc] getPersonInfo:addressBookBlock];
}

/**
 *  根据关键字匹配所有用户信息
 */
+ (void)searchPersonInfo:(NSString *)keyWord addressBookBlock:(JXAddressBookBlock)addressBookBlock
{
    [[self alloc] searchPersonInfo:keyWord addressBookBlock:addressBookBlock];
}

/**
 *  根据姓名进行数组的重排序
 */
+ (NSArray *)sortPersonInfos:(NSArray *)personInfos
{
    return [[self alloc] sortPersonInfos:personInfos];
}

#pragma mark -
#pragma mark ____Private Methods

/**
 *  根据关键字查询通讯录信息
 */
- (void)searchPersonInfo:(NSString *)keyWord
{
    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    
    // 开始查询通讯录
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        
        if (granted) {
            [self filterContentForSearchText:keyWord];
        }
    });
}

/**
 *  开始匹配通讯录信息
 */
- (void)filterContentForSearchText:(NSString*)searchText
{
    //如果没有授权则退出
    if (ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized) {
        return;
    }
    
    NSArray *blockArray = [NSArray array];
    
    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    
    if([searchText length]==0)
    {
        //查询所有
        blockArray = (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
        
    } else {

        //条件查询
        CFStringRef cfSearchText = (CFStringRef)CFBridgingRetain(searchText);
        blockArray = CFBridgingRelease(ABAddressBookCopyPeopleWithName(addressBook, cfSearchText));
       
        CFRelease(cfSearchText);
    }
    
    // 类型转换
    blockArray = transformElements(blockArray);
    
    // 返回BlockArray
    self.addressBookBlock(blockArray);
}

/**
 *  将所有元素转化为JXPersonInfo类型数组
 */
NSArray* transformElements(NSArray* arr)
{
    NSMutableArray *rtnArray = [NSMutableArray array];
    for (int i = 0; i < arr.count; i++) {
        ABRecordRef recordRef = CFBridgingRetain([arr objectAtIndex:i]);
        JXPersonInfo *personInfo = [JXPersonInfo personInfoWithABRecordRef:recordRef];
        
        [rtnArray addObject:personInfo];
    }
    return rtnArray;
}

@end
