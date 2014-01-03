//
//  Game.h
//  GameTrader
//
//  Created by Joshua Palermo on 12/1/13.
//  Copyright (c) 2013 Joshua Palermo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Game : NSObject

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSURL *gameUrl;
@property (nonatomic, retain) NSURL *boxArtUrl;
@property (nonatomic, assign) BOOL canRelist;
@property (nonatomic, assign) BOOL canRemove;
@property (nonatomic, assign) BOOL canUnlist;
@property (nonatomic, assign) BOOL canEdit;

@end
