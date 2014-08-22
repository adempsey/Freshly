//
//  FreshlyShoppingListViewController.m
//  Freshly
//
//  Created by Andrew Dempsey on 7/29/14.
//  Copyright (c) 2014 Andrew Dempsey. All rights reserved.
//

#import "FreshlyShoppingListViewController.h"
#import "FreshlyFoodItemService.h"

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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.tableView.frame = self.view.frame;
	[self.view addSubview:self.tableView];
	
	self.addNewItemView.frame = CGRectMake(0, 10, self.view.frame.size.width, 50);
	self.addNewItemView.backgroundColor = [UIColor grayColor];
	self.addNewItemView.alpha = 0.0;
	
	self.addNewItemTextField.frame = CGRectMake(10, 15, self.view.frame.size.width - 20, 25);
	self.addNewItemTextField.placeholder = @"Add New Item";
	self.addNewItemTextField.backgroundColor = [UIColor whiteColor];
	self.addNewItemTextField.returnKeyType = UIReturnKeyDone;
	self.addNewItemTextField.autocorrectionType = UITextAutocorrectionTypeNo;
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

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[self moveSelectedItemsToStorage];
}

- (void)didReceiveItemUpdateNotification:(NSNotification*)notification
{
	[self reloadAllTableViewSections];
}

- (void)reloadAllTableViewSections
{
	[[FreshlyFoodItemService sharedInstance] retrieveItemsForShoppingListWithBlock:^(NSArray *items) {
		self.items = items;
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
	
	[UIView animateWithDuration:0.25 animations:^{
		self.darkBackground.alpha = 0.5;
		self.addNewItemView.alpha = 1.0;
		self.addNewItemView.frame = CGRectMake(0, 60, self.view.frame.size.width, 50);
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
	[self saveItemToShoppingList:textField.text withCategory:FRESHLY_CATEGORY_MISC];
	[self dismissInput];
	return YES;
}

#pragma mark - AutoCompletion Delegate

- (void)didSelectAutoCompletedItem:(NSString *)item withCategory:(NSString *)category
{
	[self saveItemToShoppingList:item withCategory:category];
	[self dismissInput];
}

- (CGFloat)heightForAutoCompletionTableView
{
	return 242.0;
}

@end
