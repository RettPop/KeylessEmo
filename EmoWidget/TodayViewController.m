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
#define kIconWidth 30.f
#define kDefButtonHeight 40.f



@interface TodayViewController () <NCWidgetProviding>
{
    BOOL _showHistory;
    BOOL _showFavorites;
    
    NSArray *_lstFavorites;
    NSArray *_lstHistory;
    NSMutableArray *_lstGeneral;
    
    UIButton *_btnOpenHostApp;
}
@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

    DLog(@"_lstHistory has %lu records", [_lstHistory count]);
    DLog(@"_lstFavorites has %lu records", (unsigned long)[_lstFavorites count]);
    _lstGeneral = [NSMutableArray arrayWithCapacity:[_lstHistory count] + [_lstFavorites count] + 1]; //+ launch app button
    
    // adding button to switch to hosting app — first button in list
    NSUInteger position = 0;
    _btnOpenHostApp = [self createButtonWithTitle:LOC(@"button.Title.OpenHostApp") action:@selector(btnOpenHostAppTapped:) onPosition:position++];
    [_lstGeneral addObject:_btnOpenHostApp];
    [[self view] addSubview:_btnOpenHostApp];

    for( NSArray *oneArray in @[_lstHistory, _lstFavorites] )
    {
        for (OneSymbol *oneSymbol in oneArray)
        {
            UIButton *btnSymbol = [self createButtonWithTitle:[oneSymbol presentation] action:@selector(btnCopySymbolTapped:) onPosition:position];
            [[self view] addSubview:btnSymbol];
            position++;
            [_lstGeneral addObject:btnSymbol];
        }
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
        oneButtonSpace *= [_lstGeneral count];
    }
    [self setPreferredContentSize: CGSizeMake(CGRectGetWidth([[self view] bounds]), oneButtonSpace)];
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
    //OneSymbol *oneSymbol = [sender valueForKey:kKeyNameStoredSymbol];
    //[pb setString:[oneSymbol presentation]];
    [pb setString:[[sender titleLabel] text]];
}


- (IBAction)btnOpenHostAppTapped:(id)sender
{
    NSURL *url = [NSURL URLWithString:@"keylessemo://"];
    [[self extensionContext] openURL:url completionHandler:nil];
}

@end
