//
//  CollectionCellView.h
//  KeylessEmo
//
//  Created by Rett Pop on 2016-09-19.
//  Copyright © 2016 SapiSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CollectionCellView;

@protocol CollectionCellViewDelegate <NSObject>
    @optional
        -(void)collectionCellView:(CollectionCellView *)collCell starTappedWithCustomObject:(id)customObject;
@end


@interface CollectionCellView : UICollectionViewCell

    -(void)setStarActivity:(BOOL)isActive;
    -(void)setDelegate:(id<CollectionCellViewDelegate>) delegate withCustomObject:(id)custObj;
    -(void)setSymbol:(NSString *)symbol;
@end
