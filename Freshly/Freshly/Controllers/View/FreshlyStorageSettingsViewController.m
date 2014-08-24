//
//  FreshlyStorageSettingsViewController.m
//  Freshly
//
//  Created by Andrew Dempsey on 8/24/14.
//  Copyright (c) 2014 Andrew Dempsey. All rights reserved.
//

#import "FreshlyStorageSettingsViewController.h"
#import "FreshlySettingsService.h"

#import "UIFont+FreshlyAdditions.h"

typedef NS_ENUM(NSInteger, FreshlyStorageSettingsSections) {
	FreshlyStorageSettingsSectionSorting = 0,
	FreshlyStorageSettingsSectionGrouping,
	FreshlyStorageSettingsCount
};

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

@interface FreshlyStorageSettingsViewController ()

@property (nonatomic, readwrite, assign) NSInteger selectedSortingSetting;
@property (nonatomic, readwrite, assign) NSInteger selectedGroupingSetting;

@end

@implementation FreshlyStorageSettingsViewController

- (instancetype)init
{
	if (self = [super initWithStyle:UITableViewStyleGrouped]) {
		self.selectedSortingSetting = [[FreshlySettingsService sharedInstance] storageSorting];
		self.selectedGroupingSetting = [[FreshlySettingsService sharedInstance] storageGrouping];
	}
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.navigationItem.title = @"Storage Settings";
	
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
	titleLabel.text = @"Storage Settings";
	titleLabel.textColor = FRESHLY_COLOR_DARK;
	titleLabel.font = [UIFont boldFreshlyFontOfSize:18.0];
	titleLabel.textAlignment = NSTextAlignmentCenter;
	self.navigationItem.titleView = titleLabel;
	
	self.tableView.backgroundColor = FRESHLY_COLOR_PRIMARY;
	self.navigationController.navigationBar.tintColor = FRESHLY_COLOR_DARK;
	
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
																				target:self
																				action:@selector(dismissSettings)];
	self.navigationItem.rightBarButtonItem = doneButton;
}

- (void)dismissSettings
{
	[self dismissViewControllerAnimated:YES completion:^{
		[[FreshlySettingsService sharedInstance] setStorageSorting:self.selectedSortingSetting];
		[[FreshlySettingsService sharedInstance] setStorageGrouping:self.selectedGroupingSetting];
	}];
}

- (NSString*)titleForCellAtIndexPath:(NSIndexPath*)indexPath
{
	switch (indexPath.section) {
		case FreshlyStorageSettingsSectionSorting:
			switch (indexPath.row) {

				case FreshlyItemSortingCategoryName:
					return @"Name";
					break;

				case FreshlyItemSortingCategoryPurchaseDate:
					return @"Purchase Date";
					break;

				case FreshlyItemSortingCategoryExpirationDate:
					return @"Expiration Date";
					break;

				default:
					return @"";
					break;
			}
			break;

		case FreshlyStorageSettingsSectionGrouping:
			switch (indexPath.row) {

				case FreshlyItemGroupingAttributeAll:
					return @"None";
					break;

				case FreshlyItemGroupingAttributeCategory:
					return @"Food Group";
					break;

				case FreshlyItemGroupingAttributeSpace:
					return @"Storage Space";
					break;

				default:
					return @"";
					break;
			}

		default:
			return @"";
			break;
	}
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return FreshlyStorageSettingsCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	switch (section) {
		case FreshlyStorageSettingsSectionSorting:
			return FreshlyItemSortingCategoryCount;
			break;
		case FreshlyStorageSettingsSectionGrouping:
			return FreshlyItemGroupingAttributeCount;
		default:
			return 0;
			break;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [[UITableViewCell alloc] init];
	
	cell.backgroundColor = FRESHLY_COLOR_LIGHT;
	
    cell.textLabel.text = [self titleForCellAtIndexPath:indexPath];
	cell.textLabel.font = [UIFont freshlyFontOfSize:18.0];
	cell.textLabel.textColor = FRESHLY_COLOR_DARK;
	
	cell.tintColor = FRESHLY_COLOR_SELECTED;
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;

	if ((indexPath.section == FreshlyStorageSettingsSectionSorting && indexPath.row == self.selectedSortingSetting) ||
		(indexPath.section == FreshlyStorageSettingsSectionGrouping && indexPath.row == self.selectedGroupingSetting)) {

		cell.accessoryType = UITableViewCellAccessoryCheckmark;

	} else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}

    return cell;
}

#pragma mark - Table view delegate

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	switch (section) {
		case FreshlyStorageSettingsSectionSorting:
			return @"Sort items by";
			break;
		case FreshlyStorageSettingsSectionGrouping:
			return @"Group items by";
			break;
		default:
			return @"";
			break;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch (indexPath.section) {
		case FreshlyStorageSettingsSectionSorting:
			self.selectedSortingSetting = indexPath.row;
			break;
		case FreshlyStorageSettingsSectionGrouping:
			self.selectedGroupingSetting = indexPath.row;
			break;
		default:
			break;
	}

	[self.tableView deselectRowAtIndexPath:indexPath animated:NO];
	[self.tableView reloadData];
}

@end
