//
//  FreshlyItemViewController.m
//  Freshly
//
//  Created by Andrew Dempsey on 8/9/14.
//  Copyright (c) 2014 Andrew Dempsey. All rights reserved.
//

#import "FreshlyItemViewController.h"
#import "FreshlyFoodItemService.h"

#import "UIImage+FreshlyAdditions.h"

#define kImageViewSize 100.0

#define kTextViewWidth 160.0
#define kTextViewHeight 30.0

#define kPickerHeight 162.0

#define kTitleFieldFontSize 22.0
#define kCategoryFieldFontSize 18.0

@interface FreshlyItemViewController ()

@property (nonatomic, readwrite, strong) FreshlyFoodItem *item;
@property (nonatomic, readwrite, strong) UIImageView *imageView;
@property (nonatomic, readwrite, strong) UITextField *titleField;
@property (nonatomic, readwrite, strong) UIButton *categoryButton;
@property (nonatomic, readwrite, strong) FreshlyItemDateViewController *itemDateViewController;
@property (nonatomic, readwrite, strong) UISegmentedControl *spaceChooser;

@property (nonatomic, readwrite, strong) UIButton *moveToGroceryListButton;
@property (nonatomic, readwrite, strong) UIButton *deleteButton;

@property (nonatomic, readwrite, strong) NSArray *categoryList;

@property (nonatomic, readwrite, strong) UIPickerView *categoryPicker;
@property (nonatomic, readwrite, strong) UIDatePicker *purchaseDatePicker;
@property (nonatomic, readwrite, strong) UIDatePicker *expirationDatePicker;
@property (nonatomic, readwrite, strong) UIButton *categoryPickerDoneButton;
@property (nonatomic, readwrite, strong) UIView *darkBackground;
@property (nonatomic, readwrite, weak) id currentPicker;

@end

@implementation FreshlyItemViewController

- (instancetype)initWithItem:(FreshlyFoodItem*)item
{
	if (self = [super init]) {
		self.item = item;
		self.imageView = [[UIImageView alloc] init];
		self.titleField = [[UITextField alloc] init];
		self.categoryButton = [[UIButton alloc] init];
		self.itemDateViewController = [[FreshlyItemDateViewController alloc] init];
		self.spaceChooser = [[UISegmentedControl alloc] initWithItems:@[@"Refrigerator", @"Freezer", @"Pantry"]];
		
		self.moveToGroceryListButton = [[UIButton alloc] init];
		self.deleteButton = [[UIButton alloc] init];
		
		self.categoryList = [[NSArray alloc] initWithArray:[[FreshlyFoodItemService sharedInstance] foodItemCategoryList]];
		
		self.categoryPicker = [[UIPickerView alloc] init];
		self.purchaseDatePicker = [[UIDatePicker alloc] init];
		self.expirationDatePicker = [[UIDatePicker alloc] init];
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
	
	UIColor *categoryColor = [[FreshlyFoodItemService sharedInstance] colorForCategory:self.item.category];
	
	self.titleField.frame = CGRectMake(140, 80, kTextViewWidth, kTextViewHeight);
	self.titleField.backgroundColor = [UIColor whiteColor];
	self.titleField.text = self.item ? self.item.name : @"";
	self.titleField.font = [UIFont systemFontOfSize:kTitleFieldFontSize];
	self.titleField.placeholder = @"Food";
	self.titleField.returnKeyType = UIReturnKeyDone;
	self.titleField.delegate = self;
	[self.view addSubview:self.titleField];
	
	UITapGestureRecognizer *pickerBackgroundTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissInput)];
	
	CGRect screenBounds = [[UIScreen mainScreen] bounds];
	
	self.darkBackground.frame = screenBounds;
	self.darkBackground.backgroundColor = [UIColor blackColor];
	self.darkBackground.alpha = 0.0;
	[self.darkBackground addGestureRecognizer:pickerBackgroundTapRecognizer];
	
	self.categoryPicker.frame = CGRectMake(0, screenBounds.size.height, screenBounds.size.width, kPickerHeight);
	self.categoryPicker.backgroundColor = [UIColor whiteColor];
	self.categoryPicker.dataSource = self;
	self.categoryPicker.delegate = self;
	
	self.purchaseDatePicker.frame = CGRectMake(0, screenBounds.size.height, screenBounds.size.width, kPickerHeight);
	self.purchaseDatePicker.backgroundColor = [UIColor whiteColor];
	self.purchaseDatePicker.date = self.item.dateOfPurchase;
	self.purchaseDatePicker.datePickerMode = UIDatePickerModeDate;
	
	self.expirationDatePicker.frame = CGRectMake(0, screenBounds.size.height, screenBounds.size.width, kPickerHeight);
	self.expirationDatePicker.backgroundColor = [UIColor whiteColor];
	self.expirationDatePicker.date = self.item.dateOfExpiration;
	self.expirationDatePicker.datePickerMode = UIDatePickerModeDate;
	
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
	[self.categoryButton.titleLabel setFont:[UIFont systemFontOfSize:kCategoryFieldFontSize]];
	[self.categoryButton addTarget:self action:@selector(presentCategoryPicker) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.categoryButton];
	
	[self.itemDateViewController.view setFrame:CGRectMake(0, 220, screenBounds.size.width, 90)];
	[self.itemDateViewController setBackgroundColor:categoryColor];
	self.itemDateViewController.purchaseDate = self.item.dateOfPurchase;
	self.itemDateViewController.expirationDate = self.item.dateOfExpiration;
	self.itemDateViewController.delegate = self;
	[self.view addSubview:self.itemDateViewController.view];
	
	[self.spaceChooser setFrame:CGRectMake(20, 350, screenBounds.size.width - 40, 30)];
	self.spaceChooser.selectedSegmentIndex = [self.item.space integerValue];
	self.spaceChooser.tintColor = categoryColor;
	[self.view addSubview:self.spaceChooser];
	
	[self.moveToGroceryListButton setFrame:CGRectMake(20, 420, screenBounds.size.width - 40, 40)];
	[self.moveToGroceryListButton setTitle:@"Move To Grocery List" forState:UIControlStateNormal];
	[self.moveToGroceryListButton setTitle:@"Move To Grocery List" forState:UIControlStateSelected];
	[self.moveToGroceryListButton setBackgroundColor:categoryColor];
	[self.moveToGroceryListButton addTarget:self action:@selector(moveItemToGroceryList) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.moveToGroceryListButton];
	
	[self.deleteButton setFrame:CGRectMake(20, 490, screenBounds.size.width - 40, 40)];
	[self.deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
	[self.deleteButton setTitle:@"Delete" forState:UIControlStateSelected];
	[self.deleteButton setBackgroundColor:FCOLOR_RED];
	[self.view addSubview:self.deleteButton];
	
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	self.item.name = self.titleField.text;
	self.item.category = self.categoryButton.titleLabel.text.lowercaseString;
	self.item.dateOfPurchase = self.purchaseDatePicker.date;
	self.item.dateOfExpiration = self.expirationDatePicker.date;
	self.item.space = [NSNumber numberWithInteger:self.spaceChooser.selectedSegmentIndex];
	
	[[FreshlyFoodItemService sharedInstance] updateItem:self.item];
}

