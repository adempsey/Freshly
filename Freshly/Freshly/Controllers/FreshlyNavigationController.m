//
//  FreshlyNavigationController.m
//  Freshly
//
//  Created by Andrew Dempsey on 5/2/17.
//  Copyright © 2017 Andrew Dempsey. All rights reserved.
//

#import "FreshlyNavigationController.h"
#import "UIColor+FreshlyAdditions.h"

NS_ASSUME_NONNULL_BEGIN

@implementation FreshlyNavigationController

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationBar.barTintColor = [UIColor freshly_primaryGreen];
    self.navigationBar.tintColor = [UIColor freshly_whiteColor];
}

@end

NS_ASSUME_NONNULL_END
