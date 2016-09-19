//
//  SymbolCell.m
//  KeylessEmo
//
//  Created by Rett Pop on 2016-03-29.
//  Copyright © 2016 SapiSoft. All rights reserved.
//

#import "SymbolCell.h"
#import "UIView+SSUIViewCategory.h"
#include "KEConstants.h"

@interface SymbolCell()
{
    BOOL handlesStarTap;
    BOOL _isStarred;
}
    @property (strong, nonatomic) IBOutlet UILabel *symbolFace;
    @property (strong, nonatomic) IBOutlet UILabel *symbolName;
    @property (strong, nonatomic) IBOutlet UIButton *btnFav;

@end

@implementation SymbolCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setHandlesStarTap:false];
    [_symbolName setNumberOfLines:2];
    _isStarred = NO;
    [self setStarred:_isStarred];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setName:(NSString *)name
{
    [_symbolName setText:[name capitalizedString]];
}

-(void)setSymbol:(NSString *)symbol
{
    [_symbolFace setText:symbol];
}

-(void)setStarred:(BOOL)isStarred
{
    [[_btnFav titleLabel] setTextColor:isStarred ? kColorActiveStar:kColorInactiveStar];
}

-(void)setHandlesStarTap:(BOOL)handles
{
    handlesStarTap = handles;
    [_btnFav setHidden:!handles];
}

-(IBAction)starTapped:(id)sender
{
    //[_btnFav addTarget:[self accessoryView] action:<#(nonnull SEL)#> forControlEvents:<#(UIControlEvents)#>]
    [[_tableView delegate] tableView:_tableView accessoryButtonTappedForRowWithIndexPath:_indexPath];
}

@end
