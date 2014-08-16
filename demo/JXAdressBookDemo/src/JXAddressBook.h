//
//  JXAddressBook.h
//  通讯录
//
//  Created by andy on 8/15/14.
//  Copyright (c) 2014 JianXiang Jin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import "JXPersonInfo.h"

@interface JXAddressBook : NSObject
typedef void (^JXAddressBookBlock) (NSArray *personInfos);

#pragma mark - Instance Method

/**
 *  获取用户所有通讯录信息
 *
 *  @return 所有通讯录数据信息数组
 */
- (void)getPersonInfo:(JXAddressBookBlock)addressBookBlock;

/**
 *  根据关键字匹配所有用户信息
 *
 *  @param keyWord 匹配关键字
 *
 *  @return 匹配到的通讯录数据信息数组
 */
- (void)searchPersonInfo:(NSString *)keyWord addressBookBlock:(JXAddressBookBlock)addressBookBlock;

#pragma mark - Class Method

/**
 *  获取用户所有通讯录信息
 *
 *  @return 所有通讯录数据信息数组
 */
+ (void)getPersonInfo:(JXAddressBookBlock)addressBookBlock;

/**
 *  根据关键字匹配所有用户信息
 *
 *  @param keyWord 匹配关键字
 *
 *  @return 匹配到的通讯录数据信息数组
 */
+ (void)searchPersonInfo:(NSString *)keyWord addressBookBlock:(JXAddressBookBlock)addressBookBlock;

@end
