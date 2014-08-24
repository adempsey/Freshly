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
#import "FreshlyStorageSettingsViewController.h"

#import "FreshlyItemViewController+NewItem.h"

@interface FreshlyStorageViewController ()

@property (nonatomic, readwrite, strong) NSArray *items;
@property (nonatomic, readwrite, strong) UITableView *tableView;

@property (nonatomic, readwrite, assign) NSInteger sortingAttribute;
@property (nonatomic, readwrite, assign) NSInteger groupingAttribute;

@end

@implementation FreshlyStorageViewController

typedef NS_ENUM(NSInteger, FreshlyItemSortingCategories) {
	FreshlyItemSortingCategoryName = 0,
	FreshlyItemSortingCategoryPurchaseDate,
	FreshlyItemSortingCategoryExpirationDate,
	FreshlyItemSortingCategoryCount
};

typedef NS_ENUM(NSInteger, FreshlyItemGroupingAttributes) {
	FreshlyItemGroupingAttributeAll = 0,
	FreshlyItemGroupingAttributeCategory,
	FreshlyItemGroupingAttributeSpace,
	FreshlyItemGroupingAttributeCount
};

- (id)init
{
    self = [super init];
    if (self) {
		self.title = FRESHLY_SECTION_STORAGE;

		self.sortingAttribute = [[FreshlySettingsService sharedInstance] storageSorting];
		self.groupingAttribute = FreshlyItemGroupingAttributeAll;

		[[FreshlyFoodItemService sharedInstance] retrieveItemsForStorageWithBlock:^(NSArray *items) {
			self.items = items;
		}];

		self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
		self.tableView.delegate = self;
		self.tableView.dataSource = self;
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAllTableViewSections) name:NOTIFICATION_ITEM_UPDATED object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAllTableViewSections) name:NOTIFICATION_STORAGE_SETTINGS_UPDATED object:nil];
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

- (void)setItems:(NSArray *)items
{
	if (!_items) {
		_items = [[NSArray alloc] init];
	}

	if (self.groupingAttribute == FreshlyItemGroupingAttributeAll) {
		_items = @[items];

	} else if (self.groupingAttribute == FreshlyItemGroupingAttributeCategory) {
		NSArray *categories = [[FreshlyFoodItemService sharedInstance] foodItemCategoryList];
		NSMutableArray *categorySectionItems = [[NSMutableArray alloc] init];

		for (NSString *category in categories) {
			NSPredicate *categoryPredicate = [NSPredicate predicateWithFormat:@"(self.category == %@)", category];
			NSArray *filteredArray = [items filteredArrayUsingPredicate:categoryPredicate];
			[categorySectionItems addObject:filteredArray];
		}

		_items = categorySectionItems;

	} else if (self.groupingAttribute == FreshlyItemGroupingAttributeSpace) {
		NSMutableArray *spaceSectionItems = [[NSMutableArray alloc] init];

		for (NSInteger space = FreshlySpaceRefrigerator; space < FreshlySpaceCount; ++space) {
			NSPredicate *spacePredicate = [NSPredicate predicateWithFormat:@"(self.space == %@)", [NSNumber numberWithInteger:space]];
			NSArray *filteredArray = [items filteredArrayUsingPredicate:spacePredicate];
			[spaceSectionItems addObject:filteredArray];
		}

		_items = spaceSectionItems;
	}
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
	FreshlyStorageSettingsViewController *settingsViewController = [[FreshlyStorageSettingsViewController alloc] init];
	UINavigationController *settingsNavigationController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
	[self presentViewController:settingsNavigationController animated:YES completion:nil];
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

	if (sortingDescriptorKey) {
		NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:sortingDescriptorKey ascending:ascending];
		NSMutableArray *newItems = [[NSMutableArray alloc] init];

		for (NSArray *array in self.items) {
			[newItems addObject:[array sortedArrayUsingDescriptors:@[sortDescriptor]]];
		}

		_items = newItems;
	}
}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex < FreshlyItemSortingCategoryCount) {
		self.sortingAttribute = buttonIndex;
		[[FreshlySettingsService sharedInstance] setStorageSorting:buttonIndex];
		[self sortItemsInTableView];
		[self reloadAllTableViewSections];
	}
}

#pragma mark - TableView methods

- (void)reloadAllTableViewSections
{
	[[FreshlyFoodItemService sharedInstance] retrieveItemsForStorageWithBlock:^(NSArray *items) {
		
		self.sortingAttribute = [[FreshlySettingsService sharedInstance] storageSorting];
		
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
	if (self.items[section]) {
		return ((NSArray*)self.items[section]).count;
	}
	return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return self.items.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	FreshlyFoodItem *item = self.items[indexPath.section][indexPath.row];
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
	FreshlyFoodItem *item = self.items[indexPath.section][indexPath.row];
	FreshlyItemViewController *itemViewController = [[FreshlyItemViewController alloc] initWithItem:item];
	[self.navigationController pushViewController:itemViewController animated:YES];
	
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		[[FreshlyFoodItemService sharedInstance] deleteItem:self.items[indexPath.section][indexPath.row]];
	}
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	switch (self.groupingAttribute) {
		case FreshlyItemGroupingAttributeAll:
			return @"All Items";
			break;
		case FreshlyItemGroupingAttributeCategory:
			return [[FreshlyFoodItemService sharedInstance] foodItemCategoryList][section];
			break;
		case FreshlyItemGroupingAttributeSpace:
			switch (section) {
				case FreshlySpaceRefrigerator:
					return FRESHLY_SPACE_REFRIGERATOR;
					break;
				case FreshlySpaceFreezer:
					return FRESHLY_SPACE_FREEZER;
					break;
				case FreshlySpacePantry:
					return FRESHLY_SPACE_PANTRY;
				default:
					return @"";
					break;
			}
			break;
		default:
			return @"";
			break;
	}
}

@end
