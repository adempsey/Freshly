//
//  FRSTableViewCell.m
//  Freshly
//
//  Created by Andrew Dempsey on 5/6/17.
//  Copyright © 2017 Andrew Dempsey. All rights reserved.
//

#import "FRSTableViewCell.h"
#import "UIColor+FreshlyAdditions.h"
#import "UIFont+FreshlyAdditions.h"

NS_ASSUME_NONNULL_BEGIN

@interface FRSTableViewCell ()

@property (nonatomic, readwrite, strong) id<FRSViewModelProtocol> viewModel;

@end

@implementation FRSTableViewCell

#pragma mark - Initialization

- (instancetype)initWithViewModel:(id<FRSViewModelProtocol>)viewModel
                            style:(UITableViewCellStyle)style
                  reuseIdentifier:(NSString *)identifier
{
    self = [super initWithStyle:style
                reuseIdentifier:identifier];

    if (self) {
        _viewModel = viewModel;

        [self configureTextLabel];
    }

    return self;
}

#pragma mark - Cell Configuration

- (void)configureTextLabel
{
    self.textLabel.text = self.viewModel.title;
    self.textLabel.font = [UIFont freshlyFontOfSize:[UIFont labelFontSize]];
    self.textLabel.textColor = [UIColor freshly_darkGrayColor];

    self.imageView.image = self.viewModel.image;
}

@end

NS_ASSUME_NONNULL_END
