//
//  FreshlyStorageViewController.m
//  Freshly
//
//  Created by Andrew Dempsey on 7/29/14.
//  Copyright (c) 2014 Andrew Dempsey. All rights reserved.
//

#import "FreshlyStorageViewController.h"
#import "FreshlyStorageTableViewCell.h"

#define kStorageTableViewCellIdentifier @"StorageTableViewCell"

@interface FreshlyStorageViewController ()

@property (nonatomic, readwrite, strong) UITableView *tableView;

@end

@implementation FreshlyStorageViewController

- (id)init
{
    self = [super init];
    if (self) {
		self.title = FRESHLY_SPACE_STORAGE;
		
		self.tableView = [[UITableView alloc] init];
		self.tableView.delegate = self;
		self.tableView.dataSource = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	CGRect tableViewFrame = self.view.frame;
	self.view.backgroundColor = [UIColor greenColor];
	tableViewFrame.origin.y += 64.0;
	tableViewFrame.size.height -= 112.0;
	self.tableView.backgroundColor = [UIColor redColor];
	self.tableView.frame = tableViewFrame;
	[self.view addSubview:self.tableView];
}

#pragma mark - TableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	FreshlyStorageTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kStorageTableViewCellIdentifier];
	
	if (!cell) {
		cell = [[FreshlyStorageTableViewCell alloc] init];
	}
	cell.textLabel.text = @"h";
	
	return cell;
}

#pragma mark - TableView Delegate

@end
