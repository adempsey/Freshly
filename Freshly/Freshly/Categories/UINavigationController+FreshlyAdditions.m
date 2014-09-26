//
//  UINavigationController+FreshlyAdditions.m
//  Freshly
//
//  Created by Andrew Dempsey on 9/24/14.
//  Copyright (c) 2014 Andrew Dempsey. All rights reserved.
//

#import "UINavigationController+FreshlyAdditions.h"
#import "FreshlyItemViewController.h"

@implementation UINavigationController (FreshlyAdditions)

- (NSUInteger)supportedInterfaceOrientations
{
	return [self.topViewController supportedInterfaceOrientations];
}

- (BOOL)shouldAutorotate
{
	return YES;
}

@end
