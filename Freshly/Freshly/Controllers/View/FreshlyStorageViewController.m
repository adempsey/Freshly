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

#import "FreshlyItemViewController+NewItem.h"

@interface FreshlyStorageViewController ()

@property (nonatomic, readwrite, strong) NSArray *items;
@property (nonatomic, readwrite, strong) UITableView *tableView;

@end

@implementation FreshlyStorageViewController

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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.tableView.frame = self.view.frame;
	[self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 80, 0, 0)];
	[self.view addSubview:self.tableView];

	UIBarButtonItem *addNewItemButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(presentNewItemView)];
	self.navigationItem.rightBarButtonItem = addNewItemButton;
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

#pragma mark - TableView methods

- (void)reloadAllTableViewSections
{
	[[FreshlyFoodItemService sharedInstance] retrieveItemsForStorageWithBlock:^(NSArray *items) {
		self.items = items;
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
