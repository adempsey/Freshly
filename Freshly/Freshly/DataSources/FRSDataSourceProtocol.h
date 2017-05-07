//
//  FRSDataSourceProtocol.h
//  Freshly
//
//  Created by Andrew Dempsey on 5/6/17.
//  Copyright © 2017 Andrew Dempsey. All rights reserved.
//

#import "FRSViewModelProtocol.h"
#import "FRSTableViewCell.h"

@protocol FRSDataSourceProtocol <UITableViewDataSource>

- (instancetype)initWithCellClass:(Class<FRSTableViewCellProtocol>)CellClass;

- (id<FRSViewModelProtocol>)viewModelForCellAtIndexPath:(NSIndexPath *)indexPath;

@end
