//
//  FRSFoodItemViewModel.m
//  Freshly
//
//  Created by Andrew Dempsey on 5/6/17.
//  Copyright © 2017 Andrew Dempsey. All rights reserved.
//

#import "FRSFoodItemViewModel.h"
#import "UIImage+FreshlyAdditions.h"

NS_ASSUME_NONNULL_BEGIN

@interface FRSFoodItemViewModel ()

@property (nonatomic, readwrite, strong) FRSFoodItem *item;

@end

@implementation FRSFoodItemViewModel

#pragma mark - Initialization

- (instancetype)initWithItem:(FRSFoodItem *)item
{
    self = [super init];

    if (self) {
        _item = item;
    }

    return self;
}

#pragma mark - Public Properties

- (void)setItem:(FRSFoodItem *)item
{
    _item = item;
}

#pragma mark - FRSViewModelProtocol

- (NSString *)title
{
    return self.item.name;
}

- (UIImage *)image
{
    return [UIImage imageForCategory:self.item.category withSize:0];
}

@end

NS_ASSUME_NONNULL_END
