//
//  FRSFoodItemDataSource.m
//  Freshly
//
//  Created by Andrew Dempsey on 5/6/17.
//  Copyright © 2017 Andrew Dempsey. All rights reserved.
//

#import "FRSFoodItemDataSource.h"
#import "FRSFoodItemViewModel.h"
#import "FRSTableViewCell.h"

#import "FRSFoodItemService.h"

NS_ASSUME_NONNULL_BEGIN

@interface FRSFoodItemDataSource ()

@property (nonatomic, readwrite, strong) NSArray<FRSFoodItem *> *items;

@end

@implementation FRSFoodItemDataSource

- (instancetype)init
{
    self = [super init];

    if (self) {
        [[FRSFoodItemService sharedInstance] retrieveItemsForStorageWithBlock:^(NSArray *items) {
            _items = items;
        }];

    }

    return self;
}

#pragma mark - Private Methods

- (FRSFoodItemViewModel *)viewModelForCellAtIndexPath:(NSIndexPath *)indexPath
{
    return [[FRSFoodItemViewModel alloc] initWithItem:self.items[indexPath.row]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (FRSTableViewCell *)tableView:(UITableView *)tableView
          cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FRSFoodItemViewModel *viewModel = [self viewModelForCellAtIndexPath:indexPath];

    FRSTableViewCell *cell = [[FRSTableViewCell alloc] initWithViewModel:viewModel
                                                                   style:UITableViewCellStyleSubtitle
                                                         reuseIdentifier:@"shit"];
    return cell;
}

@end

NS_ASSUME_NONNULL_END
