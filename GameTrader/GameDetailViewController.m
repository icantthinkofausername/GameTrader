//
//  GameDetailViewController.m
//  GameTrader
//
//  Created by Joshua Palermo on 12/2/13.
//  Copyright (c) 2013 Joshua Palermo. All rights reserved.
//

#import "GameDetailViewController.h"
#import "GameListingCell.h"
#import "TFHpple.h"

@interface GameDetailViewController ()

@property (nonatomic, strong) TFHpple *htmlParser;
@property (nonatomic, strong) NSString *addressXpathQueryString;
@property (nonatomic, strong) NSArray *addressNodes;
@property (nonatomic, strong) NSMutableArray *addresses;
@property (nonatomic, strong) NSString *percentXpathQueryString;
@property (nonatomic, strong) NSArray *percentNodes;
@property (nonatomic, strong) NSMutableArray *percents;
@property (nonatomic, strong) NSString *statXpathQueryString;
@property (nonatomic, strong) NSArray *statNodes;
@property (nonatomic, strong) NSMutableArray *stats;
@property (nonatomic, strong) NSString *coinCostXpathQueryString;
@property (nonatomic, strong) NSArray *coinCostNodes;
@property (nonatomic, strong) NSMutableArray *coinCosts;
@property (nonatomic, strong) NSString *conditionXpathQueryString;
@property (nonatomic, strong) NSArray *conditionNodes;
@property (nonatomic, strong) NSMutableArray *conditions;
@property (nonatomic, strong) NSString *sellerImageXpathQueryString;
@property (nonatomic, strong) NSArray *sellerImageNodes;
@property (nonatomic, strong) NSMutableArray *sellerImages;
@property (nonatomic, strong) NSString *sellerNameXpathQueryString;
@property (nonatomic, strong) NSArray *sellerNameNodes;
@property (nonatomic, strong) NSMutableArray *sellerNames;
@property (nonatomic, strong) NSMutableArray *gameListings;
@property (nonatomic, strong) NSString *gameDescriptionXpathQueryString;
@property (nonatomic, strong) NSArray *gameDescriptionNodes;
@property (nonatomic, strong) NSString *gameDateXpathQueryString;
@property (nonatomic, strong) NSArray *gameDateNodes;

@end

@implementation GameDetailViewController

@synthesize game = _game;
@synthesize gameListing = _gameListing;
@synthesize gameListings = _gameListings;
@synthesize htmlParser = _htmlParser;
@synthesize activityIndicator = _activityIndicator;
@synthesize webData = _webData;
@synthesize addressXpathQueryString = _addressXpathQueryString;
@synthesize addressNodes = _addressNodes;
@synthesize addresses = _addresses;
@synthesize percentXpathQueryString = _percentXpathQueryString;
@synthesize percentNodes = _percentNodes;
@synthesize percents = _percents;
@synthesize statXpathQueryString = _statXpathQueryString;
@synthesize statNodes = _statNodes;
@synthesize stats = _stats;
@synthesize coinCostXpathQueryString = _coinCostXpathQueryString;
@synthesize coinCostNodes = _coinCostNodes;
@synthesize coinCosts = _coinCosts;
@synthesize conditionXpathQueryString = _conditionXpathQueryString;
@synthesize conditionNodes = _conditionNodes;
@synthesize conditions = _conditions;
@synthesize sellerImageXpathQueryString = _sellerImageXpathQueryString;
@synthesize sellerNameNodes = _sellerNameNodes;
@synthesize sellerNames = _sellerNames;
@synthesize gameDescriptionXpathQueryString = _gameDescriptionXpathQueryString;
@synthesize gameDescriptionNodes = _gameDescriptionNodes;
@synthesize gameListingTableView = _gameListingViewTable;
@synthesize gameImageView = _gameImageView;
@synthesize gameDescriptionTextView = _gameDescriptionTextView;
@synthesize gameTitleLabel = _gameTitleLabel;
@synthesize gamePlatformLabel = _gamePlatformLabel;
@synthesize gameDateLabel = _gameDateLabel;


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
    
    UIImage *gameImage = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[[self game] boxArtUrl]]];
    [[self gameImageView] setImage: gameImage];
    [[self gameTitleLabel] setText: [[self game] title]];
    [[self gamePlatformLabel] setText: [[self game] platform]];
    [[self gameDescriptionTextView] setText: [[self game] description]];
    [[self gameDateLabel] setText: [[self game] date]];
}

