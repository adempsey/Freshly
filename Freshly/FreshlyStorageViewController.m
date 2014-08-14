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
#import "NSDate+FreshlyAdditions.h"
#import "UIImage+FreshlyAdditions.h"
#import "FreshlyItemViewController.h"

#define kStorageTableViewCellIdentifier @"StorageTableViewCell"

@interface FreshlyStorageViewController ()

@property (nonatomic, readwrite, strong) NSArray *items;
@property (nonatomic, readwrite, strong) UITableView *tableView;

@end

@implementation FreshlyStorageViewController

- (id)init
{
    self = [super init];
    if (self) {
		self.title = FRESHLY_SPACE_STORAGE;
		
		self.items = [[NSArray alloc] initWithArray:[[FreshlyFoodItemService sharedInstance] retrieveItemsForStorage]];
		
		self.tableView = [[UITableView alloc] init];
		self.tableView.delegate = self;
		self.tableView.dataSource = self;
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveItemUpdateNotification:) name:NOTIFICATION_ITEM_UPDATED object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	CGRect tableViewFrame = self.view.frame;
	self.tableView.frame = tableViewFrame;
	[self.view addSubview:self.tableView];
}

- (void)didReceiveItemUpdateNotification:(NSNotification*)notification
{
	[self reloadAllTableViewSections];
}

- (void)reloadAllTableViewSections
{
	NSRange sectionRange = NSMakeRange(0, self.tableView.numberOfSections);
	NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:sectionRange];
	[self.tableView reloadSections:sections withRowAnimation:UITableViewRowAnimationAutomatic];
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
	FreshlyStorageTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kStorageTableViewCellIdentifier];
	
	if (!cell) {
		cell = [[FreshlyStorageTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kStorageTableViewCellIdentifier];
	}
	
	FreshlyFoodItem *item = self.items[indexPath.row];
	
	cell.textLabel.text = item.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Purchased %@", item.dateOfPurchase.approximateDescription];
	cell.imageView.image = [UIImage imageForCategory:item.category withSize:50];
	
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

@end
