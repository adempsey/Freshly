//
//  FRSFoodItemViewModel.h
//  Freshly
//
//  Created by Andrew Dempsey on 5/6/17.
//  Copyright © 2017 Andrew Dempsey. All rights reserved.
//

#import "FRSFoodItem.h"
#import "FRSViewModelProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface FRSFoodItemViewModel : NSObject <FRSViewModelProtocol>

@property (nonatomic, readonly, strong) NSString *title;

- (instancetype)initWithItem:(FRSFoodItem *)item;

@end

NS_ASSUME_NONNULL_END
