//
//  FRSViewModelProtocol.h
//  Freshly
//
//  Created by Andrew Dempsey on 5/6/17.
//  Copyright © 2017 Andrew Dempsey. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@protocol FRSViewModelProtocol <NSObject>

@property (nonatomic, readonly, strong) NSString *title;

@optional
@property (nonatomic, readonly, strong) NSString *subtitle;
@property (nonatomic, readonly, strong) UIImage *image;

@end

NS_ASSUME_NONNULL_END
