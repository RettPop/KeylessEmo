//
//  KEConstants.h
//  KeylessEmo
//
//  Created by Rett Pop on 2016-03-31.
//  Copyright © 2016 SapiSoft. All rights reserved.
//

#ifndef KEConstants_h
#define KEConstants_h

#ifdef DEBUG
#define DLog( s, ... ) NSLog( @"%@%s:(%d)> %@", [[self class] description], __PRETTY_FUNCTION__ , __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#define DAssert(A, B, ...) NSAssert(A, B, ##__VA_ARGS__);
#define DLogv( var ) NSLog( @"%@%s:(%d)> "# var "=%@", [[self class] description], __PRETTY_FUNCTION__ , __LINE__, var ] )
#elif DEBUG_PROD
#define DLog( s, ... ) NSLog( @"%@%s:(%d)> %@", [[self class] description], __PRETTY_FUNCTION__ , __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#define DLogv( var ) NSLog( @"%@%s:(%d)> "# var "=%@", [[self class] description], __PRETTY_FUNCTION__ , __LINE__, var ] )
#define DAssert(A, B, ...) NSAssert(A, B, ##__VA_ARGS__);
#else
#define DLog( s, ... )
#define DAssert(...)
#define DLogv(...)
#endif


#define LOC(key) NSLocalizedString((key), @"")

#define kKeyNameShowHistory @"showHistory"
#define kKeyNameShowFavorites @"showFavorites"
#define kKeyNameStoredFavorites @"storedFavorites"
#define kKeyNameStoredHistory @"storedHistory"
#define kKeyNameStoredSymbol @"storedSymbol"

#define kAppGroupName @"group.com.sapisoft.KeyelessEmo"


#define NSSTring NSString


#endif /* KEConstants_h */
