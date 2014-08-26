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
#import "UIFont+FreshlyAdditions.h"

#define kSpaceLabelWidth 10.0
#define kSpaceLabelHeight 10.0

@interface FreshlyStorageTableViewCell ()

@property (nonatomic, readwrite, strong) UILabel *spaceLabel;

@end

@implementation FreshlyStorageTableViewCell

- (instancetype)initWithItem:(FreshlyFoodItem *)item
{
	if (self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:TABLE_VIEW_CELL_STORAGE_IDENTIFIER]) {
		
		self.backgroundColor = FRESHLY_COLOR_LIGHT;
		
		self.textLabel.textColor = (item.dateOfExpiration.timeIntervalSinceNow >= 0.0) ? FRESHLY_COLOR_DARK : FRESHLY_COLOR_RED;
		self.textLabel.font = [UIFont freshlyFontOfSize:24.0];
		
		self.detailTextLabel.textColor = FRESHLY_COLOR_DARK;
		self.detailTextLabel.font = [UIFont freshlyFontOfSize:12.0];
		
		self.spaceLabel = [[UILabel alloc] init];
		self.spaceLabel.font = [UIFont boldSystemFontOfSize:10.0];
		self.spaceLabel.textColor = FRESHLY_COLOR_DARK;
		[self addSubview:self.spaceLabel];
		[self setItem:item];
	}
	return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];

	CGFloat spaceLabelXOrigin = self.imageView.frame.origin.x + self.imageView.frame.size.width;
	CGFloat spaceLabelYOrigin = self.imageView.frame.origin.y + self.imageView.frame.size.height - kSpaceLabelHeight/2;

	self.spaceLabel.frame = CGRectMake(spaceLabelXOrigin, spaceLabelYOrigin, kSpaceLabelWidth, kSpaceLabelHeight);
}

- (void)setItem:(FreshlyFoodItem *)item
{
	self.textLabel.text = item.name;
	self.detailTextLabel.text = [NSString stringWithFormat:@"Purchased %@", item.dateOfPurchase.approximateDescription];
	self.imageView.image = [UIImage imageForCategory:item.category withSize:50];
	self.spaceLabel.text = @[@"R", @"F", @"P"][item.space.integerValue];
}

@end
