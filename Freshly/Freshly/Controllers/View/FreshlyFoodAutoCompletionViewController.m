//
//  FreshlyFoodAutoCompletionViewController.m
//  Freshly
//
//  Created by Andrew Dempsey on 8/16/14.
//  Copyright (c) 2014 Andrew Dempsey. All rights reserved.
//

#import "FreshlyFoodAutoCompletionViewController.h"
#import "FreshlyFoodAutoCompletionService.h"
#import "FreshlyAutoCompletionTableViewCell.h"
#import "FreshlyFoodItemService.h"

@interface FreshlyFoodAutoCompletionViewController ()

@property (nonatomic, readwrite, strong) UITableView *tableView;
@property (nonatomic, readwrite, strong) NSArray *items;

@end

@implementation FreshlyFoodAutoCompletionViewController

- (instancetype)init
{
	if (self = [super init]) {
		self.tableView = [[UITableView alloc] init];
	}
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	CGRect screenBounds = [UIScreen mainScreen].bounds;
	self.view.frame = CGRectMake(0, 200, screenBounds.size.width, 152);
	self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	[self.view addSubview:self.tableView];
}

- (void)setPrefix:(NSString *)prefix
{
	_prefix = prefix;
	
	if (prefix.length > 0) {
		self.items = [[FreshlyFoodAutoCompletionService sharedInstance] itemsWithPrefix:prefix];
		[self.tableView reloadData];
	}
}

#pragma mark - TableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.items.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *title = self.items[indexPath.row];
	return [[FreshlyAutoCompletionTableViewCell alloc] initWithName:title];
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	NSString *itemName = self.items[indexPath.row];
	[self.delegate didSelectAutoCompletedItem:itemName withCategory:[[FreshlyFoodItemService sharedInstance] categoryForFoodItemName:itemName]];
}

@end
