//
//  GameListingCell.m
//  GameTrader
//
//  Created by Joshua Palermo on 1/15/14.
//  Copyright (c) 2014 Joshua Palermo. All rights reserved.
//

#import "GameListingCell.h"

@implementation GameListingCell

@synthesize addressLabel = _addressLabel;
@synthesize percentLabel = _percentLabel;
@synthesize sellsLabel = _sellsLabel;
@synthesize coinCostLabel = _coinCostLabel;
@synthesize conditionLabel = _conditionLabel;
@synthesize sellerImage = _sellerImage;
@synthesize nameLabel = _nameLabel;
@synthesize buysLabel = _buysLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
