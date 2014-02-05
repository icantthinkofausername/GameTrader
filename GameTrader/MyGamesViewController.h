//
//  MyGamesViewController.h
//  GameTrader
//
//  Created by Joshua Palermo on 11/23/13.
//  Copyright (c) 2013 Joshua Palermo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameDetailViewController.h"

@interface MyGamesViewController : UITableViewController <NSURLConnectionDelegate>

@property (nonatomic, strong) NSMutableData *webData;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) GameDetailViewController *gameDetailViewController;


@end
