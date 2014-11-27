//
//  FreshlyShoppingListViewController.m
//  Freshly
//
//  Created by Andrew Dempsey on 7/29/14.
//  Copyright (c) 2014 Andrew Dempsey. All rights reserved.
//

#import "FreshlyShoppingListViewController.h"
#import "FreshlyFoodItemService.h"
#import "FreshlySettingsService.h"

#import "UIFont+FreshlyAdditions.h"

@interface FreshlyShoppingListViewController ()

@property (nonatomic, readwrite, strong) NSArray *items;
@property (atomic, readwrite, strong) NSMutableArray *checkedItems;
@property (nonatomic, readwrite, strong) UITableView *tableView;

@property (nonatomic, readwrite, strong) UIView *addNewItemView;
@property (nonatomic, readwrite, strong) UITextField *addNewItemTextField;

@property (nonatomic, readwrite, strong) UIView *darkBackground;

@property (nonatomic, readwrite, strong) FreshlyFoodAutoCompletionViewController *autoCompletionViewController;

@end

@implementation FreshlyShoppingListViewController

- (id)init
{
    self = [super init];
    if (self) {
		self.title = FRESHLY_SECTION_SHOPPING_LIST;
		
		UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
		titleLabel.text = FRESHLY_SECTION_SHOPPING_LIST;
		titleLabel.textColor = FRESHLY_COLOR_DARK;
		titleLabel.font = [UIFont boldFreshlyFontOfSize:18.0];
		titleLabel.textAlignment = NSTextAlignmentCenter;
		self.navigationItem.titleView = titleLabel;

		self.items = [[NSArray alloc] init];
		[[FreshlyFoodItemService sharedInstance] retrieveItemsForShoppingListWithBlock:^(NSArray *items) {
			self.items = items;
		}];

		self.checkedItems = [[NSMutableArray alloc] init];

		self.tableView = [[UITableView alloc] init];
		self.tableView.delegate = self;
		self.tableView.dataSource = self;
		
		self.addNewItemView = [[UIView alloc] init];
		self.addNewItemTextField = [[UITextField alloc] init];
		
		self.darkBackground = [[UIView alloc] init];
		
		self.autoCompletionViewController = [[FreshlyFoodAutoCompletionViewController alloc] init];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveItemUpdateNotification:) name:NOTIFICATION_ITEM_UPDATED object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.tableView.frame = self.view.frame;
	NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:FRESHLY_ITEM_ATTRIBUTE_NAME ascending:YES];
	self.items = [self.items sortedArrayUsingDescriptors:@[sortDescriptor]];
	[self.view addSubview:self.tableView];
	[self updateAddNewItemLayout];
	self.addNewItemView.backgroundColor = FRESHLY_COLOR_PRIMARY;
	self.addNewItemView.alpha = 0.0;

	UIView *textFieldPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 25)];
	self.addNewItemTextField.leftView = textFieldPadding;
	self.addNewItemTextField.leftViewMode = UITextFieldViewModeAlways;

	self.addNewItemTextField.font = [UIFont freshlyFontOfSize:18.0];
	self.addNewItemTextField.placeholder = @"Add New Item";
	self.addNewItemTextField.backgroundColor = [UIColor whiteColor];
	self.addNewItemTextField.returnKeyType = UIReturnKeyDone;
	self.addNewItemTextField.autocorrectionType = UITextAutocorrectionTypeNo;
	self.addNewItemTextField.textColor = FRESHLY_COLOR_DARK;
	self.addNewItemTextField.tintColor = FRESHLY_COLOR_DARK;
	self.addNewItemTextField.delegate = self;
	[self.addNewItemTextField addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
	[self.addNewItemView addSubview:self.addNewItemTextField];
	
	self.darkBackground.frame = self.view.frame;
	self.darkBackground.backgroundColor = [UIColor blackColor];
	self.darkBackground.alpha = 0.0;
	
	UITapGestureRecognizer *inputDismissalGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissInput)];
	[self.darkBackground addGestureRecognizer:inputDismissalGesture];
	
	UIBarButtonItem *addNewItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(beginAddNewItem)];
	self.navigationItem.rightBarButtonItem = addNewItem;
	
	self.autoCompletionViewController.delegate = self;
	[self.view addSubview:self.autoCompletionViewController.view];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	self.tableView.frame = self.view.frame;
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[[FreshlySettingsService sharedInstance] setSelectedSection:1];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[self moveSelectedItemsToStorage];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	CGRect screenBounds = [[UIScreen mainScreen] bounds];
	CGRect newScreenBounds = CGRectMake(screenBounds.origin.x, screenBounds.origin.y, screenBounds.size.height, screenBounds.size.width);
	self.view.frame = newScreenBounds;
	self.tableView.frame = self.view.frame;
	self.darkBackground.frame = self.view.frame;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	[self updateAddNewItemLayout];
}

- (void)didReceiveItemUpdateNotification:(NSNotification*)notification
{
	[self reloadAllTableViewSections];
}

