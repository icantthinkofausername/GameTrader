//
//  LoginViewController.h
//  GameTrader
//
//  Created by Joshua Palermo on 11/7/13.
//  Copyright (c) 2013 Joshua Palermo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyGamesViewController.h"

@interface LoginViewController : UIViewController <NSURLConnectionDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtEmailAddress;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic, strong) MyGamesViewController *myGamesViewController;
@property (nonatomic, strong) NSMutableData *webData;

- (IBAction)resignTxtEmailAddressFirstResponder;

@end
