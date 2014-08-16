//
//  FreshlyShoppingListViewController.m
//  Freshly
//
//  Created by Andrew Dempsey on 7/29/14.
//  Copyright (c) 2014 Andrew Dempsey. All rights reserved.
//

#import "FreshlyShoppingListViewController.h"
#import "FreshlyFoodItemService.h"
#import "FreshlyShoppingListTableViewCell.h"

@interface FreshlyShoppingListViewController ()

@property (nonatomic, readwrite, strong) NSArray *items;
@property (nonatomic, readwrite, strong) UITableView *tableView;

@end

@implementation FreshlyShoppingListViewController

- (id)init
{
    self = [super init];
    if (self) {
		self.title = FRESHLY_SECTION_SHOPPING_LIST;
		
		self.items = [[NSArray alloc] init];
		[[FreshlyFoodItemService sharedInstance] retrieveItemsForShoppingListWithBlock:^(NSArray *items) {
			self.items = items;
		}];
		
		self.tableView = [[UITableView alloc] init];
		self.tableView.delegate = self;
		self.tableView.dataSource = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.tableView.frame = self.view.frame;
	[self.view addSubview:self.tableView];
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
	FreshlyShoppingListTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:TABLE_VIEW_CELL_SHOPPING_LIST_IDENTIFIER];
	
	if (!cell) {
		cell = [[FreshlyShoppingListTableViewCell alloc] initWithItem:item];
	} else {
		[cell setItem:item];
	}
	
	return cell;
}

@end
