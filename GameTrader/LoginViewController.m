//
//  LoginViewController.m
//  GameTrader
//
//  Created by Joshua Palermo on 11/7/13.
//  Copyright (c) 2013 Joshua Palermo. All rights reserved.
//

#import "LoginViewController.h"
#import "MyGamesViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize activityIndicator = _activityIndicator;
@synthesize txtEmailAddress = _txtEmailAddress;
@synthesize txtPassword = _txtPassword;
@synthesize txtUsername = _txtUsername;

@synthesize myGamesViewController = _myGamesViewController;
@synthesize webData = _webData;

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
    [[self activityIndicator] setHidden: YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *) textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)resignTxtEmailAddressFirstResponder
{
    [[self txtEmailAddress] resignFirstResponder];
    [[self txtPassword] resignFirstResponder];
    [[self txtUsername] resignFirstResponder];
}

- (IBAction)handleLoginButtonClick:(id)sender
{
    NSString *post = [[NSString alloc] initWithFormat:@"email=fooo&password=bar",[[self txtEmailAddress] text],[[self txtPassword] text]];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSURL *url = [NSURL URLWithString:@"http://99gamers.com/login"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPBody:postData];
    
    
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if( theConnection ) {
        [[self activityIndicator] setHidden: NO];
        [[self activityIndicator] startAnimating];
        [self setWebData: [[NSMutableData alloc] init]];
    }
    else {
        NSLog(@"Internet problem maybe...");
    }
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
    if ([loginStatus isEqualToString:@"\"ok\""]) {
        // right login
        if([self myGamesViewController] == nil) {
            [self setMyGamesViewController: [[MyGamesViewController alloc] init]];
            [[self myGamesViewController] awakeFromNib];
        }
        [[[self tabBarController] tabBar] setHidden: NO];
        [[self navigationController] pushViewController:[self myGamesViewController] animated:YES];

    } else {
        // wrong login

    }
    [[self activityIndicator] setHidden: YES];
    
}

@end
