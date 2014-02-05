//
//  MyGamesViewController.m
//  GameTrader
//
//  Created by Joshua Palermo on 11/23/13.
//  Copyright (c) 2013 Joshua Palermo. All rights reserved.
//

#import "MyGamesViewController.h"
#import "GameDetailViewController.h"
#import "TFHpple.h"
#import "Game.h"

@interface MyGamesViewController ()

@property (nonatomic, strong) TFHpple *htmlParser;
@property (nonatomic, strong) NSString *myGamesXpathQueryString;
@property (nonatomic, strong) NSArray *myGamesNodes;
@property (nonatomic, strong) NSString *myGameImagesXpathQueryString;
@property (nonatomic, strong) NSArray *myGameImagesNodes;
@property (nonatomic, strong) NSMutableArray *myGames;
@property (nonatomic, strong) NSString *myCoinsXpathQueryString;
@property (nonatomic, strong) NSArray *myCoinsNodes;
@property (nonatomic, assign) NSInteger myCoins;
@property (nonatomic, strong) NSString *myGameActionsXpathQueryString;
@property (nonatomic, strong) NSArray *myGameActionsNodes;
@property (nonatomic, strong) NSArray *myGameActions;

@end

@implementation MyGamesViewController

@synthesize activityIndicator = _activityIndicator;
@synthesize webData = _webData;
@synthesize username = _username;
@synthesize myGamesXpathQueryString = _myGamesXpathQueryString;
@synthesize myGamesNodes = _myGamesNodes;
@synthesize myGameImagesXpathQueryString = _myGameImagesXpathQueryString;
@synthesize myGameImagesNodes = _myGameImagesNodes;
@synthesize myGames = _myGames;
@synthesize htmlParser = _htmlParser;
@synthesize myCoinsXpathQueryString = _myCoinsXpathQueryString;
@synthesize myCoinsNodes = _myCoinsNodes;
@synthesize myCoins = _myCoins;
@synthesize myGameActionsXpathQueryString = _myGameActionsXpathQueryString;
@synthesize myGameActionsNodes = _myGameActionsNodes;
@synthesize myGameActions = _myGameActions;
@synthesize gameDetailViewController = _gameDetailViewController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushGameDetailViewController:) name:@"GameDetailViewControllerSetupDone" object:nil];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
   // NSMutableString *searchUrl = [[NSMutableString alloc] initWithString:[catalogTitles searchUrl]];
   // [searchUrl appendString:@"&start_index="];
    
    NSURL *url = [NSURL URLWithString:@"http://99gamers.com/foo/games"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    [theRequest setHTTPMethod:@"GET"];
    
    
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if( theConnection ) {
        [self setWebData: [[NSMutableData alloc] init]];
    }
    else {
        NSLog(@"Internet problem maybe...");
    }
    
    [[self activityIndicator] setHidden: NO];
    [[self activityIndicator] startAnimating];
    
}

