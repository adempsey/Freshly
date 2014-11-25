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
#import "UIFont+FreshlyAdditions.h"

#define kImageViewSize 100.0

#define kTextViewHeight 30.0

#define kPickerHeight 162.0

#define kTitleFieldFontSize 22.0
#define kCategoryFieldFontSize 18.0

#define kiPadFormSheetWidth 540.0
#define kiPadFormSheetHeight 620.0

#define kItemOffset 20.0

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

@property (nonatomic, readwrite, assign) BOOL userUpdatedExpirationDate;

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

		self.userUpdatedExpirationDate = self.itemExists;

		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
	}
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.view.backgroundColor = FRESHLY_COLOR_PRIMARY;
	
	self.navigationController.navigationBar.backgroundColor = FRESHLY_COLOR_LIGHT;
	self.navigationController.navigationBar.tintColor = FRESHLY_COLOR_DARK;
	
	CGRect whiteBackgroundFrame = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? CGRectMake(kItemOffset, 70.0, 540.0 - (kItemOffset*2), 530.0) :
																							CGRectMake(kItemOffset, 90, self.view.frame.size.width - (kItemOffset*2), self.view.frame.size.height - 110);
	UIView *whiteBackground = [[UIView alloc] initWithFrame:whiteBackgroundFrame];
	whiteBackground.backgroundColor = FRESHLY_COLOR_LIGHT;
	[self.view addSubview:whiteBackground];
	
	self.imageView.frame = CGRectMake(kItemOffset, kItemOffset, kImageViewSize, kImageViewSize);
	NSString *imageTitle = self.item ? self.item.category : FRESHLY_CATEGORY_MISC;
	self.imageView.image = [UIImage imageForCategory:imageTitle withSize:kImageViewSize];
	[whiteBackground addSubview:self.imageView];
	
	UIColor *categoryColor = [[FreshlyFoodItemService sharedInstance] colorForCategory:self.item.category];
	
	self.titleField.frame = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? CGRectMake(160, 90, 340, kTextViewHeight) : CGRectMake(160, 110, 120, kTextViewHeight);
	self.titleField.backgroundColor = FRESHLY_COLOR_LIGHT;
	self.titleField.text = self.item ? self.item.name : @"";
	self.titleField.textColor = FRESHLY_COLOR_DARK;
	self.titleField.tintColor = FRESHLY_COLOR_DARK;
	self.titleField.font = [UIFont boldFreshlyFontOfSize:kTitleFieldFontSize];
	self.titleField.placeholder = @"Food";
	self.titleField.returnKeyType = UIReturnKeyDone;
	self.titleField.clearButtonMode = UITextFieldViewModeWhileEditing;
	self.titleField.adjustsFontSizeToFitWidth = YES;
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
	self.categoryPicker.backgroundColor = FRESHLY_COLOR_PRIMARY;
	self.categoryPicker.tintColor = [UIColor redColor];
	self.categoryPicker.dataSource = self;
	self.categoryPicker.delegate = self;
	[self.categoryPicker selectRow:[self indexForCategory:self.item.category] inComponent:0 animated:NO];
	
	self.purchaseDatePicker.frame = CGRectMake(0, screenBounds.size.height, screenBounds.size.width, kPickerHeight);
	self.purchaseDatePicker.backgroundColor = FRESHLY_COLOR_PRIMARY;
	self.purchaseDatePicker.date = self.item.dateOfPurchase ? : [NSDate date];
	self.purchaseDatePicker.datePickerMode = UIDatePickerModeDate;
	
	self.expirationDatePicker.frame = CGRectMake(0, screenBounds.size.height, screenBounds.size.width, kPickerHeight);
	self.expirationDatePicker.backgroundColor = FRESHLY_COLOR_PRIMARY;
	self.expirationDatePicker.date = self.item.dateOfExpiration ? : [NSDate date];
	self.expirationDatePicker.datePickerMode = UIDatePickerModeDate;
	self.expirationDatePicker.minimumDate = self.purchaseDatePicker.date;
	
	self.categoryButton.frame = CGRectMake(self.imageView.frame.origin.x + self.imageView.frame.size.width + kItemOffset,
										   50.0,
										   160.0,
										   kTextViewHeight);
	[self.categoryButton setTitle:(self.item ? self.item.category : FRESHLY_ITEM_ATTRIBUTE_CATEGORY.capitalizedString) forState:UIControlStateNormal];
	[self.categoryButton setTitle:(self.item ? self.item.category : FRESHLY_ITEM_ATTRIBUTE_CATEGORY.capitalizedString) forState:UIControlStateSelected];
	[self.categoryButton setTitleColor:FRESHLY_COLOR_DARK forState:UIControlStateNormal];
	[self.categoryButton setTitleColor:FRESHLY_COLOR_DARK forState:UIControlStateSelected];
	[self.categoryButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
	[self.categoryButton.titleLabel setFont:[UIFont freshlyFontOfSize:kCategoryFieldFontSize]];
	[self.categoryButton addTarget:self action:@selector(presentCategoryPicker) forControlEvents:UIControlEventTouchUpInside];
	[whiteBackground addSubview:self.categoryButton];
	
	[self.itemDateViewController.view setFrame:CGRectMake(0,
														  self.imageView.frame.origin.y + self.imageView.frame.size.height + kItemOffset,
														  whiteBackground.frame.size.width,
														  80)];
	[self.itemDateViewController setBackgroundColor:categoryColor];
	self.itemDateViewController.purchaseDate = self.item.dateOfPurchase ? : [NSDate date];
	self.itemDateViewController.expirationDate = self.item.dateOfExpiration ? : [NSDate date];
	self.itemDateViewController.delegate = self;
	[whiteBackground addSubview:self.itemDateViewController.view];
	
	[self.spaceChooser setFrame:CGRectMake(kItemOffset,
										   self.itemDateViewController.view.frame.origin.y + self.itemDateViewController.view.frame.size.height + 2*kItemOffset,
										   whiteBackground.frame.size.width - (kItemOffset*2),
										   30)];
	self.spaceChooser.selectedSegmentIndex = [self.item.space integerValue];
	self.spaceChooser.tintColor = categoryColor;
	[self.spaceChooser setTitleTextAttributes:@{NSFontAttributeName: [UIFont freshlyFontOfSize:12.0]} forState:UIControlStateNormal];
	[self.spaceChooser addTarget:self action:@selector(userDidChangeSpace:) forControlEvents:UIControlEventValueChanged];
	[whiteBackground addSubview:self.spaceChooser];
	
	if (self.itemExists) {
		[self.moveToGroceryListButton setFrame:CGRectMake(kItemOffset,
														  (whiteBackground.frame.size.height + self.spaceChooser.frame.origin.y)/2 - 40,
														  self.spaceChooser.frame.size.width,
														  40)];
		[self.moveToGroceryListButton setTitle:@"Move To Grocery List" forState:UIControlStateNormal];
		[self.moveToGroceryListButton setTitle:@"Move To Grocery List" forState:UIControlStateSelected];
		self.moveToGroceryListButton.titleLabel.font = [UIFont freshlyFontOfSize:18.0];
		[self.moveToGroceryListButton setBackgroundColor:categoryColor];
		[self.moveToGroceryListButton addTarget:self action:@selector(moveItemToGroceryList) forControlEvents:UIControlEventTouchUpInside];
		[whiteBackground addSubview:self.moveToGroceryListButton];

		[self.deleteButton setFrame:CGRectMake(kItemOffset,
											   (whiteBackground.frame.size.height + self.spaceChooser.frame.origin.y)/2 + 30,
											   self.spaceChooser.frame.size.width,
											   40)];
		[self.deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
		[self.deleteButton setTitle:@"Delete" forState:UIControlStateSelected];
		self.deleteButton.titleLabel.font = [UIFont freshlyFontOfSize:18.0];
		[self.deleteButton setBackgroundColor:FRESHLY_COLOR_RED];
		[self.deleteButton addTarget:self action:@selector(showDeleteActionSheet) forControlEvents:UIControlEventTouchUpInside];
		[whiteBackground addSubview:self.deleteButton];
		
	} else {
		[self.saveButton setFrame:CGRectMake(kItemOffset,
											 (whiteBackground.frame.size.height + self.spaceChooser.frame.origin.y)/2,
											 self.spaceChooser.frame.size.width,
											 40)];
		[self.saveButton setTitle:@"Save" forState:UIControlStateNormal];
		[self.saveButton setTitle:@"Save" forState:UIControlStateSelected];
		self.saveButton.titleLabel.font = [UIFont freshlyFontOfSize:18.0];
		[self.saveButton setBackgroundColor:categoryColor];
		[self.saveButton addTarget:self action:@selector(saveNewItem) forControlEvents:UIControlEventTouchUpInside];
		[whiteBackground addSubview:self.saveButton];
		
	}
	
	self.autoCompletionViewController.delegate = self;
	self.autoCompletionViewController.frame = CGRectMake(0, 260, screenBounds.size.width, 152.0);
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

- (NSUInteger)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
	return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
	return UIInterfaceOrientationPortrait;
}

- (void)keyboardDidShow:(NSNotification*)notification
{
	NSDictionary *info = [notification userInfo];
	CGRect keyboardFrame = [info[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
	CGFloat autoCompletionOrigin = self.titleField.frame.origin.y + self.titleField.frame.size.height + 20.0;
	self.autoCompletionViewController.frame = CGRectMake(0,
														 autoCompletionOrigin,
														 self.view.frame.size.width,
														 keyboardFrame.origin.y - keyboardFrame.size.height - autoCompletionOrigin);
}

- (BOOL)hidesBottomBarWhenPushed
{
	return YES;
}

- (void)deleteItem
{
	[[FreshlyFoodItemService sharedInstance] deleteItem:self.item];
	self.itemExists = NO;

	if ([self respondsToSelector:@selector(presentingViewController)] && self.presentingViewController) {
		[self dismissViewControllerAnimated:YES completion:nil];
	} else {
		[self.navigationController popViewControllerAnimated:YES];
	}
}

#pragma mark - Actions

- (void)moveItemToGroceryList
{
	self.item.inStorage = [NSNumber numberWithBool:NO];

	if ([self respondsToSelector:@selector(presentingViewController)] && self.presentingViewController) {
		[self dismissViewControllerAnimated:YES completion:nil];
	} else {
		[self.navigationController popViewControllerAnimated:YES];
	}
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
		CGFloat viewHeight = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? kiPadFormSheetHeight : screenBounds.size.height;
		CGFloat viewWidth = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? kiPadFormSheetWidth : screenBounds.size.width;
		[pickerView setFrame:CGRectMake(0, viewHeight - kPickerHeight, viewWidth, kPickerHeight)];
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
			
			CGFloat viewHeight = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? kiPadFormSheetHeight : screenBounds.size.height;
			CGFloat viewWidth = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? kiPadFormSheetWidth : screenBounds.size.width;
			[self.currentPicker setFrame:CGRectMake(0, viewHeight, viewWidth, kPickerHeight)];
			
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

						self.expirationDatePicker.minimumDate = ((UIDatePicker*) self.currentPicker).date;

						if (!self.userUpdatedExpirationDate) {
							NSString *selectedSpace = [[FreshlyFoodItemService sharedInstance] titleForSpaceIndex:self.spaceChooser.selectedSegmentIndex];
							NSInteger defaultExpirationTime = [[FreshlyFoodItemService sharedInstance] defaultExpirationTimeForFoodItemName:self.titleField.text inSpace:selectedSpace];
							NSDate *defaultExpirationDate = [self.itemDateViewController.purchaseDate dateByAddingTimeInterval:60*60*24*defaultExpirationTime];
							self.itemDateViewController.expirationDate = defaultExpirationDate;
						}

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

#pragma mark - Space Chooser

- (void)userDidChangeSpace:(id)sender
{
	if (!self.userUpdatedExpirationDate) {
		NSString *selectedSpace = [[FreshlyFoodItemService sharedInstance] titleForSpaceIndex:self.spaceChooser.selectedSegmentIndex];
		NSInteger defaultExpirationTime = [[FreshlyFoodItemService sharedInstance] defaultExpirationTimeForFoodItemName:self.titleField.text inSpace:selectedSpace];
		NSDate *defaultExpirationDate = [[NSDate date] dateByAddingTimeInterval:60*60*24*defaultExpirationTime];
		self.itemDateViewController.expirationDate = defaultExpirationDate;
	}
}

#pragma mark - UIPickerView Datasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return self.categoryList.count;
}

#pragma mark - UIPickerView Delegate

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
		self.userUpdatedExpirationDate = YES;
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
	if (![self.autoCompletionViewController hasUniqueItemAvailable]) {
		[self dismissInput];
	}
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

	NSString *defaultItemSpace = [[FreshlyFoodItemService sharedInstance] defaultSpaceForFoodItemName:item];
	self.spaceChooser.selectedSegmentIndex = [[FreshlyFoodItemService sharedInstance] spaceIndexForTitle:defaultItemSpace];

	NSInteger defaultExpirationTime = [[FreshlyFoodItemService sharedInstance] defaultExpirationTimeForFoodItemName:item inSpace:defaultItemSpace];

	if (defaultExpirationTime < 0) {
		self.itemDateViewController.expirationDate = [NSDate distantFuture];
	} else {
		NSDate *defaultExpirationDate = [[NSDate date] dateByAddingTimeInterval:60*60*24*defaultExpirationTime];
		self.itemDateViewController.expirationDate = defaultExpirationDate;
		self.expirationDatePicker.date = defaultExpirationDate;
	}

	self.userUpdatedExpirationDate = NO;

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

@end