- (void)keyboardDidShow:(NSNotification*)notification
{
	NSDictionary *info = [notification userInfo];
	CGRect keyboardFrame = [info[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
	CGFloat autoCompletionOrigin = self.addNewItemView.frame.origin.y + self.addNewItemView.frame.size.height;
	self.autoCompletionViewController.frame = CGRectMake(0,
														 autoCompletionOrigin,
														 self.view.frame.size.width,
														 keyboardFrame.origin.y - keyboardFrame.size.height - autoCompletionOrigin);
}

- (void)updateAddNewItemLayout
{
	CGFloat yOrigin = self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
	CGFloat width = self.view.frame.size.width;
	self.addNewItemView.frame = CGRectMake(0, yOrigin, width, 50);
	
	self.addNewItemTextField.frame = CGRectMake(10, 15, width - 20, 25);
}

- (void)reloadAllTableViewSections
{
	[[FreshlyFoodItemService sharedInstance] retrieveItemsForShoppingListWithBlock:^(NSArray *items) {
		self.items = items;
		NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:FRESHLY_ITEM_ATTRIBUTE_NAME ascending:YES];
		self.items = [self.items sortedArrayUsingDescriptors:@[sortDescriptor]];
		NSRange sectionRange = NSMakeRange(0, self.tableView.numberOfSections);
		NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:sectionRange];
		[self.tableView reloadSections:sections withRowAnimation:UITableViewRowAnimationAutomatic];
	}];
}

- (void)saveItemToShoppingList:(NSString*)itemName withCategory:(NSString*)category
{
	NSDictionary *attributes = @{FRESHLY_ITEM_ATTRIBUTE_NAME: itemName.capitalizedString,
								 FRESHLY_ITEM_ATTRIBUTE_CATEGORY: category,
								 FRESHLY_ITEM_ATTRIBUTE_SPACE: [NSNumber numberWithInteger:0],
								 FRESHLY_ITEM_ATTRIBUTE_IN_STORAGE: [NSNumber numberWithBool:NO],
								 FRESHLY_ITEM_ATTRIBUTE_BRAND: @"",
								 FRESHLY_ITEM_ATTRIBUTE_PURCHASE_DATE: [NSDate date],
								 FRESHLY_ITEM_ATTRIBUTE_EXPIRATION_DATE: [NSDate date]};
	
	[[FreshlyFoodItemService sharedInstance] createItemWithAttributes:attributes];
}

- (void)moveSelectedItemsToStorage
{
	NSArray *checkedItemsCopy = [NSArray arrayWithArray:[self.checkedItems copy]];
	for (FreshlyFoodItem *item in checkedItemsCopy) {
		item.inStorage = [NSNumber numberWithBool:YES];
		[[FreshlyFoodItemService sharedInstance] updateItem:item];
	}
	[self.checkedItems removeAllObjects];
}

#pragma mark - Actions

- (void)beginAddNewItem
{
	[self.view addSubview:self.darkBackground];
	[self.view addSubview:self.addNewItemView];
	[self.view bringSubviewToFront:self.autoCompletionViewController.view];
	[self.addNewItemTextField becomeFirstResponder];
	
	CGRect addNewItemFrame = self.addNewItemView.frame;
	addNewItemFrame.origin.y = 10;
	self.addNewItemView.frame = addNewItemFrame;
	
	[UIView animateWithDuration:0.25 animations:^{
		self.darkBackground.alpha = 0.5;
		self.addNewItemView.alpha = 1.0;
		[self updateAddNewItemLayout];
	}];
}

- (void)dismissInput
{
	[self.addNewItemTextField resignFirstResponder];
	
	[UIView animateWithDuration:0.25 animations:^{
		self.darkBackground.alpha = 0.0;
		self.addNewItemView.alpha = 0.0;
		self.addNewItemView.frame = CGRectMake(0, 10, self.view.frame.size.width, 50);
		
		if ([self.autoCompletionViewController.view isDescendantOfView:self.view]) {
			self.autoCompletionViewController.view.alpha = 0.0;
		}
		
	} completion:^(BOOL finished) {
		[self.darkBackground removeFromSuperview];
		[self.addNewItemView removeFromSuperview];
		self.addNewItemTextField.text = @"";
		[self updateAddNewItemLayout];
	}];
}

#pragma mark - TextField Methods

- (void)textFieldDidChange
{
	[self.autoCompletionViewController setPrefix:self.addNewItemTextField.text.lowercaseString];
}

#pragma mark - TableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.items.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	FreshlyFoodItem *item = self.items[indexPath.row];
	FreshlyShoppingListTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:TABLE_VIEW_CELL_SHOPPING_LIST_IDENTIFIER];
	
	if (!cell) {
		cell = [[FreshlyShoppingListTableViewCell alloc] initWithItem:item];
		cell.delegate = self;
	} else {
		[cell setItem:item];
		cell.checked = [self.checkedItems containsObject:item];
	}
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	return cell;
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		[[FreshlyFoodItemService sharedInstance] deleteItem:self.items[indexPath.row]];
	}
}

#pragma mark - ShoppingListCell Delegate

- (void)shoppingListCell:(FreshlyShoppingListTableViewCell *)cell didChangeCheckboxValue:(BOOL)value
{
	NSIndexPath *cellIndex = [self.tableView indexPathForCell:cell];
	__weak FreshlyFoodItem *changedItem = self.items[cellIndex.row];

	if (value) {
		[self.checkedItems addObject:changedItem];
	} else {
		[self.checkedItems removeObject:changedItem];
	}
}

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if (![self.autoCompletionViewController containsItem:self.addNewItemTextField.text]) {
		[self saveItemToShoppingList:textField.text withCategory:FRESHLY_CATEGORY_MISC];
		[self dismissInput];
	}
	return YES;
}

#pragma mark - AutoCompletion Delegate

- (void)didSelectAutoCompletedItem:(NSString *)item withCategory:(NSString *)category
{
	[self saveItemToShoppingList:item withCategory:category];
	[self dismissInput];
}

@end
