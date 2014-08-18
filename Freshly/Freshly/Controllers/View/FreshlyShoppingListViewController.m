//
//  FreshlyShoppingListViewController.m
//  Freshly
//
//  Created by Andrew Dempsey on 7/29/14.
//  Copyright (c) 2014 Andrew Dempsey. All rights reserved.
//

#import "FreshlyShoppingListViewController.h"
#import "FreshlyFoodItemService.h"
#import "FreshlyShoppingListTableViewCell.h"

@interface FreshlyShoppingListViewController ()

@property (nonatomic, readwrite, strong) NSArray *items;
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
	
	self.autoCompletionViewController.view.alpha = 0.0;
	self.autoCompletionViewController.delegate = self;
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
	NSDictionary *attributes = @{@"name": itemName.capitalizedString,
								 @"category": category,
								 @"space": [NSNumber numberWithInteger:0],
								 @"inStorage": [NSNumber numberWithBool:NO],
								 @"brand": @"",
								 @"dateOfPurchase": [NSDate date],
								 @"dateOfExpiration": [NSDate date]};
	
	[[FreshlyFoodItemService sharedInstance] createItemWithAttributes:attributes];
}

#pragma mark - Actions

- (void)beginAddNewItem
{
	[self.view addSubview:self.darkBackground];
	[self.view addSubview:self.addNewItemView];
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
		[self.autoCompletionViewController.view removeFromSuperview];
		self.addNewItemTextField.text = @"";
	}];
}

#pragma mark - TextField Methods

- (void)textFieldDidChange
{
	[self.autoCompletionViewController setPrefix:self.addNewItemTextField.text.lowercaseString];
	
	if (self.addNewItemTextField.text.length > 0) {
		if (![self.autoCompletionViewController.view isDescendantOfView:self.view]) {
			[self.view addSubview:self.autoCompletionViewController.view];
			
			[UIView animateWithDuration:0.25 animations:^{
				self.autoCompletionViewController.view.alpha = 1.0;
			}];
		}
	} else {
		[UIView animateWithDuration:0.25 animations:^{
			self.autoCompletionViewController.view.alpha = 0.0;
		} completion:^(BOOL finished) {
			[self.autoCompletionViewController.view removeFromSuperview];
		}];
	}
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
	} else {
		[cell setItem:item];
	}
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	return cell;
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

@end
