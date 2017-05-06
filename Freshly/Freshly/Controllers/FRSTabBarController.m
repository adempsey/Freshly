//
//  FreshlyTabBarController.m
//  Freshly
//
//  Created by Andrew Dempsey on 5/2/17.
//  Copyright © 2017 Andrew Dempsey. All rights reserved.
//

#import "FRSTabBarController.h"
#import "FRSStorageViewController.h"
#import "FRSShoppingListViewController.h"
#import "FRSNavigationController.h"

#import "UIColor+FreshlyAdditions.h"

NS_ASSUME_NONNULL_BEGIN

@interface FRSTabBarController ()

@property (nonatomic, readwrite, strong) FRSNavigationController *storageNavigationController;
@property (nonatomic, readwrite, strong) FRSNavigationController *shoppingListNavigationController;

@end

@implementation FRSTabBarController

#pragma mark - Lazy Properties

- (FRSNavigationController *)storageNavigationController
{
    if (_storageNavigationController == nil) {
        FRSStorageViewController *storageViewController = [FRSStorageViewController new];
        _storageNavigationController = [[FRSNavigationController alloc] initWithRootViewController:storageViewController];
    }

    return  _storageNavigationController;
}

- (FRSNavigationController *)shoppingListNavigationController
{
    if (_shoppingListNavigationController == nil) {
        FRSShoppingListViewController *shoppingListViewController = [FRSShoppingListViewController new];
        _shoppingListNavigationController = [[FRSNavigationController alloc] initWithRootViewController:shoppingListViewController];
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
