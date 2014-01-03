//
//  GameSearchViewController.h
//  GameTrader
//
//  Created by Joshua Palermo on 12/30/13.
//  Copyright (c) 2013 Joshua Palermo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameSearchViewController : UIViewController <UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate,NSURLConnectionDelegate>

@property (nonatomic, strong) NSMutableData *webData;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end
