//
//  GameSearchViewController.m
//  GameTrader
//
//  Created by Joshua Palermo on 12/30/13.
//  Copyright (c) 2013 Joshua Palermo. All rights reserved.
//

#import "GameSearchViewController.h"
#import "Game.h"
#import "TFHpple.h"
#import "GameDetailViewController.h"

@interface GameSearchViewController ()

@property (nonatomic, strong) TFHpple *htmlParser;
@property (nonatomic, strong) NSString *searchedGameXpathQueryString;
@property (nonatomic, strong) NSArray *searchedGameNodes;
@property (nonatomic, strong) NSMutableArray *searchedGames;

@end

@implementation GameSearchViewController

@synthesize htmlParser = _htmlParser;
@synthesize activityIndicator = _activityIndicator;
@synthesize webData = _webData;
@synthesize searchedGameXpathQueryString = _searchedGameXpathQueryString;
@synthesize searchedGameNodes = _searchedGameNodes;
@synthesize searchedGames = _searchedGames;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) { // if iOS 7
        self.edgesForExtendedLayout = UIRectEdgeNone; //layout adjustements
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self searchedGames] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"CellIdentifier";
    
    // Dequeue or create a cell of the appropriate type.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        [cell setAccessoryType: UITableViewCellAccessoryNone];
    }
        
    // Configure the cell.
    NSMutableString *cellText = [[NSMutableString alloc] initWithString: [[[self searchedGames] objectAtIndex: [indexPath row]] title]];
    NSMutableString *detailCellText = [[NSMutableString alloc] initWithString: [[[self searchedGames] objectAtIndex: [indexPath row]] platform]];
    [[cell textLabel] setText: cellText];
    [[cell detailTextLabel] setText: detailCellText];
    return cell;
}

- (void)search:(NSString *)withSearchString
{
   // [_data removeAllObjects];
    NSString *encodedSearchString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                    NULL,
                                                                                                    (__bridge CFStringRef) withSearchString,
                                                                                                    NULL,
                                                                                                    CFSTR("!*'();:@&=+$,/?%#[]\" "),
                                                                                                    kCFStringEncodingUTF8));
    NSMutableString *urlString = [[NSMutableString alloc] initWithString: @"http://99gamers.com/search/games/?q="];
    [urlString appendString: encodedSearchString];
    NSURL *url = [NSURL URLWithString:urlString];
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

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    return NO;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"search text is %@",[searchBar text]);
    [self search:[searchBar text]];
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
    [self setSearchedGameXpathQueryString: @"//div[@class='prof_game_title']/.."];
    [self setSearchedGameNodes: [[self htmlParser] searchWithXPathQuery: [self searchedGameXpathQueryString]]];
    
    [self setSearchedGames: [[NSMutableArray alloc] initWithCapacity:0]];
    int i;
    for (i = 0; i < [[self searchedGameNodes] count]; i++) {
        TFHppleElement *searchedGameNodeElement = [[self searchedGameNodes] objectAtIndex:i];
        
        NSLog(@"game element is %@", searchedGameNodeElement);
        Game *game = [[Game alloc] init];
        [game setGameUrl: [NSURL URLWithString:[[[searchedGameNodeElement children] objectAtIndex: 3] objectForKey: @"href"]]];
        [game setTitle: [[[[[[[searchedGameNodeElement children] objectAtIndex: 5] children] objectAtIndex: 1] children] objectAtIndex: 0] content]];
        [game setPlatform: [[[[[[[[[searchedGameNodeElement children] objectAtIndex: 5] children] objectAtIndex: 3] children] objectAtIndex: 1] children] objectAtIndex: 0] content]];
        [[self searchedGames] addObject: game];
    }
    
    
    [[[self searchDisplayController]searchResultsTableView] reloadData];
    [[self activityIndicator] setHidden: YES];
    [[self activityIndicator] stopAnimating];
}

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    GameDetailViewController *gameDetailViewController = [[GameDetailViewController alloc] init];
    [gameDetailViewController setGame: [[self searchedGames] objectAtIndex:[indexPath row]]];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:gameDetailViewController animated:YES];
}

/*- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}*/


@end