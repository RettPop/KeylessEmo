//
//  ViewController.m
//  KeylessEmo
//
//  Created by Rett Pop on 2016-03-26.
//  Copyright © 2016 SapiSoft. All rights reserved.
//  http://unicode.org/emoji/charts/full-emoji-list.html

#import "ViewController.h"
#import "OneSymbol.h"

typedef enum : NSUInteger {
    TAB_TYPE_GENERAL = 1,
    TAB_TYPE_HISTORY,
    TAB_TYPE_FAVORITES,
} TAB_TYPE;

@interface ViewController ()
{
    NSMutableArray * _lstHistory;
    NSMutableArray * _lstFavorites;
    NSMutableArray * _lstGeneral;
    NSArray * _lstCurrent;
}
@property (strong, nonatomic) IBOutlet UITableView *emojiTable;
@property (strong, nonatomic) IBOutlet UITextField *selectedSymbols;
@property (strong, nonatomic) IBOutlet UIButton *btnCopy;
@property (strong, nonatomic) IBOutlet UITabBar *tabBar;

@property (strong, nonatomic) IBOutlet UITabBarItem *tbitemHistory;
@property (strong, nonatomic) IBOutlet UITabBarItem *tbitemFavorites;
@property (strong, nonatomic) IBOutlet UITabBarItem *tbitemMore;
@property (strong, nonatomic) IBOutlet UITabBarItem *tbitemAll;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self fillStoredLists];
    
    [_tabBar setDelegate:self];
    [_emojiTable setDelegate:self];
    [_emojiTable setDataSource:self];
    [_selectedSymbols setDelegate:self];
    
    [_selectedSymbols setClearButtonMode:UITextFieldViewModeAlways];
    [self changeTab:TAB_TYPE_GENERAL];
    
//    UIView *dummy = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
//    [_selectedSymbols setInputView:dummy];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fillStoredLists
{
    // loading stored favourites and history from user preferences
    _lstGeneral = [[NSMutableArray alloc] initWithCapacity:10];
    
    [_lstGeneral addObject:[[OneSymbol alloc] initWithName:@"SLIGHTLY SMILING FACE" codes:@[@0x1F642]]];
    [_lstGeneral addObject:[[OneSymbol alloc] initWithName:@"WHITE LEFT POINTING BACKHAND INDEX, backhand index pointing left" codes: @[@0x1F448]]];
    [_lstGeneral addObject:[[OneSymbol alloc] initWithName:@"WHITE LEFT POINTING BACKHAND INDEX, TYPE-1-2" codes:@[@0x1F448, @0x1F3FB]]];
    [_lstGeneral addObject:[[OneSymbol alloc] initWithName:@"THUMBS UP SIGN, thumbs up" codes:@[@0x1F44D]]];
    [_lstGeneral addObject:[[OneSymbol alloc] initWithName:@"Family: MAN, WOMAN, BOY" codes:@[@0x1F468, @0x200D, @0x1F469, @0x200D, @0x1F466]]];
    

    _lstHistory = [[NSMutableArray alloc] initWithCapacity:10];
    _lstFavorites = [[NSMutableArray alloc] initWithCapacity:10];

    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    NSData *data = [defs objectForKey:@"History"];
    if( data ) {
        NSArray *tmp = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [_lstHistory addObjectsFromArray:tmp];
    }
    
    data = [defs objectForKey:@"Favorites"];
    if( data ) {
        NSArray *tmp = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [_lstFavorites addObjectsFromArray:tmp];
    }
}

-(void)storeLists
{
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_lstHistory];
    [defs setObject:data forKey:@"History"];
    
    data = [NSKeyedArchiver archivedDataWithRootObject:_lstFavorites];
    [defs setObject:data forKey:@"Favorites"];
}

-(TAB_TYPE)currentTabType
{
    TAB_TYPE tab = TAB_TYPE_GENERAL;
    if( _tbitemHistory == [_tabBar selectedItem] ) {
        tab = TAB_TYPE_HISTORY;
    }
    else if( _tbitemFavorites == [_tabBar selectedItem] ) {
        tab = TAB_TYPE_FAVORITES;
    }
//    else if( _tbitemMore == [_tabBar selectedItem] ) {
//        tab = TAB_TYPE_FAVORITES;
//    }
    
    return tab;
}

-(void)changeTab:(TAB_TYPE)toType
{
    // state changing
    
    NSArray *newArray = nil;
    switch (toType)
    {
        case TAB_TYPE_HISTORY:
            newArray = _lstHistory;
            break;
            
        case TAB_TYPE_FAVORITES:
            newArray = _lstFavorites;
            break;
            
        case TAB_TYPE_GENERAL:
        default:
            newArray = _lstGeneral;
            break;
    }
    
    BOOL needReload = (_lstCurrent != newArray) && (_lstCurrent != nil);
    _lstCurrent = newArray;
    
    if ( needReload ){
        [_emojiTable reloadData];
    }
    
}

- (IBAction)btnCopyTapped:(id)sender
{
    if ( 0 < _selectedSymbols.text.length ) {
        [self copySelectedSymbols];
    }
}

-(void)copySelectedSymbols
{
    // need separate method to perform store activities
    
    // save to history
    OneSymbol *newSymb = [[OneSymbol alloc] initWithName:_selectedSymbols.text presentation:_selectedSymbols.text];

    // look through history for presentation that is copied.
    // May be make more convenient
    for (OneSymbol *oneSymbol in _lstHistory)
    {
        if( [[oneSymbol presentation] isEqualToString:[newSymb presentation]] )
        {
            // move found image to beginning
            [_lstHistory removeObject:oneSymbol];
            break;
        }
    }
    
    // text was not found in history. saving it
    [_lstHistory insertObject:newSymb atIndex:0];
    
    if( TAB_TYPE_HISTORY == [self currentTabType]){
        [_emojiTable reloadData];
    }
    
    [self storeLists];
    
    [[UIPasteboard generalPasteboard] setString:newSymb.presentation];
}

#pragma mark -
#pragma mark UITableView delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_lstCurrent count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = @"default cell";
    UITableViewCell *newCell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if( nil == newCell )
    {
        newCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    OneSymbol *oneSymbol = [_lstCurrent objectAtIndex:[indexPath row]];
    [[newCell textLabel] setText:[oneSymbol presentation]];
    
    if( TAB_TYPE_GENERAL == [self currentTabType] ) {
        [[newCell detailTextLabel] setText:[oneSymbol name]];
    }
    else {
        [[newCell detailTextLabel] setText:@""];
    }
    
    return newCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OneSymbol *newSymbol = [_lstCurrent objectAtIndex:indexPath.row];
    [_selectedSymbols setText:[[_selectedSymbols text] stringByAppendingString:[newSymbol presentation]]];
}

#pragma mark -
#pragma mark UITabBar delegate
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    TAB_TYPE newtype = TAB_TYPE_GENERAL;
    if( item == _tbitemHistory ){
        newtype = TAB_TYPE_HISTORY;
    }
    else if( item == _tbitemFavorites ){
        newtype = TAB_TYPE_FAVORITES;
    }
// Whan More will be added
//    else if( item == _tbitemMore ){
//        newtype = LIST_TYPE_FAVORITES;
//    }
    
    [self changeTab:newtype];
}

#pragma mark -
#pragma mark UITextField delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return FALSE;
}

-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}

@end
