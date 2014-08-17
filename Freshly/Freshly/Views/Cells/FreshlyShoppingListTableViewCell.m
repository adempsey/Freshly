//
//  FreshlyShoppingListTableViewCell.m
//  Freshly
//
//  Created by Andrew Dempsey on 8/15/14.
//  Copyright (c) 2014 Andrew Dempsey. All rights reserved.
//

#import "FreshlyShoppingListTableViewCell.h"

#import "UIImage+FreshlyAdditions.h"

#define kItemOffset 20.0
#define kImageViewSize 25.0

@interface FreshlyShoppingListTableViewCell ()

@property (nonatomic, readwrite, strong) UIButton *checkBox;
@property (nonatomic, readwrite, assign) BOOL checked;

@end

@implementation FreshlyShoppingListTableViewCell

- (instancetype)initWithItem:(FreshlyFoodItem *)item
{
	if (self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:TABLE_VIEW_CELL_SHOPPING_LIST_IDENTIFIER]) {
		[self setItem:item];

		self.checkBox = [[UIButton alloc] init];
		[self.checkBox setBackgroundImage:[UIImage imageNamed:@"checkbox_empty"] forState:UIControlStateNormal];
		[self.checkBox addTarget:self action:@selector(toggleItemCheck) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:self.checkBox];

		self.checked = NO;
	}
	return self;
}

- (void)setItem:(FreshlyFoodItem *)item
{
	self.textLabel.text = item.name;
	self.imageView.image = [UIImage imageForCategory:item.category withSize:50];
}

- (void)layoutSubviews
{
	[super layoutSubviews];

	self.checkBox.frame = CGRectMake(kItemOffset, (self.frame.size.height - 20) / 2, 20, 20);

	CGRect imageViewFrame = self.imageView.frame;
	imageViewFrame.origin.x = self.checkBox.frame.origin.x + self.checkBox.frame.size.width + kItemOffset;
	imageViewFrame.origin.y = (self.frame.size.height - kImageViewSize) / 2;
	imageViewFrame.size.width = kImageViewSize;
	imageViewFrame.size.height = kImageViewSize;
	self.imageView.frame = imageViewFrame;

	CGRect textLabelFrame = self.textLabel.frame;
	textLabelFrame.origin.x = imageViewFrame.origin.x + imageViewFrame.size.width + kItemOffset;
	self.textLabel.frame = textLabelFrame;
}

- (void)toggleItemCheck
{
	if (self.checked) {
		[self.checkBox setBackgroundImage:[UIImage imageNamed:@"checkbox_empty"] forState:UIControlStateNormal];
		self.checked = NO;
	} else {
		[self.checkBox setBackgroundImage:[UIImage imageNamed:@"checkbox_checked"] forState:UIControlStateNormal];
		self.checked = YES;
	}
}

@end
