//
//  FRSFoodItemDataSource.m
//  Freshly
//
//  Created by Andrew Dempsey on 5/6/17.
//  Copyright © 2017 Andrew Dempsey. All rights reserved.
//

#import "FRSFoodItemDataSource.h"
#import "FRSFoodItemViewModel.h"
#import "FRSStorageTableViewCell.h"

#import "FRSFoodItemService.h"

NS_ASSUME_NONNULL_BEGIN

@interface FRSFoodItemDataSource ()

@property (nonatomic, readwrite, strong) Class<FRSTableViewCellProtocol> CellClass;
@property (nonatomic, readwrite, strong) NSArray<FRSFoodItem *> *items;

@end

@implementation FRSFoodItemDataSource

#pragma mark - FRSDataSourceProtocol

- (instancetype)initWithCellClass:(Class<FRSTableViewCellProtocol>)CellClass
{
    self = [super init];

    if (self) {
        _CellClass = CellClass;
        [[FRSFoodItemService sharedInstance] retrieveItemsForStorageWithBlock:^(NSArray *items) {
            _items = items;
        }];
    }

    return self;
}

- (id<FRSViewModelProtocol>)viewModelForCellAtIndexPath:(NSIndexPath *)indexPath
{
    return [[FRSFoodItemViewModel alloc] initWithItem:self.items[indexPath.row]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell<FRSTableViewCellProtocol> *)tableView:(UITableView *)tableView
                                   cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FRSFoodItemViewModel *viewModel = [self viewModelForCellAtIndexPath:indexPath];

    Class CellClass = self.CellClass;
    UITableViewCell<FRSTableViewCellProtocol> *cell = [[CellClass alloc] initWithViewModel:viewModel
                                                                                     style:UITableViewCellStyleSubtitle
                                                                           reuseIdentifier:@"shit"];
    return cell;
}

@end

NS_ASSUME_NONNULL_END
