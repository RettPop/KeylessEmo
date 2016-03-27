//
//  OneSymbol.m
//  KeylessEmo
//
//  Created by Rett Pop on 2016-03-27.
//  Copyright © 2016 SapiSoft. All rights reserved.
//

#import "OneSymbol.h"

@implementation OneSymbol

-(instancetype)initWithName:(NSString *)name presentation:(NSString *)presentation
{
    self = [super init];
    if( self )
    {
        [self setName:name];
        [self setPresentation:presentation];
    }
    
    return self;
}

-(instancetype)initWithName:(NSString *)name codes:(NSArray *)codes
{
    return [self initWithName:name presentation:[OneSymbol EmojiByCodes:codes]];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_ID forKey:@"ID"];
    [aCoder encodeObject:_name forKey:@"Name"];
    [aCoder encodeObject:[NSArray arrayWithArray: _codes] forKey:@"Codes"];
    [aCoder encodeObject:_presentation forKey:@"Presentation"];
    [aCoder encodeObject:_tags forKey:@"Tags"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if( self )
    {
        [self setID:[aDecoder decodeObjectForKey:@"ID"]];
        [self setName:[aDecoder decodeObjectForKey:@"Name"]];
        NSArray *tmpArray = [aDecoder decodeObjectForKey:@"Codes"];
        [self setCodes:[NSMutableArray arrayWithArray:tmpArray]];
        [self setPresentation:[aDecoder decodeObjectForKey:@"Presentation"]];
        [self setTags:[aDecoder decodeObjectForKey:@"Tags"]];
    }
    
    return self;
}


+(NSString *)EmojiByCode:(NSUInteger)code
{
    NSString *oneEmoji =[[NSString alloc] initWithBytes:&code length:sizeof(code) encoding:NSUTF32LittleEndianStringEncoding];
    return [oneEmoji substringToIndex:[oneEmoji length]-1];
}

+(NSString *)EmojiByCodes:(NSArray *)codes
{
    NSString *str = @"";
    for (NSNumber* oneCode in codes) {
        str = [str stringByAppendingString:[OneSymbol EmojiByCode:[oneCode unsignedIntegerValue]]];
    }
    return str;
}

@end
