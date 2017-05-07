//
//  FRSTableViewCell.h
//  Freshly
//
//  Created by Andrew Dempsey on 5/6/17.
//  Copyright © 2017 Andrew Dempsey. All rights reserved.
//

#import "FRSViewModelProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FRSTableViewCellProtocol <NSObject>

- (instancetype)initWithViewModel:(id<FRSViewModelProtocol>)viewModel
                            style:(UITableViewCellStyle)style
                  reuseIdentifier:(NSString *)identifier;
@end

@interface FRSTableViewCell : UITableViewCell <FRSTableViewCellProtocol>

- (instancetype)initWithViewModel:(id<FRSViewModelProtocol>)viewModel
                            style:(UITableViewCellStyle)style
                  reuseIdentifier:(NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
