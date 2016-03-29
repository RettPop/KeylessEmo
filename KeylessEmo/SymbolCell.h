//
//  SymbolCell.h
//  KeylessEmo
//
//  Created by Rett Pop on 2016-03-29.
//  Copyright © 2016 SapiSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SymbolCell : UITableViewCell

-(void)setName:(NSString *)name;
-(void)setSymbol:(NSString *)symbol;
-(void)setStarred:(BOOL)isStarred;
-(void)setHandlesStarTap:(BOOL)handles;

@property(strong, nonatomic) NSIndexPath *indexPath;
@property(strong, nonatomic) UITableView *tableView;

@end
