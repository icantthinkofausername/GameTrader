//
//  GameListingCell.h
//  GameTrader
//
//  Created by Joshua Palermo on 1/15/14.
//  Copyright (c) 2014 Joshua Palermo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameListingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *percentLabel;
@property (weak, nonatomic) IBOutlet UILabel *sellsLabel;
@property (weak, nonatomic) IBOutlet UILabel *coinCostLabel;
@property (weak, nonatomic) IBOutlet UILabel *conditionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sellerImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *buysLabel;
@end
