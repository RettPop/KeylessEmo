//
//  OneSymbol.h
//  KeylessEmo
//
//  Created by Rett Pop on 2016-03-27.
//  Copyright © 2016 SapiSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OneSymbol : NSObject<NSCoding>

@property (assign, nonatomic) NSNumber *ID;
@property (strong, nonatomic) NSArray  *codes;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *presentation;
@property (strong, nonatomic) NSString *tags;

-(instancetype)initWithName:(NSString *)name presentation:(NSString *)presentation;
-(instancetype)initWithName:(NSString *)name codes:(NSArray *)codes;

+(NSString *)EmojiByCode:(NSUInteger)code;


@end
