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

@interface GameDetailViewController : UIViewController <NSURLConnectionDelegate>

@property (nonatomic, strong) NSMutableData *webData;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) Game *game;
@property (nonatomic, strong) GameListing *gameListing;

@end
