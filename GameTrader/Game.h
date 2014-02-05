//
//  Game.h
//  GameTrader
//
//  Created by Joshua Palermo on 12/1/13.
//  Copyright (c) 2013 Joshua Palermo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Game : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSURL *gameUrl;
@property (nonatomic, strong) NSURL *boxArtUrl;
@property (nonatomic, assign) BOOL canRelist;
@property (nonatomic, assign) BOOL canRemove;
@property (nonatomic, assign) BOOL canUnlist;
@property (nonatomic, assign) BOOL canEdit;
@property (nonatomic, strong) NSString *platform;

@end
