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
#import "UIFont+FreshlyAdditions.h"
#import "UIColor+FreshlyAdditions.h"

@interface FreshlyStorageViewController ()

@property (nonatomic, readwrite, strong) NSArray *items;
@property (nonatomic, readwrite, strong) NSArray *sectionTitles;
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

//        self.navigationItem.title = @"Storage";
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        titleLabel.text = FRESHLY_SECTION_STORAGE;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont boldFreshlyFontOfSize:18.0];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        self.navigationItem.titleView = titleLabel;

		self.sortingAttribute = [[FreshlySettingsService sharedInstance] storageSorting];
		self.groupingAttribute = [[FreshlySettingsService sharedInstance] storageGrouping];

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
	
	self.tableView.backgroundColor = [UIColor freshly_backgroundColor];

	self.tableView.frame = self.view.frame;
	[self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 80, 0, 0)];
	[self sortItemsInTableView];
	[self.view addSubview:self.tableView];

    UIImage *image = [UIImage imageNamed:@"icon-gear"];
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithImage:image
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(presentSettingsView)];
	self.navigationItem.leftBarButtonItem = settingsButton;

	UIBarButtonItem *addNewItemButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(presentNewItemView)];
	self.navigationItem.rightBarButtonItem = addNewItemButton;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	self.tableView.frame = self.view.frame;
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[[FreshlySettingsService sharedInstance] setSelectedSection:0];
}

- (BOOL)shouldAutorotate
{
	return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	CGRect screenBounds = [[UIScreen mainScreen] bounds];
	CGRect newScreenBounds = CGRectMake(screenBounds.origin.x, screenBounds.origin.y, screenBounds.size.height, screenBounds.size.width);
	self.view.frame = newScreenBounds;
	self.tableView.frame = self.view.frame;
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
		NSMutableArray *nonEmptyCategoryTitles = [[NSMutableArray alloc] init];

		for (NSString *category in categories) {
			NSPredicate *categoryPredicate = [NSPredicate predicateWithFormat:@"(self.category == %@)", category];
			NSArray *filteredArray = [items filteredArrayUsingPredicate:categoryPredicate];

			if (filteredArray.count > 0) {
				[categorySectionItems addObject:filteredArray];
				[nonEmptyCategoryTitles addObject:category];
			}
		}

		_items = categorySectionItems;
		self.sectionTitles = nonEmptyCategoryTitles;

	} else if (self.groupingAttribute == FreshlyItemGroupingAttributeSpace) {
		NSMutableArray *spaceSectionItems = [[NSMutableArray alloc] init];
		NSMutableArray *nonEmptySectionTitles = [[NSMutableArray alloc] init];

		for (NSInteger space = FreshlySpaceRefrigerator; space < FreshlySpaceCount; ++space) {
			NSPredicate *spacePredicate = [NSPredicate predicateWithFormat:@"(self.space == %@)", [NSNumber numberWithInteger:space]];
			NSArray *filteredArray = [items filteredArrayUsingPredicate:spacePredicate];

			if (filteredArray.count > 0) {
				[spaceSectionItems addObject:filteredArray];
				NSString *spaceTitle = [[FreshlyFoodItemService sharedInstance] titleForSpaceIndex:space];
				[nonEmptySectionTitles addObject:spaceTitle];
			}
		}

		_items = spaceSectionItems;
		self.sectionTitles = nonEmptySectionTitles;
	}
}

- (void)presentNewItemView
{
	FreshlyItemViewController *newItemViewController = [[FreshlyItemViewController alloc] initWithItem:nil];
	UINavigationController *newItemNavigationController = [[UINavigationController alloc] initWithRootViewController:newItemViewController];

	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		newItemNavigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
		newItemNavigationController.modalPresentationStyle = UIModalPresentationFormSheet;
	}

	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
																	 style:UIBarButtonItemStylePlain
																	target:newItemViewController
																	action:@selector(cancelModalItemView)];
	
	newItemViewController.navigationItem.leftBarButtonItem = cancelButton;

	[self presentViewController:newItemNavigationController animated:YES completion:nil];
}

- (void)presentSettingsView
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
			ascending = YES;
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

#pragma mark - TableView methods

- (void)reloadAllTableViewSections
{
	[[FreshlyFoodItemService sharedInstance] retrieveItemsForStorageWithBlock:^(NSArray *items) {

		self.sortingAttribute = [[FreshlySettingsService sharedInstance] storageSorting];
		self.groupingAttribute = [[FreshlySettingsService sharedInstance] storageGrouping];

		self.items = items;
		[self sortItemsInTableView];
		NSRange sectionRange = NSMakeRange(0, self.tableView.numberOfSections);
		NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:sectionRange];

		if (self.tableView.numberOfSections == self.items.count) {
			[self.tableView reloadSections:sections withRowAnimation:UITableViewRowAnimationAutomatic];
		} else {
			[self.tableView reloadData];
		}
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

	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {

		UINavigationController *itemNavigationController = [[UINavigationController alloc] initWithRootViewController:itemViewController];
		itemNavigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
		itemNavigationController.modalPresentationStyle = UIModalPresentationFormSheet;

		UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Save"
																		 style:UIBarButtonItemStylePlain
																		target:itemViewController
																		action:@selector(cancelModalItemView)];
		itemViewController.navigationItem.rightBarButtonItem = cancelButton;

		[self presentViewController:itemNavigationController animated:YES completion:nil];

	} else {
		[self.navigationController pushViewController:itemViewController animated:YES];
	}

	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		[[FreshlyFoodItemService sharedInstance] deleteItem:self.items[indexPath.section][indexPath.row]];
	}
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIView *view = [[UIView alloc] init];
	view.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, 50.0);

	UILabel *titleLabel = [[UILabel alloc] init];
	CGFloat originY = section == 0 ? view.frame.size.height - 20.0 - 10.0 : view.frame.size.height - 50.0;
	titleLabel.frame = CGRectMake(16.0, originY, 100.0, 20.0);
	titleLabel.font = [UIFont freshlyFontOfSize:18.0];
	titleLabel.text = [self tableView:tableView titleForHeaderInSection:section];
	titleLabel.textColor = FRESHLY_COLOR_DARK;
	[view addSubview:titleLabel];

	return view;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (self.groupingAttribute == FreshlyItemGroupingAttributeAll) {
		return @"All Items";
	}

	return self.sectionTitles[section];
}

@end
