//
//  GameListing.h
//  GameTrader
//
//  Created by Joshua Palermo on 1/15/14.
//  Copyright (c) 2014 Joshua Palermo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameListing : NSObject

@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *percent;
@property (nonatomic, strong) NSString *sells;
@property (nonatomic, strong) NSString *buys;
@property (nonatomic, assign) NSInteger coinCost;
@property (nonatomic, strong) NSString *condition;
@property (nonatomic, strong) UIImage *sellerImage;
@property (nonatomic, strong) NSString *sellerName;


@end
