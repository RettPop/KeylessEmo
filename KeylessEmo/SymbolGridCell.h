//
//  CollectionCellView.h
//  KeylessEmo
//
//  Created by Rett Pop on 2016-09-19.
//  Copyright © 2016 SapiSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SymbolGridCell;

@protocol SymbolGridCellDelegate <NSObject>
    @optional
        -(void)symbolGridCellView:(SymbolGridCell *)collCell starTappedWithCustomObject:(id)customObject;
@end


@interface SymbolGridCell : UICollectionViewCell

    -(void)setStarActivity:(BOOL)isActive;
    -(void)setDelegate:(id<SymbolGridCellDelegate>) delegate withCustomObject:(id)custObj;
    -(void)setSymbol:(NSString *)symbol;
@end
