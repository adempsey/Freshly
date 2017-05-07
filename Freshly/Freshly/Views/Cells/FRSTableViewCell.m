//
//  FRSTableViewCell.m
//  Freshly
//
//  Created by Andrew Dempsey on 5/6/17.
//  Copyright © 2017 Andrew Dempsey. All rights reserved.
//

#import "FRSTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface FRSTableViewCell ()

@property (nonatomic, readwrite, strong) id<FRSViewModelProtocol> viewModel;

@end

@implementation FRSTableViewCell

- (instancetype)initWithViewModel:(id<FRSViewModelProtocol>)viewModel
                            style:(UITableViewCellStyle)style
                  reuseIdentifier:(NSString *)identifier
{
    self = [super initWithStyle:style
                reuseIdentifier:identifier];

    if (self) {
        _viewModel = viewModel;

        self.textLabel.text = viewModel.title;
    }

    return self;
}

@end

NS_ASSUME_NONNULL_END
