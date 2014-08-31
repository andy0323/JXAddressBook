#import "JXPersonInfo.h"

#define nullStrToEmpty(str) \
[str rangeOfString:@"null"].location==0? @"" : str

@implementation JXPersonInfo

- (id)initWithABRecordRef:(ABRecordRef)ref
{
    if (self = [super init]) {
        _recordRef = ref;
    }
    return self;
}

+ (id)personInfoWithABRecordRef:(ABRecordRef)ref
{
    return [[[self class] alloc] initWithABRecordRef:ref];
}

/**
 *  单值信息
 */
#define GET_PROPERTY_METHOD(property, property_key) \
- (NSString *)property {\
    return (NSString *)CFBridgingRelease(ABRecordCopyValue(_recordRef, property_key));\
}
GET_PROPERTY_METHOD( firstName    , kABPersonFirstNameProperty);
GET_PROPERTY_METHOD( lastName     , kABPersonLastNameProperty);
GET_PROPERTY_METHOD( middlename   , kABPersonMiddleNameProperty);
GET_PROPERTY_METHOD( prefix       , kABPersonPrefixProperty);
GET_PROPERTY_METHOD( suffix       , kABPersonSuffixProperty);
GET_PROPERTY_METHOD( nickname     , kABPersonNicknameProperty);
GET_PROPERTY_METHOD( organization , kABPersonOrganizationProperty);
GET_PROPERTY_METHOD( jobtitle     , kABPersonJobTitleProperty);
GET_PROPERTY_METHOD( department   , kABPersonDepartmentProperty);
GET_PROPERTY_METHOD( birthday     , kABPersonBirthdayProperty);
GET_PROPERTY_METHOD( note         , kABPersonNoteProperty);
GET_PROPERTY_METHOD( firstknow    , kABPersonCreationDateProperty);
GET_PROPERTY_METHOD( lastknow     , kABPersonModificationDateProperty);
GET_PROPERTY_METHOD( firstnamePhonetic , kABPersonFirstNamePhoneticProperty);
GET_PROPERTY_METHOD( lastnamePhonetic  , kABPersonLastNamePhoneticProperty);
GET_PROPERTY_METHOD( middlenamePhonetic, kABPersonMiddleNamePhoneticProperty);

/**
 *  多值信息
 */
#define DICT_ADD_STR_FOR_KEY(dict, str, key) \
if (str) {\
    [dict setObject:str forKey:key];\
}
#define GET_PROPERTY_SIGLE_VALUE_METHOD(property, property_key)\
- (NSArray *)property\
{\
    NSMutableArray *rtnArray = [NSMutableArray array];\
\
    ABMultiValueRef ref = ABRecordCopyValue(_recordRef, property_key);\
    long count = ABMultiValueGetCount(ref);\
    for (int i = 0; i < count; i++)\
    {\
        NSString* label = (__bridge NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(ref, i));\
        NSString* content = (__bridge NSString*)ABMultiValueCopyValueAtIndex(ref, i);\
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];\
        DICT_ADD_STR_FOR_KEY(dict, content, label);\
        \
        [rtnArray addObject:dict];\
    }\
    return rtnArray;\
}
GET_PROPERTY_SIGLE_VALUE_METHOD(email, kABPersonEmailProperty)
GET_PROPERTY_SIGLE_VALUE_METHOD(dates, kABPersonDateProperty)
GET_PROPERTY_SIGLE_VALUE_METHOD(url  , kABPersonURLProperty)
GET_PROPERTY_SIGLE_VALUE_METHOD(phone, kABPersonPhoneProperty)

- (NSString *)kind
{
    NSString *rtnStr = nil;
    CFNumberRef recordType = ABRecordCopyValue(_recordRef, kABPersonKindProperty);
    if (recordType == kABPersonKindOrganization) {
        rtnStr = @"company";
    } else {
        rtnStr = @"person";
    }
    return rtnStr;
}

