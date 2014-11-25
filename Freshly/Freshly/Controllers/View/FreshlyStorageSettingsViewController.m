//
//  FreshlyStorageSettingsViewController.m
//  Freshly
//
//  Created by Andrew Dempsey on 8/24/14.
//  Copyright (c) 2014 Andrew Dempsey. All rights reserved.
//

#import "FreshlyStorageSettingsViewController.h"
#import "FreshlySettingsService.h"
#import "FreshlyAboutViewController.h"

#import "UIFont+FreshlyAdditions.h"

typedef NS_ENUM(NSInteger, FreshlyStorageSettingsSections) {
	FreshlyStorageSettingsSectionSorting = 0,
	FreshlyStorageSettingsSectionGrouping,
	FreshlyStorageSettingsSectionOptions,
	FreshlyStorageSettingsSectionAbout,
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

typedef NS_ENUM(NSInteger, FreshlyItemDatePreferences) {
	FreshlyOptionShowPurchaseDate = 0,
	FreshlyOptionShowExpirationDate,
	FreshlyOptionShowStorageLocation,
	FreshlyOptionCount
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
		case FreshlyStorageSettingsSectionOptions:
			return FreshlyOptionCount;
		case FreshlyStorageSettingsSectionAbout:
			return 1;
			break;
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
	cell.accessoryType = [self accessoryTypeForCellAtIndexPath:indexPath];
	
	if (indexPath.section == FreshlyStorageSettingsSectionOptions) {
		cell.accessoryView = [self switchForCellAtIndexPath:indexPath];
	}

    return cell;
}

#pragma mark - Table view delegate

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	switch (section) {
		case FreshlyStorageSettingsSectionSorting:
			return @"Sort items by...";
			break;
		case FreshlyStorageSettingsSectionGrouping:
			return @"Group items by...";
			break;
		case FreshlyStorageSettingsSectionOptions:
			return @"Item Options";
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
		case FreshlyStorageSettingsSectionAbout: {
			FreshlyAboutViewController *aboutViewController = [[FreshlyAboutViewController alloc] init];
			[self.navigationController pushViewController:aboutViewController animated:YES];
			break;
		}
		default:
			break;
	}

	[self.tableView deselectRowAtIndexPath:indexPath animated:NO];
	[self.tableView reloadData];
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIView *view = [[UIView alloc] init];
	view.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, 50.0);

	UILabel *titleLabel = [[UILabel alloc] init];
	CGFloat originY = section == 0 ? view.frame.size.height - 20.0 - 10.0 : view.frame.size.height - 50.0;
	titleLabel.frame = CGRectMake(16.0, originY, 200.0, 20.0);
	titleLabel.font = [UIFont freshlyFontOfSize:18.0];
	titleLabel.text = [self tableView:tableView titleForHeaderInSection:section];
	titleLabel.textColor = FRESHLY_COLOR_DARK;
	[view addSubview:titleLabel];

	return view;
}

#pragma mark - Extra table view methods

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
			break;

		case FreshlyStorageSettingsSectionOptions:
			switch (indexPath.row) {

				case FreshlyOptionShowPurchaseDate:
					return @"Show Purchase Dates";
					break;

				case FreshlyOptionShowExpirationDate:
					return @"Show Expiration Dates";
					break;

				case FreshlyOptionShowStorageLocation:
					return @"Show Storage Location";
					break;

				default:
					return @"";
					break;
			}
			break;

		case FreshlyStorageSettingsSectionAbout:
			return @"About";
			break;

		default:
			return @"";
			break;
	}
}

- (UITableViewCellAccessoryType)accessoryTypeForCellAtIndexPath:(NSIndexPath *)indexPath
{
	switch (indexPath.section) {
		case FreshlyStorageSettingsSectionGrouping:
			if (indexPath.row == self.selectedGroupingSetting) {
				return UITableViewCellAccessoryCheckmark;
			}
			break;
		case FreshlyStorageSettingsSectionSorting: {
			if (indexPath.row == self.selectedSortingSetting) {
				return UITableViewCellAccessoryCheckmark;
			}
			break;
		}
		case FreshlyStorageSettingsSectionAbout:
			return UITableViewCellAccessoryDisclosureIndicator;
			break;
	}
	return UITableViewCellAccessoryNone;
}

- (UISwitch*)switchForCellAtIndexPath:(NSIndexPath*)indexPath
{
	if (indexPath.section == FreshlyStorageSettingsSectionOptions) {
		UISwitch *cellSwitch = [[UISwitch alloc] init];

		if (indexPath.row == FreshlyOptionShowPurchaseDate) {
			cellSwitch.on = [[FreshlySettingsService sharedInstance] showPurchaseDate];
			cellSwitch.tag = FreshlyOptionShowPurchaseDate;

		} else if (indexPath.row == FreshlyOptionShowExpirationDate) {
			cellSwitch.on = [[FreshlySettingsService sharedInstance] showExpirationDate];
			cellSwitch.tag = FreshlyOptionShowExpirationDate;

		} else if (indexPath.row == FreshlyOptionShowStorageLocation) {
			cellSwitch.on = [[FreshlySettingsService sharedInstance] showStorageLocation];
			cellSwitch.tag = FreshlyOptionShowStorageLocation;
		}

		cellSwitch.onTintColor = FRESHLY_COLOR_SELECTED;
		[cellSwitch addTarget:self action:@selector(didToggleSwitch:) forControlEvents:UIControlEventValueChanged];

		return cellSwitch;
	}
	return nil;
}

- (void)didToggleSwitch:(id)sender
{
	if ([sender isKindOfClass:[UISwitch class]]) {
		UISwitch *cellSwitch = (UISwitch*)sender;

		if (cellSwitch.tag == FreshlyOptionShowPurchaseDate) {
			[[FreshlySettingsService sharedInstance] setShowPurchaseDate:cellSwitch.on];

		} else if (cellSwitch.tag == FreshlyOptionShowExpirationDate) {
			[[FreshlySettingsService sharedInstance] setShowExpirationDate:cellSwitch.on];

		} else if (cellSwitch.tag == FreshlyOptionShowStorageLocation) {
			[[FreshlySettingsService sharedInstance] setShowStorageLocation:cellSwitch.on];
		}
	}
}

@end
