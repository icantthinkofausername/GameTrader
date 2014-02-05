//
//  GameDetailViewController.h
//  GameTrader
//
//  Created by Joshua Palermo on 12/2/13.
//  Copyright (c) 2013 Joshua Palermo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"
#import "GameListing.h"

@interface GameDetailViewController : UIViewController <NSURLConnectionDelegate,UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableData *webData;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) Game *game;
@property (nonatomic, strong) GameListing *gameListing;
@property (weak, nonatomic) IBOutlet UITableView *gameListingTableView;
@property (weak, nonatomic) IBOutlet UIImageView *gameImageView;
@property (weak, nonatomic) IBOutlet UILabel *gameTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *gamePlatformLabel;
@property (weak, nonatomic) IBOutlet UITextView *gameDescriptionTextView;

- (void)setupViewController;

@end
