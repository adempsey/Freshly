//
//  FreshlyStorageTableViewCell.m
//  Freshly
//
//  Created by Andrew Dempsey on 7/29/14.
//  Copyright (c) 2014 Andrew Dempsey. All rights reserved.
//

#import "FRSStorageTableViewCell.h"
#import "FRSSettingsService.h"

#import "NSDate+FreshlyAdditions.h"
#import "UIImage+FreshlyAdditions.h"
#import "UIFont+FreshlyAdditions.h"

#define kSpaceLabelWidth 10.0
#define kSpaceLabelHeight 10.0

@interface FRSStorageTableViewCell ()

@property (nonatomic, readwrite, strong) UILabel *spaceLabel;

@end

@implementation FRSStorageTableViewCell

- (instancetype)initWithItem:(FRSFoodItem *)item
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

- (void)setItem:(FRSFoodItem *)item
{
	self.textLabel.text = item.name;
	self.textLabel.textColor = (item.dateOfExpiration.timeIntervalSinceNow >= 0.0) ? FRESHLY_COLOR_DARK : FRESHLY_COLOR_RED;

	NSString *dateText = @"";

	NSString *purchaseText = [NSString stringWithFormat:@"Purchased %@", item.dateOfPurchase.approximateDescription];

	NSString *expirationTextSuffix = ([item.dateOfExpiration timeIntervalSinceNow] >= 0) ? @"s" : @"d";
	NSString *expirationText = [NSString stringWithFormat:@"Expire%@ %@", expirationTextSuffix, item.dateOfExpiration.approximateDescription];

	BOOL showPurchaseDate = [[FRSSettingsService sharedInstance] showPurchaseDate];
	BOOL showExpirationDate = [[FRSSettingsService sharedInstance] showExpirationDate];

	if (showPurchaseDate && showExpirationDate) {
		dateText = [NSString stringWithFormat:@"%@ / %@", purchaseText, expirationText];

	} else if (showPurchaseDate) {
		dateText = purchaseText;

	} else if (showExpirationDate) {
		dateText = expirationText;
	}

	self.detailTextLabel.text = dateText;
	self.imageView.image = [UIImage imageForCategory:item.category withSize:50];

	if ([[FRSSettingsService sharedInstance] showStorageLocation]) {
		self.spaceLabel.text = @[@"R", @"F", @"P"][item.space.integerValue];
	} else {
		self.spaceLabel.text = @"";
	}
}

@end
