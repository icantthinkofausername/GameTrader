//
//  MyGamesViewController.h
//  GameTrader
//
//  Created by Joshua Palermo on 11/23/13.
//  Copyright (c) 2013 Joshua Palermo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyGamesViewController : UITableViewController <NSURLConnectionDelegate>

@property (nonatomic, strong) NSMutableData *webData;
@property (nonatomic, strong) NSString *username;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


@end
