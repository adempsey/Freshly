//
//  UITabBarController+FreshlyAdditions.m
//  Freshly
//
//  Created by Andrew Dempsey on 10/1/14.
//  Copyright (c) 2014 Andrew Dempsey. All rights reserved.
//

#import "UITabBarController+FreshlyAdditions.h"

@implementation UITabBarController (FreshlyAdditions)

- (BOOL)shouldAutorotate
{
	UINavigationController *currentNavigationController = self.viewControllers[self.selectedIndex];
	return [currentNavigationController.topViewController shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations
{
	UINavigationController *currentNavigationController = self.viewControllers[self.selectedIndex];
	return [currentNavigationController.topViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
	UINavigationController *currentNavigationController = self.viewControllers[self.selectedIndex];
	return [currentNavigationController.topViewController preferredInterfaceOrientationForPresentation];
}

@end
