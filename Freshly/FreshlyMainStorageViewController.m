//
//  FreshlyStorageMainViewController.m
//  Freshly
//
//  Created by Andrew Dempsey on 7/24/14.
//  Copyright (c) 2014 Andrew Dempsey. All rights reserved.
//

#import "FreshlyMainStorageViewController.h"
#import "FreshlyStorageTabBarController.h"
#import "FreshlyStorageViewController.h"

@interface FreshlyMainStorageViewController ()

@property (nonatomic, readwrite, strong) FreshlyStorageTabBarController *tabBarController;

@end

@implementation FreshlyMainStorageViewController

- (id)init
{
	if (self = [super init]) {
		self.tabBarController = [[FreshlyStorageTabBarController alloc] init];
	}
	return self;
}

- (void)viewDidLoad
{
	self.tabBarController.viewControllers = [self createStorageViewControllers];	
	[self.view addSubview:self.tabBarController.view];
}

- (NSArray*)createStorageViewControllers
{
	FreshlyStorageViewController *refrigerator = [[FreshlyStorageViewController alloc] initWithTitle:@"Refrigerator"];
	FreshlyStorageViewController *freezer = [[FreshlyStorageViewController alloc] initWithTitle:@"Freezer"];
	FreshlyStorageViewController *pantry = [[FreshlyStorageViewController alloc] initWithTitle:@"Pantry"];
	
	return [NSArray arrayWithObjects:refrigerator, freezer, pantry, nil];
}

@end
