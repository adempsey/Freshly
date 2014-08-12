//
//  FreshlyItemViewController.m
//  Freshly
//
//  Created by Andrew Dempsey on 8/9/14.
//  Copyright (c) 2014 Andrew Dempsey. All rights reserved.
//

#import "FreshlyItemViewController.h"
#import "UIImage+FreshlyAdditions.h"
#import "FreshlyFoodItemService.h"

#define kImageViewSize 100.0

#define kTextViewWidth 160.0
#define kTextViewHeight 30.0

#define kCategoryPickerHeight 162.0

#define kTextInputSize 16.0

@interface FreshlyItemViewController ()

@property (nonatomic, readwrite, strong) FreshlyFoodItem *item;
@property (nonatomic, readwrite, strong) UIImageView *imageView;
@property (nonatomic, readwrite, strong) UITextField *titleField;
@property (nonatomic, readwrite, strong) UIButton *categoryButton;

@property (nonatomic, readwrite, strong) NSArray *categoryList;

@property (nonatomic, readwrite, strong) UIPickerView *categoryPicker;
@property (nonatomic, readwrite, strong) UIButton *categoryPickerDoneButton;
@property (nonatomic, readwrite, strong) UIView *darkBackground;

@end

@implementation FreshlyItemViewController

- (instancetype)initWithItem:(FreshlyFoodItem*)item
{
	if (self = [super init]) {
		self.item = item;
		self.imageView = [[UIImageView alloc] init];
		self.titleField = [[UITextField alloc] init];
		self.categoryButton = [[UIButton alloc] init];
		
		self.categoryList = [[NSArray alloc] initWithArray:[[FreshlyFoodItemService sharedInstance] foodItemCategoryList]];
		
		self.categoryPicker = [[UIPickerView alloc] init];
		self.categoryPickerDoneButton = [[UIButton alloc] init];
		self.darkBackground = [[UIView alloc] init];
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
	self.titleField.font = [UIFont systemFontOfSize:kTextInputSize];
	self.titleField.placeholder = @"Food";
	[self.view addSubview:self.titleField];
	
	UITapGestureRecognizer *pickerBackgroundTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissCategoryPicker)];
	
	CGRect screenBounds = [[UIScreen mainScreen] bounds];
	
	self.darkBackground.frame = screenBounds;
	self.darkBackground.backgroundColor = [UIColor blackColor];
	self.darkBackground.alpha = 0.0;
	[self.darkBackground addGestureRecognizer:pickerBackgroundTapRecognizer];
	
	self.categoryPicker.frame = CGRectMake(0, screenBounds.size.height, screenBounds.size.width, kCategoryPickerHeight);
	self.categoryPicker.backgroundColor = [UIColor whiteColor];
	self.categoryPicker.dataSource = self;
	self.categoryPicker.delegate = self;
	
	self.categoryPickerDoneButton.frame = CGRectMake(screenBounds.size.width - 80, 10, 80, 30);
	self.categoryPickerDoneButton.backgroundColor = [UIColor clearColor];
	[self.categoryPickerDoneButton setTitle:@"Done" forState:UIControlStateNormal];
	[self.categoryPickerDoneButton setTitle:@"Done" forState:UIControlStateSelected];
	[self.categoryPickerDoneButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
	[self.categoryPicker addSubview:self.categoryPickerDoneButton];
	
	self.categoryButton.frame = CGRectMake(140, 120, kTextViewWidth, kTextViewHeight);
	[self.categoryButton setTitle:[(self.item ? self.item.category : @"Category") capitalizedString] forState:UIControlStateNormal];
	[self.categoryButton setTitle:[(self.item ? self.item.category : @"Category") capitalizedString] forState:UIControlStateSelected];
	[self.categoryButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[self.categoryButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
	[self.categoryButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
	[self.categoryButton.titleLabel setFont:[UIFont systemFontOfSize:kTextInputSize]];
	[self.categoryButton addTarget:self action:@selector(presentCategoryPicker) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.categoryButton];
}

#pragma mark - CategoryPicker

- (void)presentCategoryPicker
{
	CGRect screenBounds = [[UIScreen mainScreen] bounds];
	[self.view addSubview:self.darkBackground];
	[self.view addSubview:self.categoryPicker];
	
	[UIView animateWithDuration:0.25 animations:^{
		[self.categoryPicker setFrame:CGRectMake(0, screenBounds.size.height - kCategoryPickerHeight, screenBounds.size.width, kCategoryPickerHeight)];
		self.darkBackground.alpha = 0.5;
	}];
}

- (void)dismissCategoryPicker
{
	CGRect screenBounds = [[UIScreen mainScreen] bounds];
	
	NSInteger selectedIndex = [self.categoryPicker selectedRowInComponent:0];
	NSString *categoryTitle = [self.categoryList objectAtIndex:selectedIndex];
	[self.categoryButton setTitle:categoryTitle forState:UIControlStateNormal];
	[self.categoryButton setTitle:categoryTitle forState:UIControlStateSelected];
	
	[UIView animateWithDuration:0.25 animations:^{
		[self.categoryPicker setFrame:CGRectMake(0, screenBounds.size.height, screenBounds.size.width, kCategoryPickerHeight)];
		self.darkBackground.alpha = 0.0;
	} completion:^(BOOL finished) {
		if (finished) {
			[self.darkBackground removeFromSuperview];
			[self.categoryPicker removeFromSuperview];
		}
	}];
}

#pragma mark - UIPickerView Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return self.categoryList.count;
}

#pragma mark - UIPickerView Datasource

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	return self.categoryList[row];
}

@end
