//
//  FreshlyMainViewController.m
//  Freshly
//
//  Created by Andrew Dempsey on 7/29/14.
//  Copyright (c) 2014 Andrew Dempsey. All rights reserved.
//

#import "FreshlyMainViewController.h"
#import "FreshlyStorageViewController.h"
#import "FreshlyShoppingListViewController.h"

@interface FreshlyMainViewController ()

@property (nonatomic, readwrite, strong) UITabBarController *tabBarController;
@property (nonatomic, readwrite, strong) FreshlyStorageViewController *storageViewController;
@property (nonatomic, readwrite, strong) FreshlyShoppingListViewController *shoppingListViewController;

@end

@implementation FreshlyMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.tabBarController = [[UITabBarController alloc] init];
		self.storageViewController = [[FreshlyStorageViewController alloc] init];
		self.shoppingListViewController = [[FreshlyShoppingListViewController alloc] init];
	}
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.tabBarController.viewControllers = [NSArray arrayWithObjects:self.storageViewController, self.shoppingListViewController, nil];
	[self.view addSubview:self.tabBarController.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