- (NSArray *)iMessage
{
    NSMutableArray *rtnArray = [NSMutableArray array];
    
    ABMultiValueRef instantMessage = ABRecordCopyValue(_recordRef, kABPersonInstantMessageProperty);
    for (int i = 1; i < ABMultiValueGetCount(instantMessage); i++)
    {
        NSString* label = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(instantMessage, i);
        NSDictionary* content =(__bridge NSDictionary*) ABMultiValueCopyValueAtIndex(instantMessage, i);
        
        NSMutableDictionary *imessageInfoDict = [NSMutableDictionary dictionary];
        NSString* username = [content valueForKey:(NSString *)kABPersonInstantMessageUsernameKey];
        NSString* service = [content valueForKey:(NSString *)kABPersonInstantMessageServiceKey];
        DICT_ADD_STR_FOR_KEY(imessageInfoDict, username, @"username");
        DICT_ADD_STR_FOR_KEY(imessageInfoDict, service,  @"service");
        
        NSDictionary *imessageDict = @{label: imessageInfoDict};
        [rtnArray addObject:imessageDict];
    }
    return rtnArray;
}

-(NSArray *)address
{
    NSMutableArray *rtnArray = [NSMutableArray array];
    
    ABMultiValueRef address = ABRecordCopyValue(_recordRef, kABPersonAddressProperty);
    long count = ABMultiValueGetCount(address);
    for(int i = 0; i < count; i++)
    {
        NSString* addressLabel = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(address, i);
        NSDictionary* personaddress =(__bridge NSDictionary*) ABMultiValueCopyValueAtIndex(address, i);
        
        NSMutableDictionary *addressInfoDict = [NSMutableDictionary dictionary];
        NSString* country = [personaddress valueForKey:(NSString *)kABPersonAddressCountryKey];
        NSString* city = [personaddress valueForKey:(NSString *)kABPersonAddressCityKey];
        NSString* state = [personaddress valueForKey:(NSString *)kABPersonAddressStateKey];
        NSString* street = [personaddress valueForKey:(NSString *)kABPersonAddressStreetKey];
        NSString* zip = [personaddress valueForKey:(NSString *)kABPersonAddressZIPKey];
        NSString* coutntrycode = [personaddress valueForKey:(NSString *)kABPersonAddressCountryCodeKey];
        DICT_ADD_STR_FOR_KEY(addressInfoDict, country,      @"country");
        DICT_ADD_STR_FOR_KEY(addressInfoDict, city,         @"city");
        DICT_ADD_STR_FOR_KEY(addressInfoDict, state,        @"state");
        DICT_ADD_STR_FOR_KEY(addressInfoDict, street,       @"street");
        DICT_ADD_STR_FOR_KEY(addressInfoDict, zip,          @"zip");
        DICT_ADD_STR_FOR_KEY(addressInfoDict, coutntrycode, @"coutntrycode");
        
        NSDictionary *addressDict = @{addressLabel: addressInfoDict};
        [rtnArray addObject:addressDict];
    }
    return rtnArray;
}

- (UIImage *)image
{
    NSData *data = (__bridge NSData*)ABPersonCopyImageData(_recordRef);
    return [UIImage imageWithData:data];
}

#pragma mark -
#pragma mark - CustomProperty
/**
 *  全名
 */
- (NSString *)fullName
{
    return [NSString stringWithFormat:@"%@%@%@",
            nullStrToEmpty(self.lastName),
            nullStrToEmpty(self.middlename),
            nullStrToEmpty(self.firstName)];
}
- (NSString *)firstSpell
{
    return getFirstSpell(self.fullName);
}

/**
 *  输出模型所有信息
 */
- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ -- InfoPacket",
            self.fullName];
}

/**
 *  获取首字母
 */
NSString* getFirstSpell(NSString *fullName)
{
    NSMutableString *ms = [[NSMutableString alloc] initWithString:fullName];
    CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO);
    
    if (fullName.length > 0)
        return [[ms substringWithRange:NSMakeRange(0, 1)] lowercaseString];
    else
        return @"#";
}

@end