//
//  UINavigationController+FreshlyAdditions.m
//  Freshly
//
//  Created by Andrew Dempsey on 9/24/14.
//  Copyright (c) 2014 Andrew Dempsey. All rights reserved.
//

#import "UINavigationController+FreshlyAdditions.h"
#import "FRSItemViewController.h"

@implementation UINavigationController (FreshlyAdditions)

- (BOOL)shouldAutorotate
{
	return [self.topViewController shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations
{
	return [self.topViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
	return [self.topViewController supportedInterfaceOrientations];
}

@end
