//
//  TodayViewController.m
//  EmoWidget
//
//  Created by Rett Pop on 2016-03-30.
//  Copyright © 2016 SapiSoft. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "KEOptionsHelper.h"
#import "KEConstants.h"
#import "OneSymbol.h"
#import "UIView+SSUIViewCategory.h"

#define kDefBorder 5.f
#define kDefSpace 5.f
#define kIconWidth 20.f
#define kDefButtonHeight 30.f
#define kHistoryBtnTag 10
#define kFavoriteBtnTag 20


@interface TodayViewController () <NCWidgetProviding>
{
    BOOL _showHistory;
    BOOL _showFavorites;
    
    NSArray *_lstFavorites;
    NSArray *_lstHistory;
    NSMutableArray *_lstButtons;
    
//    UIButton *_btnOpenHostApp;
}
@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.extensionContext setWidgetLargestAvailableDisplayMode:NCWidgetDisplayModeExpanded];
    // Do any additional setup after loading the view from its nib.

    _showHistory = [KEOptionsHelper boolValueForKey:kKeyNameShowHistory];
    _showFavorites = [KEOptionsHelper boolValueForKey:kKeyNameShowFavorites];
    
    
//    if( _showHistory )
    {
        
        _lstHistory = [KEOptionsHelper arrayValueForKey:kKeyNameStoredHistory];
        if( !_lstHistory ) {
            // just to have empty array
            _lstHistory = @[];
        }
    }
    
//    if( _showFavorites )
    {
        _lstFavorites = [KEOptionsHelper arrayValueForKey:kKeyNameStoredFavorites];
        if( !_lstFavorites ) {
            // just to have empty array
            _lstFavorites = @[];
        }
    }
    
    [self createButtonsFrom:_lstHistory andFavorites:_lstFavorites];
}

-(void)createButtonsFrom:(NSArray*)history andFavorites:(NSArray *)favorites
{
    _lstButtons = [NSMutableArray arrayWithCapacity:[history count] + [favorites count] + 1]; //+ launch app button
    
    // adding button to switch to hosting app — first button in list
    NSUInteger position = 0;
    //    _btnOpenHostApp = [self createButtonWithTitle:LOC(@"button.Title.OpenHostApp") action:@selector(btnOpenHostAppTapped:) onPosition:position++];
    //    [[_btnOpenHostApp titleLabel] setTextColor:[UIColor whiteColor]];
    //
    //    [_lstGeneral addObject:_btnOpenHostApp];
    //    [[self view] addSubview:_btnOpenHostApp];
    
    // add buttons with symbols from history and favorites
    for( NSArray *oneArray in @[history, favorites] )
    {
        int btnTag = [oneArray isEqual:history] ? kHistoryBtnTag : kFavoriteBtnTag;
        for (OneSymbol *oneSymbol in oneArray)
        {
            UIButton *btnSymbol = [self createButtonWithTitle:[oneSymbol presentation]
                                                       action:@selector(btnCopySymbolTapped:)
                                                   onPosition:position];
            [btnSymbol setTag:btnTag];
            [[self view] addSubview:btnSymbol];
            position++;
            [_lstButtons addObject:btnSymbol];
        }
    }
}

-(void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize
{
    if( activeDisplayMode == NCWidgetDisplayModeExpanded )
    {
        CGFloat oneButtonSpace = kDefButtonHeight + kDefSpace;
        oneButtonSpace *= [_lstButtons count];
        [self setPreferredContentSize: CGSizeMake(CGRectGetWidth([[self view] bounds]), oneButtonSpace)];
    }
    else
    {
        [self setPreferredContentSize:maxSize];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}


-(void)viewWillAppear:(BOOL)animated
{
    CGFloat oneButtonSpace = kDefButtonHeight + kDefSpace;
    //if( _showClearCipboard && _showDTLong )
    {
        oneButtonSpace *= [_lstButtons count];
    }
    CGSize prefSize = self.preferredContentSize;
    prefSize.height = oneButtonSpace * 2;
//    [self setPreferredContentSize: CGSizeMake(CGRectGetWidth([[self view] bounds]), oneButtonSpace)];
//    [self setPreferredContentSize: prefSize];
//    [_btnClearClipboard setNewWidth:CGRectGetWidth([[self view] bounds])];
//    [_btnCopyDateTime setNewWidth:CGRectGetWidth([[self view] bounds])];
}


-(UIButton *)createButtonWithTitle:(NSString *)title action:(SEL)actioin onPosition:(NSUInteger)position
{
    CGFloat btnWidth = CGRectGetWidth([[self view] bounds]) - kIconWidth - kDefSpace - 100;
    UIButton *newButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [newButton setFrame:CGRectMake(0, 0, btnWidth, kDefButtonHeight)];
    [newButton addTarget:self action:actioin forControlEvents:UIControlEventTouchUpInside];
    [newButton setTitle:title forState:UIControlStateNormal];
    [[newButton titleLabel] setTextColor:[UIColor whiteColor]];
    [newButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [newButton setBackgroundColor:[UIColor clearColor]];
    
    [newButton changeFrameXDelta:.0f yDelta:(kDefButtonHeight + kDefSpace) * position];
    
    return newButton;
}

- (IBAction)btnCopySymbolTapped:(id)sender
{
    UIPasteboard *pb = [UIPasteboard generalPasteboard];
//    OneSymbol *oneSymbol = [sender valueForKey:kKeyNameStoredSymbol];
    //[pb setString:[oneSymbol presentation]];
    NSString* presentation = [[sender titleLabel] text];
    [pb setString:presentation];
    
    [self updateHistory:sender];
}

-(void)updateHistory:(UIButton *)byButton
{
    // update only if it was history button
    if( kFavoriteBtnTag == [byButton tag] ) {
        return;
    }
    
    NSString* presentation = [[byButton titleLabel] text];
    NSMutableArray *newHistory = [[NSMutableArray alloc] initWithArray:_lstHistory];
    for (OneSymbol* oneSymbol in newHistory)
    {
        if( [[oneSymbol presentation] isEqualToString:presentation] )
        {
            if( [newHistory indexOfObject:oneSymbol] > 0 )
            {
                [newHistory removeObject:oneSymbol];
                [newHistory insertObject:oneSymbol atIndex:0];
            }
            break;
        }
    }
    
    _lstHistory = nil;
    _lstHistory = newHistory;
    [KEOptionsHelper setOptionArrayValue:_lstHistory forKey:kKeyNameStoredHistory];
    
    for (UIButton* oneBtn in _lstButtons) {
        [oneBtn removeFromSuperview];
    }
    
    [_lstButtons removeAllObjects];
    _lstButtons = nil;
    [self createButtonsFrom:_lstHistory andFavorites:_lstFavorites];
}

- (IBAction)btnOpenHostAppTapped:(id)sender
{
    NSURL *url = [NSURL URLWithString:@"keylessemo://"];
    [[self extensionContext] openURL:url completionHandler:nil];
}

@end