- (void)setupViewController
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    NSMutableString *urlString = [[NSMutableString alloc] initWithString: @"http://99gamers.com"];
    [urlString appendString: [[[self game] gameUrl] absoluteString]];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [self setCoinCostXpathQueryString: @"//div[@class='game_price']"];
    [self setConditionXpathQueryString: @"//td[@class='cell_2']/b"];
    [self setSellerImageXpathQueryString: @"//span[@class='user_icon']"];
    [self setSellerNameXpathQueryString: @"//a[@class='user_link']"];
    [self setPercentXpathQueryString: @"//span[@class='proc']/b"];
    [self setAddressXpathQueryString: @"//span[@class='user_from']"];
    [self setStatXpathQueryString: @"//div[@class='user_stat']"];
    [self setGameDescriptionXpathQueryString:@"//p[@class='game_full_text']"];
    [self setGameDateXpathQueryString:@"//div[@class='game_year pull-right']"];


    [self setCoinCostNodes: [[self htmlParser] searchWithXPathQuery: [self coinCostXpathQueryString]]];
    [self setConditionNodes:[[self htmlParser] searchWithXPathQuery: [self conditionXpathQueryString]]];
    [self setSellerImageNodes : [[self htmlParser] searchWithXPathQuery: [self sellerImageXpathQueryString]]];
    [self setSellerNameNodes: [[self htmlParser] searchWithXPathQuery: [self sellerNameXpathQueryString]]];
    [self setPercentNodes: [[self htmlParser] searchWithXPathQuery: [self percentXpathQueryString]]];
    [self setAddressNodes: [[self htmlParser] searchWithXPathQuery: [self addressXpathQueryString]]];
    [self setStatNodes: [[self htmlParser] searchWithXPathQuery: [self statXpathQueryString]]];
    [self setGameDescriptionNodes: [[self htmlParser] searchWithXPathQuery: [self gameDescriptionXpathQueryString]]];
    [self setGameDateNodes: [[self htmlParser] searchWithXPathQuery: [self gameDateXpathQueryString]]];

    
    [self setCoinCosts: [[NSMutableArray alloc] initWithCapacity:0]];
    [self setConditions: [[NSMutableArray alloc] initWithCapacity:0]];
    [self setSellerImages: [[NSMutableArray alloc] initWithCapacity:0]];
    [self setSellerNames: [[NSMutableArray alloc] initWithCapacity:0]];
    [self setPercents: [[NSMutableArray alloc] initWithCapacity:0]];
    [self setAddresses: [[NSMutableArray alloc] initWithCapacity:0]];
    [self setStats: [[NSMutableArray alloc] initWithCapacity:0]];
    [self setGameListings: [[NSMutableArray alloc] initWithCapacity:0]];
    
    int i = 0, percentCount = 0;
    for (i = 0; i < [[self sellerNameNodes] count]; i++) {
        TFHppleElement *coinCostNodeElement = [[self coinCostNodes] objectAtIndex:i];
        TFHppleElement *conditionsNodeElement = [[self conditionNodes] objectAtIndex:i];
        TFHppleElement *sellerImagesNodeElement = [[self sellerImageNodes] objectAtIndex:i];
        TFHppleElement *sellerNamesNodeElement = [[self sellerNameNodes] objectAtIndex:i];
        TFHppleElement *addressNodeElement = [[self addressNodes] objectAtIndex:i];
        TFHppleElement *statNodeElement = [[self statNodes] objectAtIndex:i];
        
        NSLog(@"seller element is %@", sellerNamesNodeElement);
        GameListing *gameListing = [[GameListing alloc] init];
        [gameListing setSellerName: [[[sellerNamesNodeElement children] objectAtIndex: 0] content]];
        [gameListing setCoinCost: [[[[coinCostNodeElement children] objectAtIndex: 1] content] intValue]];
        [gameListing setCondition: [[[conditionsNodeElement children] objectAtIndex: 0] content]];
        [gameListing setSellerAddress: [[[addressNodeElement children] objectAtIndex: 1] content]];
        
        if([[statNodeElement description] rangeOfString: @"%"].location != NSNotFound) {
            TFHppleElement *percentNodeElement = [[self percentNodes] objectAtIndex:percentCount++];
            [gameListing setPercent: [[[percentNodeElement children] objectAtIndex: 0] content]];
            
            [gameListing setBuys: [[[[[[[statNodeElement children] objectAtIndex: 3] children] objectAtIndex: 0] children] objectAtIndex: 0] content]];
            [gameListing setSells: [[[[[[[statNodeElement children] objectAtIndex: 5] children] objectAtIndex: 0] children] objectAtIndex: 0] content]];
        }
        else {
            [gameListing setPercent: @"0"];
            [gameListing setBuys: [[[[[[[statNodeElement children] objectAtIndex: 1] children] objectAtIndex: 0] children] objectAtIndex: 0] content]];
            [gameListing setSells: [[[[[[[statNodeElement children] objectAtIndex: 3] children] objectAtIndex: 0] children] objectAtIndex: 0] content]];
        }
        
        NSString *unparsedImageURL = [sellerImagesNodeElement objectForKey:@"style"];
        NSRange r1 = [unparsedImageURL rangeOfString:@"url("];
        NSRange r2 = [unparsedImageURL rangeOfString:@");"];
        NSRange rSub = NSMakeRange(r1.location + r1.length, r2.location - r1.location - r1.length);
        NSString *imageURL = [unparsedImageURL substringWithRange:rSub];
        UIImage *sellerImage = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
        [gameListing setSellerImage: sellerImage];
        [[self gameListings] addObject: gameListing];
    }
    
    if ([[self gameDescriptionNodes] count] > 0) {
        [[self game] setDescription: [[[[[self gameDescriptionNodes] objectAtIndex:0] children] objectAtIndex: 0] content]];
    }
    
    if ([[self gameDateNodes] count] > 0) {
        [[self game] setDate: [[[[[self gameDateNodes] objectAtIndex:0] children] objectAtIndex: 0] content]];
    }
    
    [[self gameListingTableView] reloadData];
    [[self activityIndicator] setHidden: YES];
    [[self activityIndicator] stopAnimating];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GameDetailViewControllerSetupDone" object:self];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self gameListings] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"GameListingCell";
    
    // Dequeue or create a cell of the appropriate type.
    GameListingCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
       // cell = [[GameListingCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
       // [cell setAccessoryType: UITableViewCellAccessoryNone];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    // Configure the cell.
    GameListing *gameListing = [[self gameListings] objectAtIndex: [indexPath row]];
    [[cell addressLabel] setText: [gameListing sellerAddress]];
    [[cell nameLabel] setText: [gameListing sellerName]];
    [[cell percentLabel] setText: [gameListing percent]];
    [[cell sellsLabel] setText: [gameListing sells]];
    [[cell buysLabel] setText: [gameListing buys]];
    [[cell coinCostLabel] setText: [NSString stringWithFormat:@"%d",[gameListing coinCost]]];
    [[cell conditionLabel] setText: [gameListing condition]];
    [[cell imageView] setImage: [gameListing sellerImage]];
    
    return cell;
}


@end
