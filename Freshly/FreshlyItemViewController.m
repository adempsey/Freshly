//
//  FreshlyItemViewController.m
//  Freshly
//
//  Created by Andrew Dempsey on 8/9/14.
//  Copyright (c) 2014 Andrew Dempsey. All rights reserved.
//

#import "FreshlyItemViewController.h"
#import "UIImage+FreshlyAdditions.h"

#define kImageViewSize 100
#define kTextViewWidth 160
#define kTextViewHeight 30

@interface FreshlyItemViewController ()

@property (nonatomic, readwrite, strong) FreshlyFoodItem *item;
@property (nonatomic, readwrite, strong) UIImageView *imageView;
@property (nonatomic, readwrite, strong) UITextField *titleField;
@property (nonatomic, readwrite, strong) UITextField *categoryField;

@end

@implementation FreshlyItemViewController

- (instancetype)initWithItem:(FreshlyFoodItem*)item
{
	if (self = [super init]) {
		self.item = item;
		self.imageView = [[UIImageView alloc] init];
		self.titleField = [[UITextField alloc] init];
		self.categoryField = [[UITextField alloc] init];
	}
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.imageView.frame = CGRectMake(20, 80, kImageViewSize, kImageViewSize);
	NSString *imageTitle = self.item ? self.item.category : @"default";
	self.imageView.image = [UIImage imageForCategory:imageTitle withSize:kImageViewSize];
	[self.view addSubview:self.imageView];
	
	self.titleField.frame = CGRectMake(140, 80, kTextViewWidth, kTextViewHeight);
	self.titleField.text = self.item ? self.item.name : @"";
	self.titleField.placeholder = @"Food";
	[self.view addSubview:self.titleField];
	
	self.categoryField.frame = CGRectMake(140, 120, kTextViewWidth, kTextViewHeight);
	self.categoryField.text = [(self.item ? self.item.category : @"") capitalizedString];
	self.categoryField.placeholder = @"Category";
	[self.view addSubview:self.categoryField];
}

@end
