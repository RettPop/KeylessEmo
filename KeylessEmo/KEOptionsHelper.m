//
//  KEOptionsHelper.m
//  KeylessEmo
//
//  Created by Rett Pop on 2016-03-31.
//  Copyright © 2016 SapiSoft. All rights reserved.
//

#import "KEOptionsHelper.h"
#import "KEConstants.h"

@implementation KEOptionsHelper

+(BOOL)boolValueForKey:(NSString *)keyName
{
    NSUserDefaults *def = [[NSUserDefaults alloc] initWithSuiteName:kAppGroupName];
    BOOL boolValue = [[def valueForKey:keyName] boolValue];
    def = nil;
    return boolValue;
}

+(NSString *)stringValueForKey:(NSString *)keyName
{
    NSUserDefaults *def = [[NSUserDefaults alloc] initWithSuiteName:kAppGroupName];
    NSString *value = [def valueForKey:keyName];
    def = nil;
    return value;
}

+(NSArray *)arrayValueForKey:(NSString *)keyName
{
    NSUserDefaults *def = [[NSUserDefaults alloc] initWithSuiteName:kAppGroupName];
    NSData *data = [def objectForKey:keyName];
    NSArray *array = nil;
    if( data ) {
        array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    def = nil;
    data = nil;
    return array;
}


+(void)setOptionBoolValue:(BOOL)value forKey:(NSString *)keyName
{
    NSUserDefaults *def = [[NSUserDefaults alloc] initWithSuiteName:kAppGroupName];
    [def setValue:[NSNumber numberWithBool:value] forKey:keyName];
    def = nil;
}

+(void)setOptionStringValue:(NSString *)value forKey:(NSString *)keyName
{
    NSUserDefaults *def = [[NSUserDefaults alloc] initWithSuiteName:kAppGroupName];
    [def setValue:value forKey:keyName];
    def = nil;
}

+(void)setOptionArrayValue:(NSArray *)value forKey:(NSString *)keyName
{
    NSUserDefaults *def = [[NSUserDefaults alloc] initWithSuiteName:kAppGroupName];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:value];
    [def setObject:data forKey:keyName];
    def = nil;
}

@end
