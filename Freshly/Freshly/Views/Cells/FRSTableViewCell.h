//
//  FRSTableViewCell.h
//  Freshly
//
//  Created by Andrew Dempsey on 5/6/17.
//  Copyright © 2017 Andrew Dempsey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRSViewModelProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface FRSTableViewCell : UITableViewCell

- (instancetype)initWithViewModel:(id<FRSViewModelProtocol>)viewModel
                            style:(UITableViewCellStyle)style
                  reuseIdentifier:(NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
