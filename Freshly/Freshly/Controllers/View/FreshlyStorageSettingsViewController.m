//
//  FreshlyStorageSettingsViewController.m
//  Freshly
//
//  Created by Andrew Dempsey on 8/24/14.
//  Copyright (c) 2014 Andrew Dempsey. All rights reserved.
//

#import "FreshlyStorageSettingsViewController.h"
#import "FreshlySettingsService.h"

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

@end

@implementation FreshlyStorageSettingsViewController

- (instancetype)init
{
	if (self = [super initWithStyle:UITableViewStyleGrouped]) {
		self.selectedSortingSetting = [[FreshlySettingsService sharedInstance] storageSorting];
	}
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.navigationItem.title = @"Storage Settings";
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
																				target:self
																				action:@selector(dismissSettings)];
	self.navigationItem.rightBarButtonItem = doneButton;
}

- (void)dismissSettings
{
	[self dismissViewControllerAnimated:YES completion:^{
		[[FreshlySettingsService sharedInstance] setStorageSorting:self.selectedSortingSetting];
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
    cell.textLabel.text = [self titleForCellAtIndexPath:indexPath];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;

	if (indexPath.section == FreshlyStorageSettingsSectionSorting && indexPath.row == self.selectedSortingSetting) {
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
		default:
			break;
	}

	[self.tableView deselectRowAtIndexPath:indexPath animated:NO];
	[self.tableView reloadData];
}

@end
