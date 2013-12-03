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

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
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
    [self setMyGameImagesXpathQueryString: @"//table[@class='catalog_games profile_games']/tr/td/div/a"];
    [self setMyGameImagesNodes: [[self htmlParser] searchWithXPathQuery: [self myGameImagesXpathQueryString]]];
    
    [self setMyGames: [[NSMutableArray alloc] initWithCapacity:0]];
    int i;
    for (i = 0; i < [[self myGamesNodes] count]; i++) {
        TFHppleElement *gameElement = [[self myGamesNodes] objectAtIndex:i];
        TFHppleElement *gameImageElement = [[self myGameImagesNodes] objectAtIndex:i];
        NSLog(@"game element is %@", gameElement);
        NSLog(@"game element is %@", gameImageElement);
        
        Game *game  = [[Game alloc] init];
        [game setTitle: [[gameElement firstChild] content]];
        [game setBoxArtUrl: [NSURL URLWithString:[gameImageElement objectForKey:@"href"]]];

        [[self myGames] addObject: game];
    }
    
    [[self tableView] reloadData];
    [[self activityIndicator] setHidden: YES];
    [[self activityIndicator] stopAnimating];
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
    GameDetailViewController *gameDetailViewController = [[GameDetailViewController alloc] initWithNibName:@"<#Nib name#>" bundle:nil];

    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:gameDetailViewController animated:YES];
}

@end
