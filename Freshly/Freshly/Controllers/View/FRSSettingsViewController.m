//
//  FreshlyStorageSettingsViewController.m
//  Freshly
//
//  Created by Andrew Dempsey on 8/24/14.
//  Copyright (c) 2014 Andrew Dempsey. All rights reserved.
//

#import "FRSSettingsViewController.h"
#import "FRSSettingsService.h"
#import "FRSAboutViewController.h"

#import "UIFont+FreshlyAdditions.h"
#import "UIColor+FreshlyAdditions.h"

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

@interface FRSSettingsViewController ()

@property (nonatomic, readwrite, assign) NSInteger selectedSortingSetting;
@property (nonatomic, readwrite, assign) NSInteger selectedGroupingSetting;

@end

@implementation FRSSettingsViewController

- (instancetype)init
{
	if (self = [super initWithStyle:UITableViewStyleGrouped]) {
		self.selectedSortingSetting = [[FRSSettingsService sharedInstance] storageSorting];
		self.selectedGroupingSetting = [[FRSSettingsService sharedInstance] storageGrouping];
	}
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];


    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLabel.text = @"Settings";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldFreshlyFontOfSize:18.0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;

	self.tableView.backgroundColor = [UIColor freshly_backgroundColor];
	
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
																				target:self
																				action:@selector(dismissSettings)];
	self.navigationItem.leftBarButtonItem = doneButton;
}

- (void)dismissSettings
{
	[self dismissViewControllerAnimated:YES completion:^{
		[[FRSSettingsService sharedInstance] setStorageSorting:self.selectedSortingSetting];
		[[FRSSettingsService sharedInstance] setStorageGrouping:self.selectedGroupingSetting];
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
	
	cell.backgroundColor = [UIColor freshly_whiteColor];
	
    cell.textLabel.text = [self titleForCellAtIndexPath:indexPath];
	cell.textLabel.font = [UIFont freshlyFontOfSize:18.0];
	cell.textLabel.textColor = [UIColor freshly_darkGrayColor];
	cell.tintColor = [UIColor freshly_primaryGreen];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.accessoryType = [self accessoryTypeForCellAtIndexPath:indexPath];
	
	if (indexPath.section == FreshlyStorageSettingsSectionOptions) {
		cell.accessoryView = [self switchForCellAtIndexPath:indexPath];
	}

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView
willDisplayHeaderView:(UIView *)view
       forSection:(NSInteger)section
{
    if ([view isKindOfClass:[UITableViewHeaderFooterView class]]) {
        UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
        header.textLabel.font = [UIFont freshlyFontOfSize:[UIFont systemFontSize]];
        header.textLabel.textColor = [UIColor freshly_darkGrayColor];
        header.textLabel.text = header.textLabel.text.capitalizedString;
    }
}

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
			FRSAboutViewController *aboutViewController = [[FRSAboutViewController alloc] init];
			[self.navigationController pushViewController:aboutViewController animated:YES];
			break;
		}
		default:
			break;
	}

	[self.tableView deselectRowAtIndexPath:indexPath animated:NO];
	[self.tableView reloadData];
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
			cellSwitch.on = [[FRSSettingsService sharedInstance] showPurchaseDate];
			cellSwitch.tag = FreshlyOptionShowPurchaseDate;

		} else if (indexPath.row == FreshlyOptionShowExpirationDate) {
			cellSwitch.on = [[FRSSettingsService sharedInstance] showExpirationDate];
			cellSwitch.tag = FreshlyOptionShowExpirationDate;

		} else if (indexPath.row == FreshlyOptionShowStorageLocation) {
			cellSwitch.on = [[FRSSettingsService sharedInstance] showStorageLocation];
			cellSwitch.tag = FreshlyOptionShowStorageLocation;
		}

		cellSwitch.onTintColor = [UIColor freshly_primaryGreen];
		[cellSwitch addTarget:self
                       action:@selector(didToggleSwitch:)
             forControlEvents:UIControlEventValueChanged];

		return cellSwitch;
	}
	return nil;
}

- (void)didToggleSwitch:(id)sender
{
	if ([sender isKindOfClass:[UISwitch class]]) {
		UISwitch *cellSwitch = (UISwitch*)sender;

		if (cellSwitch.tag == FreshlyOptionShowPurchaseDate) {
			[[FRSSettingsService sharedInstance] setShowPurchaseDate:cellSwitch.on];

		} else if (cellSwitch.tag == FreshlyOptionShowExpirationDate) {
			[[FRSSettingsService sharedInstance] setShowExpirationDate:cellSwitch.on];

		} else if (cellSwitch.tag == FreshlyOptionShowStorageLocation) {
			[[FRSSettingsService sharedInstance] setShowStorageLocation:cellSwitch.on];
		}
	}
}

@end
