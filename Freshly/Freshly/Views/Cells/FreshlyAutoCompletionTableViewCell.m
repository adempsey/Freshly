//
//  FreshlyAutoCompletionTableViewCell.m
//  Freshly
//
//  Created by Andrew Dempsey on 8/16/14.
//  Copyright (c) 2014 Andrew Dempsey. All rights reserved.
//

#import "FreshlyAutoCompletionTableViewCell.h"
#import "FreshlyFoodItemService.h"

#import "UIImage+FreshlyAdditions.h"

#define kItemOffset 20.0
#define kImageViewSize 25.0

@implementation FreshlyAutoCompletionTableViewCell

- (instancetype)initWithName:(NSString*)name
{
	if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TABLE_VIEW_CELL_AUTO_COMPLETION_IDENTIFIER]) {
		self.textLabel.text = name.capitalizedString;
		NSString *category = [[FreshlyFoodItemService sharedInstance] categoryForFoodItemName:name];
		self.imageView.image = [UIImage imageForCategory:category withSize:50];
	}
	return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	CGRect imageViewFrame = self.imageView.frame;
	imageViewFrame.origin.x = kItemOffset;
	imageViewFrame.origin.y = (self.frame.size.height - kImageViewSize) / 2;
	imageViewFrame.size.width = kImageViewSize;
	imageViewFrame.size.height = kImageViewSize;
	self.imageView.frame = imageViewFrame;
	
	CGRect textLabelFrame = self.textLabel.frame;
	textLabelFrame.origin.x = imageViewFrame.origin.x + imageViewFrame.size.width + kItemOffset;
	self.textLabel.frame = textLabelFrame;
}

@end
