//
//  FreshlyStorageTableViewCell.m
//  Freshly
//
//  Created by Andrew Dempsey on 7/29/14.
//  Copyright (c) 2014 Andrew Dempsey. All rights reserved.
//

#import "FRSStorageTableViewCell.h"

@implementation FRSStorageTableViewCell

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.separatorInset = UIEdgeInsetsMake(0, 70, 0, 0);
}

@end
