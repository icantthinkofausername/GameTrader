//
//  GameDetailViewController.m
//  GameTrader
//
//  Created by Joshua Palermo on 12/2/13.
//  Copyright (c) 2013 Joshua Palermo. All rights reserved.
//

#import "GameDetailViewController.h"
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

    [self setCoinCostNodes: [[self htmlParser] searchWithXPathQuery: [self coinCostXpathQueryString]]];
    [self setConditionNodes:[[self htmlParser] searchWithXPathQuery: [self conditionXpathQueryString]]];
    [self setSellerImageNodes : [[self htmlParser] searchWithXPathQuery: [self sellerImageXpathQueryString]]];
    [self setSellerNameNodes: [[self htmlParser] searchWithXPathQuery: [self sellerNameXpathQueryString]]];
    [self setPercentNodes: [[self htmlParser] searchWithXPathQuery: [self percentXpathQueryString]]];
    [self setAddressNodes: [[self htmlParser] searchWithXPathQuery: [self addressXpathQueryString]]];
    [self setStatNodes: [[self htmlParser] searchWithXPathQuery: [self statXpathQueryString]]];
    
    [self setCoinCosts: [[NSMutableArray alloc] initWithCapacity:0]];
    [self setConditions: [[NSMutableArray alloc] initWithCapacity:0]];
    [self setSellerImages: [[NSMutableArray alloc] initWithCapacity:0]];
    [self setSellerNames: [[NSMutableArray alloc] initWithCapacity:0]];
    [self setPercents: [[NSMutableArray alloc] initWithCapacity:0]];
    [self setAddresses: [[NSMutableArray alloc] initWithCapacity:0]];
    [self setStats: [[NSMutableArray alloc] initWithCapacity:0]];
    
    int i;
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
        [gameListing setAddress: [[[addressNodeElement children] objectAtIndex: 1] content]];
        
        if([[self percentNodes] count] >= i + 1) {
            TFHppleElement *percentNodeElement = [[self percentNodes] objectAtIndex:i];
            [gameListing setPercent: [[[percentNodeElement children] objectAtIndex: 0] content]];
            
            [gameListing setBuys: [[[[[[[statNodeElement children] objectAtIndex: 3] children] objectAtIndex: 0] children] objectAtIndex: 0] content]];
            [gameListing setSells: [[[[[[[statNodeElement children] objectAtIndex: 5] children] objectAtIndex: 0] children] objectAtIndex: 0] content]];
        }
        else {
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
    
    
    [[[self searchDisplayController]searchResultsTableView] reloadData];
    [[self activityIndicator] setHidden: YES];
    [[self activityIndicator] stopAnimating];
}

@end
