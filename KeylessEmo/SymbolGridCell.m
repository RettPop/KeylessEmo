//
//  CollectionCellView.m
//  KeylessEmo
//
//  Created by Rett Pop on 2016-09-19.
//  Copyright © 2016 SapiSoft. All rights reserved.
//

#import "SymbolGridCell.h"
#include "KEConstants.h"

@interface SymbolGridCell()
    @property(weak, nonatomic) id customObject;
    @property(weak, nonatomic) id<SymbolGridCellDelegate> delegate;
    @property (nonatomic, strong) IBOutlet UILabel *lblSymbol;
    @property (nonatomic, strong) IBOutlet UIButton *btnStar;

    - (IBAction)starTapped:(id)sender;

@end


@implementation SymbolGridCell

- (IBAction)starTapped:(id)sender
{
    if( [_delegate respondsToSelector:@selector(symbolGridCellView:starTappedWithCustomObject:)] ) {
        [_delegate symbolGridCellView:self starTappedWithCustomObject:_customObject];
    }
}

-(void)setStarActivity:(BOOL)isActive
{
    [[_btnStar titleLabel] setTextColor:isActive ? kColorActiveStar:kColorInactiveStar];
}

-(void)setDelegate:(id<SymbolGridCellDelegate>) delegate withCustomObject:(id)custObj
{
    _delegate = delegate;
    _customObject = custObj;
}

-(void)setSymbol:(NSString *)symbol
{
    [_lblSymbol setText:symbol];
}

@end
