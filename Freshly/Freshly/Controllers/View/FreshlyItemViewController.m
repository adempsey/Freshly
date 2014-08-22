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

@property (nonatomic, readwrite, strong) UIButton *saveButton;

@property (nonatomic, readwrite, strong) NSArray *categoryList;

@property (nonatomic, readwrite, strong) UIPickerView *categoryPicker;
@property (nonatomic, readwrite, strong) UIDatePicker *purchaseDatePicker;
@property (nonatomic, readwrite, strong) UIDatePicker *expirationDatePicker;
@property (nonatomic, readwrite, strong) UIButton *categoryPickerDoneButton;
@property (nonatomic, readwrite, strong) UIView *darkBackground;
@property (nonatomic, readwrite, weak) id currentPicker;

@property (nonatomic, readwrite, strong) FreshlyFoodAutoCompletionViewController *autoCompletionViewController;

@property (nonatomic, readwrite, assign) BOOL itemExists;

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
		self.spaceChooser = [[UISegmentedControl alloc] initWithItems:@[FRESHLY_SPACE_REFRIGERATOR, FRESHLY_SPACE_FREEZER, FRESHLY_SPACE_PANTRY]];
		
		self.moveToGroceryListButton = [[UIButton alloc] init];
		self.deleteButton = [[UIButton alloc] init];
		
		self.saveButton = [[UIButton alloc] init];
		
		self.categoryList = [[NSArray alloc] initWithArray:[[FreshlyFoodItemService sharedInstance] foodItemCategoryList]];
		
		self.categoryPicker = [[UIPickerView alloc] init];
		self.purchaseDatePicker = [[UIDatePicker alloc] init];
		self.expirationDatePicker = [[UIDatePicker alloc] init];
		self.categoryPickerDoneButton = [[UIButton alloc] init];
		self.darkBackground = [[UIView alloc] init];
		
		self.autoCompletionViewController = [[FreshlyFoodAutoCompletionViewController alloc] init];
		
		self.itemExists = (item != nil);
	}
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.view.backgroundColor = [UIColor whiteColor];
	
	self.imageView.frame = CGRectMake(20, 80, kImageViewSize, kImageViewSize);
	NSString *imageTitle = self.item ? self.item.category : FRESHLY_CATEGORY_MISC;
	self.imageView.image = [UIImage imageForCategory:imageTitle withSize:kImageViewSize];
	[self.view addSubview:self.imageView];
	
	UIColor *categoryColor = [[FreshlyFoodItemService sharedInstance] colorForCategory:self.item.category];
	
	self.titleField.frame = CGRectMake(140, 80, kTextViewWidth, kTextViewHeight);
	self.titleField.backgroundColor = [UIColor whiteColor];
	self.titleField.text = self.item ? self.item.name : @"";
	self.titleField.font = [UIFont systemFontOfSize:kTitleFieldFontSize];
	self.titleField.placeholder = @"Food";
	self.titleField.returnKeyType = UIReturnKeyDone;
	self.titleField.clearButtonMode = UITextFieldViewModeWhileEditing;
	self.titleField.delegate = self;
	self.titleField.autocorrectionType = UITextAutocorrectionTypeNo;
	[self.titleField addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
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
	[self.categoryPicker selectRow:[self indexForCategory:self.item.category] inComponent:0 animated:NO];
	
	self.purchaseDatePicker.frame = CGRectMake(0, screenBounds.size.height, screenBounds.size.width, kPickerHeight);
	self.purchaseDatePicker.backgroundColor = [UIColor whiteColor];
	self.purchaseDatePicker.date = self.item.dateOfPurchase ? : [NSDate date];
	self.purchaseDatePicker.datePickerMode = UIDatePickerModeDate;
	
	self.expirationDatePicker.frame = CGRectMake(0, screenBounds.size.height, screenBounds.size.width, kPickerHeight);
	self.expirationDatePicker.backgroundColor = [UIColor whiteColor];
	self.expirationDatePicker.date = self.item.dateOfExpiration ? : [NSDate date];
	self.expirationDatePicker.datePickerMode = UIDatePickerModeDate;
	
	self.categoryPickerDoneButton.frame = CGRectMake(screenBounds.size.width - 80, 10, 80, 30);
	self.categoryPickerDoneButton.backgroundColor = [UIColor clearColor];
	[self.categoryPickerDoneButton setTitle:@"Done" forState:UIControlStateNormal];
	[self.categoryPickerDoneButton setTitle:@"Done" forState:UIControlStateSelected];
	[self.categoryPickerDoneButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
	[self.categoryPicker addSubview:self.categoryPickerDoneButton];
	
	self.categoryButton.frame = CGRectMake(140, 120, kTextViewWidth, kTextViewHeight);
	[self.categoryButton setTitle:(self.item ? self.item.category : @"Category") forState:UIControlStateNormal];
	[self.categoryButton setTitle:(self.item ? self.item.category : @"Category") forState:UIControlStateSelected];
	[self.categoryButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[self.categoryButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
	[self.categoryButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
	[self.categoryButton.titleLabel setFont:[UIFont systemFontOfSize:kCategoryFieldFontSize]];
	[self.categoryButton addTarget:self action:@selector(presentCategoryPicker) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.categoryButton];
	
	[self.itemDateViewController.view setFrame:CGRectMake(0, 220, screenBounds.size.width, 90)];
	[self.itemDateViewController setBackgroundColor:categoryColor];
	self.itemDateViewController.purchaseDate = self.item.dateOfPurchase ? : [NSDate date];
	self.itemDateViewController.expirationDate = self.item.dateOfExpiration ? : [NSDate date];
	self.itemDateViewController.delegate = self;
	[self.view addSubview:self.itemDateViewController.view];
	
	[self.spaceChooser setFrame:CGRectMake(20, 350, screenBounds.size.width - 40, 30)];
	self.spaceChooser.selectedSegmentIndex = [self.item.space integerValue];
	self.spaceChooser.tintColor = categoryColor;
	[self.view addSubview:self.spaceChooser];
	
	if (self.itemExists) {
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
		[self.deleteButton addTarget:self action:@selector(showDeleteActionSheet) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:self.deleteButton];
		
	} else {
		[self.saveButton setFrame:CGRectMake(20, 460, screenBounds.size.width - 40, 40)];
		[self.saveButton setTitle:@"Save" forState:UIControlStateNormal];
		[self.saveButton setTitle:@"Save" forState:UIControlStateSelected];
		[self.saveButton setBackgroundColor:categoryColor];
		[self.saveButton addTarget:self action:@selector(saveNewItem) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:self.saveButton];
		
	}
	
	self.autoCompletionViewController.delegate = self;
	[self.view addSubview:self.autoCompletionViewController.view];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	
	if (self.itemExists) {
		self.item.name = self.titleField.text;
		self.item.category = self.categoryButton.titleLabel.text;
		self.item.dateOfPurchase = self.purchaseDatePicker.date;
		self.item.dateOfExpiration = self.expirationDatePicker.date;
		self.item.space = [NSNumber numberWithInteger:self.spaceChooser.selectedSegmentIndex];

		[[FreshlyFoodItemService sharedInstance] updateItem:self.item];
	}
}

- (BOOL)hidesBottomBarWhenPushed
{
	return YES;
}

- (void)deleteItem
{
	[[FreshlyFoodItemService sharedInstance] deleteItem:self.item];
	self.itemExists = NO;
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Actions

- (void)moveItemToGroceryList
{
	self.item.inStorage = [NSNumber numberWithBool:NO];
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)saveNewItem
{
	NSDictionary *attributes = @{FRESHLY_ITEM_ATTRIBUTE_NAME: self.titleField.text,
								 FRESHLY_ITEM_ATTRIBUTE_CATEGORY: self.categoryButton.titleLabel.text,
								 FRESHLY_ITEM_ATTRIBUTE_SPACE: [NSNumber numberWithInteger: self.spaceChooser.selectedSegmentIndex],
								 FRESHLY_ITEM_ATTRIBUTE_IN_STORAGE: [NSNumber numberWithBool:YES],
								 FRESHLY_ITEM_ATTRIBUTE_BRAND: @"",
								 FRESHLY_ITEM_ATTRIBUTE_PURCHASE_DATE: self.itemDateViewController.purchaseDate,
								 FRESHLY_ITEM_ATTRIBUTE_EXPIRATION_DATE: self.itemDateViewController.expirationDate};
	
	[[FreshlyFoodItemService sharedInstance] createItemWithAttributes:attributes];

	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showDeleteActionSheet
{
	UIActionSheet *deleteActionSheet = [[UIActionSheet alloc] initWithTitle:@"Are you sure you want to delete this item?"
																   delegate:self
														  cancelButtonTitle:@"Cancel"
													 destructiveButtonTitle:@"Delete"
														  otherButtonTitles:nil];
	[deleteActionSheet showInView:self.view];
}

#pragma mark - TextField

- (void)textFieldDidChange
{
	[self.autoCompletionViewController setPrefix:self.titleField.text.lowercaseString];
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
				NSString *categoryTitle = self.categoryList[selectedIndex];
				[self.categoryButton setTitle:categoryTitle forState:UIControlStateNormal];
				[self.categoryButton setTitle:categoryTitle forState:UIControlStateSelected];
				
				UIColor *categoryColor = [[FreshlyFoodItemService sharedInstance] colorForCategory:categoryTitle];
				
				self.imageView.image = [UIImage imageForCategory:categoryTitle withSize:kImageViewSize];
				self.spaceChooser.tintColor = categoryColor;
				self.moveToGroceryListButton.backgroundColor = categoryColor;
				[self.itemDateViewController setBackgroundColor:categoryColor];
				self.saveButton.backgroundColor = categoryColor;
			}
			
		}
		
		if ([self.autoCompletionViewController.view isDescendantOfView:self.view]) {
			self.autoCompletionViewController.view.alpha = 0.0;
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

- (NSInteger)indexForCategory:(NSString*)category
{
	NSArray *categories = [[FreshlyFoodItemService sharedInstance] foodItemCategoryList];
	NSString *object = category ? : FRESHLY_CATEGORY_MISC;
	return [categories indexOfObject:object];
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
	[self.view bringSubviewToFront:self.autoCompletionViewController.view];
	
	[UIView animateWithDuration:0.25 animations:^{
		self.darkBackground.alpha = 0.5;
	}];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[self dismissInput];
	return YES;
}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0) {
		[self deleteItem];
	}
}

#pragma mark - AutoCompletion Delegate

- (void)didSelectAutoCompletedItem:(NSString *)item withCategory:(NSString *)category
{
	self.titleField.text = item.capitalizedString;
	
	[self.categoryButton setTitle:category forState:UIControlStateNormal];
	[self.categoryButton setTitle:category forState:UIControlStateSelected];
	NSInteger categoryIndex = [self.categoryList indexOfObject:category];
	[self.categoryPicker selectRow:categoryIndex inComponent:0 animated:NO];
	
	UIColor *categoryColor = [[FreshlyFoodItemService sharedInstance] colorForCategory:category];
	
	[UIView animateWithDuration:0.25 animations:^{
		self.imageView.image = [UIImage imageForCategory:category withSize:kImageViewSize];
		self.spaceChooser.tintColor = categoryColor;
		self.moveToGroceryListButton.backgroundColor = categoryColor;
		[self.itemDateViewController setBackgroundColor:categoryColor];
		self.saveButton.backgroundColor = categoryColor;
	}];
	
	[self dismissInput];
	[self.autoCompletionViewController setPrefix:@""];
}

- (CGFloat)heightForAutoCompletionTableView
{
	return 152.0;
}

@end