-(void)loadView
{
    [super loadView];
    [self setActivityIndicator: [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]];
    [[self view]addSubview: [self activityIndicator]];
    [[self activityIndicator] setCenter: [[self view] center]];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if([self myGames]) {
        return [[self myGames]count];
    }
    else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    [[cell textLabel] setText: [[[self myGames] objectAtIndex:[indexPath row]] title]];

    return cell;
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [[self webData] setLength: 0];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [[self webData] appendData:data];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // show error
    [[self activityIndicator] setHidden: YES];
    [[self activityIndicator] stopAnimating];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *loginStatus = [[NSString alloc] initWithBytes: [[self webData] mutableBytes] length:[[self webData] length] encoding:NSUTF8StringEncoding];
    NSLog(@"after comparing data is %@", loginStatus);

    [self setHtmlParser: [TFHpple hppleWithHTMLData:[self webData]]];
    [self setMyGamesXpathQueryString: @"//table[@class='catalog_games profile_games']/tr/td/a"];
    [self setMyGamesNodes: [[self htmlParser] searchWithXPathQuery: [self myGamesXpathQueryString]]];
    [self setMyGameImagesXpathQueryString: @"//table[@class='catalog_games profile_games']/tr/td/div/a/img"];
    [self setMyGameImagesNodes: [[self htmlParser] searchWithXPathQuery: [self myGameImagesXpathQueryString]]];
    [self setMyCoinsXpathQueryString: @"//div[@class='header_new_button header_balance ']"];
    [self setMyCoinsNodes: [[self htmlParser] searchWithXPathQuery: [self myCoinsXpathQueryString]]];
    [self setMyGameActionsXpathQueryString: @"//div[@class='game_action']"];
    [self setMyGameActionsNodes: [[self htmlParser] searchWithXPathQuery: [self myGameActionsXpathQueryString]]];
    
    [self setMyGames: [[NSMutableArray alloc] initWithCapacity:0]];
    int i, j;
    for (i = 0; i < [[self myGamesNodes] count]; i++) {
        TFHppleElement *gameElement = [[self myGamesNodes] objectAtIndex:i];
        TFHppleElement *gameImageElement = [[self myGameImagesNodes] objectAtIndex:i];
        TFHppleElement *gameActionElement = [[self myGameActionsNodes] objectAtIndex:i];
 
        NSLog(@"game element is %@", gameElement);
        NSLog(@"game image element is %@", gameImageElement);
        NSLog(@"game action element is %@", gameActionElement);
        
        [self setMyGameActions:[gameActionElement childrenWithTagName:@"a"]];
        Game *game  = [[Game alloc] init];
        [game setTitle: [[gameElement firstChild] content]];
        [game setGameUrl: [NSURL URLWithString:[gameElement objectForKey:@"href"]]];
        [game setBoxArtUrl: [NSURL URLWithString:[gameImageElement objectForKey:@"data-cfsrc"]]];
     
        for (j = 0; j < [[self myGameActions] count]; j++) {
            TFHppleElement *myGameActionsElement = [[self myGameActions] objectAtIndex:j];
            NSLog(@"game actions element is %@", myGameActionsElement);
            NSString *gameAction = [[[myGameActionsElement children] objectAtIndex: 0] content];
            if([gameAction isEqualToString:@"Relist Game"]) {
                [game setCanRelist: YES];
            }
            else if([gameAction isEqualToString:@"Remove Game"]) {
                [game setCanRemove: YES];
            }
            else if([gameAction isEqualToString:@"Unlist"]) {
                [game setCanUnlist: YES];
            }
            else if([gameAction isEqualToString:@"Edit"]) {
                [game setCanEdit: YES];
            }
        }
        
        [[self myGames] addObject: game];
    }
    
    for (i = 0; i < [[self myCoinsNodes] count]; i++) {
        TFHppleElement *coinElement = [[self myCoinsNodes] objectAtIndex:i];
        NSLog(@"coin element is %@", coinElement);
        [self setMyCoins:[[[[coinElement children] objectAtIndex: 2] content] integerValue]];
    }

    
    [[self tableView] reloadData];
    [[self activityIndicator] setHidden: YES];
    [[self activityIndicator] stopAnimating];
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    [headerView setBackgroundColor:[UIColor grayColor]];
    
    int kSectionTitleLeftMargin = 500, kSectionTitleTopMargin = 50, kSectionTitleRightMargin = 100, kSectionTitleBottomMargin = 60;
    // Add the label
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSectionTitleLeftMargin,
                                                                     kSectionTitleTopMargin,
                                                                     tableView.bounds.size.width - kSectionTitleLeftMargin - kSectionTitleRightMargin,
                                                                     30.0 - kSectionTitleTopMargin - kSectionTitleBottomMargin)];
    
    // do whatever headerLabel configuration you want here
    NSString* coinString = [NSString stringWithFormat:@"%i", [self myCoins]];

    NSMutableString *headerText = [[NSMutableString alloc] initWithString:@"Coins: "];
    [headerText appendString: coinString];
    [headerLabel setText: headerText];
    [headerView addSubview:headerLabel];
    
    // Return the headerView
    return headerView;
}

-(void) pushGameDetailViewController:(NSNotification *)notify
{
    // Pass the selected object to the new view controller.
    // Push the view controller.
    [[self activityIndicator] setHidden: YES];
    [[self activityIndicator] stopAnimating];

    if([[self gameDetailViewController] navigationController] == nil && [self gameDetailViewController] == [notify object]) {
        [[self navigationController] pushViewController:[self gameDetailViewController] animated:YES];
    }
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    // Pass the selected object to the new view controller.
    // Push the view controller.
    GameDetailViewController *gameDetailViewController = [[GameDetailViewController alloc] init];
    [self setGameDetailViewController: gameDetailViewController];
    
    [gameDetailViewController setGame: [[self myGames] objectAtIndex:[indexPath row]]];
    [gameDetailViewController setupViewController];
    
    [[self activityIndicator] setHidden: NO];
    [[self activityIndicator] startAnimating];
}

@end
