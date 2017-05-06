//
//  FreshlyTabBarController.m
//  Freshly
//
//  Created by Andrew Dempsey on 5/2/17.
//  Copyright © 2017 Andrew Dempsey. All rights reserved.
//

#import "FreshlyTabBarController.h"
#import "FreshlyStorageViewController.h"
#import "FreshlyShoppingListViewController.h"
#import "FreshlyNavigationController.h"

#import "UIColor+FreshlyAdditions.h"

NS_ASSUME_NONNULL_BEGIN

@interface FreshlyTabBarController ()

@property (nonatomic, readwrite, strong) FreshlyNavigationController *storageNavigationController;
@property (nonatomic, readwrite, strong) FreshlyNavigationController *shoppingListNavigationController;

@end

@implementation FreshlyTabBarController

#pragma mark - Lazy Properties

- (FreshlyNavigationController *)storageNavigationController
{
    if (_storageNavigationController == nil) {
        FreshlyStorageViewController *storageViewController = [FreshlyStorageViewController new];
        _storageNavigationController = [[FreshlyNavigationController alloc] initWithRootViewController:storageViewController];
    }

    return  _storageNavigationController;
}

- (FreshlyNavigationController *)shoppingListNavigationController
{
    if (_shoppingListNavigationController == nil) {
        FreshlyShoppingListViewController *shoppingListViewController = [FreshlyShoppingListViewController new];
        _shoppingListNavigationController = [[FreshlyNavigationController alloc] initWithRootViewController:shoppingListViewController];
    }

    return _shoppingListNavigationController;
}

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tabBar.tintColor = [UIColor freshly_primaryGreen];
    self.tabBar.barTintColor = [UIColor freshly_lightGreen];

    [self setViewControllers:@[self.storageNavigationController,
                               self.shoppingListNavigationController]];
}

@end

NS_ASSUME_NONNULL_END
