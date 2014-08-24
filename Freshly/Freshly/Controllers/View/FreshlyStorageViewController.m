//
//  FreshlyStorageViewController.m
//  Freshly
//
//  Created by Andrew Dempsey on 7/29/14.
//  Copyright (c) 2014 Andrew Dempsey. All rights reserved.
//

#import "FreshlyStorageViewController.h"
#import "FreshlyStorageTableViewCell.h"
#import "FreshlyFoodItemService.h"
#import "FreshlyFoodItem.h"
#import "FreshlyItemViewController.h"
#import "FreshlySettingsService.h"

#import "FreshlyItemViewController+NewItem.h"

@interface FreshlyStorageViewController ()

@property (nonatomic, readwrite, strong) NSArray *items;
@property (nonatomic, readwrite, strong) UITableView *tableView;

@property (nonatomic, readwrite, assign) NSInteger sortingAttribute;

@end

@implementation FreshlyStorageViewController

typedef NS_ENUM(NSInteger, FreshlyItemSortingCategories) {
	FreshlyItemSortingCategoryName = 0,
	FreshlyItemSortingCategoryPurchaseDate,
	FreshlyItemSortingCategoryExpirationDate
};

- (id)init
{
    self = [super init];
    if (self) {
		self.title = FRESHLY_SECTION_STORAGE;
		
		self.items = [[NSArray alloc] init];
		[[FreshlyFoodItemService sharedInstance] retrieveItemsForStorageWithBlock:^(NSArray *items) {
			self.items = items;
		}];
		
		self.tableView = [[UITableView alloc] init];
		self.tableView.delegate = self;
		self.tableView.dataSource = self;
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveItemUpdateNotification:) name:NOTIFICATION_ITEM_UPDATED object:nil];
		
		self.sortingAttribute = [[FreshlySettingsService sharedInstance] storageSorting];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.tableView.frame = self.view.frame;
	[self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 80, 0, 0)];
	[self sortItemsInTableView];
	[self.view addSubview:self.tableView];
	
	NSString *unicodeGear = @"\u2699";
	UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithTitle:unicodeGear style:UIBarButtonItemStylePlain target:self action:@selector(presentSettingsActionSheet)];
	self.navigationItem.leftBarButtonItem = settingsButton;

	UIBarButtonItem *addNewItemButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(presentNewItemView)];
	self.navigationItem.rightBarButtonItem = addNewItemButton;
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[[FreshlySettingsService sharedInstance] setSelectedSection:0];
}

- (void)didReceiveItemUpdateNotification:(NSNotification*)notification
{
	[self reloadAllTableViewSections];
}

- (void)presentNewItemView
{
	FreshlyItemViewController *newItemViewController = [[FreshlyItemViewController alloc] initWithItem:nil];
	UINavigationController *newItemNavigationController = [[UINavigationController alloc] initWithRootViewController:newItemViewController];

	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
																	 style:UIBarButtonItemStylePlain
																	target:newItemViewController
																	action:@selector(cancelNewItemCreation)];
	
	newItemViewController.navigationItem.leftBarButtonItem = cancelButton;

	[self presentViewController:newItemNavigationController animated:YES completion:nil];
}

- (void)presentSettingsActionSheet
{
	UIActionSheet *settingsActionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose an attribute to sort items by"
																	 delegate:self
															cancelButtonTitle:@"Done"
													   destructiveButtonTitle:nil
															otherButtonTitles:@"Name", @"Purchase Date", @"Expiration Date", nil];
	[settingsActionSheet showInView:self.view];
}

- (void)sortItemsInTableView
{
	NSString *sortingDescriptorKey = nil;
	BOOL ascending = YES;
	
	switch (self.sortingAttribute) {
		case FreshlyItemSortingCategoryName:
			sortingDescriptorKey = FRESHLY_ITEM_ATTRIBUTE_NAME;
			break;
		case FreshlyItemSortingCategoryPurchaseDate:
			sortingDescriptorKey = FRESHLY_ITEM_ATTRIBUTE_PURCHASE_DATE;
			ascending = NO;
			break;
		case FreshlyItemSortingCategoryExpirationDate:
			sortingDescriptorKey = FRESHLY_ITEM_ATTRIBUTE_EXPIRATION_DATE;
			ascending = NO;
			break;
		default:
			break;
	}
	
	NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:sortingDescriptorKey ascending:ascending];
	self.items = [self.items sortedArrayUsingDescriptors:@[sortDescriptor]];
}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	self.sortingAttribute = buttonIndex;
	[[FreshlySettingsService sharedInstance] setStorageSorting:buttonIndex];
	[self sortItemsInTableView];
	[self reloadAllTableViewSections];
}

#pragma mark - TableView methods

- (void)reloadAllTableViewSections
{
	[[FreshlyFoodItemService sharedInstance] retrieveItemsForStorageWithBlock:^(NSArray *items) {
		self.items = items;
		[self sortItemsInTableView];
		NSRange sectionRange = NSMakeRange(0, self.tableView.numberOfSections);
		NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:sectionRange];
		[self.tableView reloadSections:sections withRowAnimation:UITableViewRowAnimationAutomatic];
	}];
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
	FreshlyStorageTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:TABLE_VIEW_CELL_STORAGE_IDENTIFIER];
	
	if (!cell) {
		cell = [[FreshlyStorageTableViewCell alloc] initWithItem:item];
	} else {
		[cell setItem:item];
	}
	
	return cell;
}

#pragma mark - TableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 70.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	FreshlyFoodItem *item = self.items[indexPath.row];
	FreshlyItemViewController *itemViewController = [[FreshlyItemViewController alloc] initWithItem:item];
	[self.navigationController pushViewController:itemViewController animated:YES];
	
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		[[FreshlyFoodItemService sharedInstance] deleteItem:self.items[indexPath.row]];
	}
}

@end
