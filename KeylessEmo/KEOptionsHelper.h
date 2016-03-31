//
//  KEOptionsHelper.h
//  KeylessEmo
//
//  Created by Rett Pop on 2016-03-31.
//  Copyright © 2016 SapiSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KEOptionsHelper : NSObject

+(BOOL)boolValueForKey:(NSString *)keyName;
+(NSString *)stringValueForKey:(NSString *)keyName;
+(NSArray *)arrayValueForKey:(NSString *)keyName;

+(void)setOptionBoolValue:(BOOL)value forKey:(NSString *)keyName;
+(void)setOptionStringValue:(NSString *)value forKey:(NSString *)keyName;
+(void)setOptionArrayValue:(NSArray *)value forKey:(NSString *)keyName;


@end
