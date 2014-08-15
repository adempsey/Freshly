//
//  FreshlyStorageTableViewCell.m
//  Freshly
//
//  Created by Andrew Dempsey on 7/29/14.
//  Copyright (c) 2014 Andrew Dempsey. All rights reserved.
//

#import "FreshlyStorageTableViewCell.h"

#import "NSDate+FreshlyAdditions.h"
#import "UIImage+FreshlyAdditions.h"

@implementation FreshlyStorageTableViewCell

- (instancetype)initWithItem:(FreshlyFoodItem *)item
{
	if (self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:TABLE_VIEW_CELL_STORAGE_IDENTIFIER]) {
		[self setItem:item];
	}
	return self;
}

- (void)setItem:(FreshlyFoodItem *)item
{
	self.textLabel.text = item.name;
	self.detailTextLabel.text = [NSString stringWithFormat:@"Purchased %@", item.dateOfPurchase.approximateDescription];
	self.imageView.image = [UIImage imageForCategory:item.category withSize:50];
}

@end