- (void)moveItemToGroceryList
{
	self.item.inStorage = [NSNumber numberWithBool:NO];
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Picker Views

- (void)presentCategoryPicker
{
	[self presentPicker:self.categoryPicker];
}

- (void)presentPicker:(id)pickerView
{
	CGRect screenBounds = [[UIScreen mainScreen] bounds];
	[self.view addSubview:self.darkBackground];
	[self.view addSubview:pickerView];
	
	[UIView animateWithDuration:0.25 animations:^{
		[pickerView setFrame:CGRectMake(0, screenBounds.size.height - kPickerHeight, screenBounds.size.width, kPickerHeight)];
		self.darkBackground.alpha = 0.5;
	} completion:^(BOOL finished) {
		self.currentPicker = pickerView;
	}];
}

- (void)dismissInput
{
	CGRect screenBounds = [[UIScreen mainScreen] bounds];
	
	[self.titleField resignFirstResponder];
	
	[UIView animateWithDuration:0.25 animations:^{
		self.darkBackground.alpha = 0.0;
		
		if (self.currentPicker) {
			
			[self.currentPicker setFrame:CGRectMake(0, screenBounds.size.height, screenBounds.size.width, kPickerHeight)];
			
			if ([self.currentPicker isKindOfClass:[UIPickerView class]] && [self.currentPicker isEqual:self.categoryPicker]) {
				NSInteger selectedIndex = [self.currentPicker selectedRowInComponent:0];
				NSString *categoryTitle = [self.categoryList objectAtIndex:selectedIndex];
				[self.categoryButton setTitle:categoryTitle forState:UIControlStateNormal];
				[self.categoryButton setTitle:categoryTitle forState:UIControlStateSelected];
				
				UIColor *categoryColor = [[FreshlyFoodItemService sharedInstance] colorForCategory:categoryTitle];
				
				self.imageView.image = [UIImage imageForCategory:categoryTitle withSize:kImageViewSize];
				self.spaceChooser.tintColor = categoryColor;
				self.moveToGroceryListButton.backgroundColor = categoryColor;
				[self.itemDateViewController setBackgroundColor:categoryColor];
			}
			
		}
		
	} completion:^(BOOL finished) {
		if (finished) {
			[self.darkBackground removeFromSuperview];
			
			if (self.currentPicker) {
				
				[self.currentPicker removeFromSuperview];
				
				if ([self.currentPicker isKindOfClass:[UIDatePicker class]]) {
					
					if ([self.currentPicker isEqual:self.purchaseDatePicker]) {
						self.itemDateViewController.purchaseDate = ((UIDatePicker*) self.currentPicker).date;
						
					} else if ([self.currentPicker isEqual:self.expirationDatePicker]) {
						self.itemDateViewController.expirationDate = ((UIDatePicker*) self.expirationDatePicker).date;
					}
				}
			}
			
			self.currentPicker = nil;
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

#pragma mark - FreshlyItemDate Delegate

- (void)itemDateViewDidBeginEditingDate:(NSDate *)date
{
	if ([date isEqual:self.itemDateViewController.purchaseDate]) {
		[self presentPicker:self.purchaseDatePicker];
	} else if ([date isEqual:self.itemDateViewController.expirationDate]) {
		[self presentPicker:self.expirationDatePicker];
	}
}

#pragma mark - UITextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	[self.view addSubview:self.darkBackground];
	[self.view bringSubviewToFront:self.titleField];
	
	[UIView animateWithDuration:0.25 animations:^{
		self.darkBackground.alpha = 0.5;
	}];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[self dismissInput];
	return YES;
}

@end
