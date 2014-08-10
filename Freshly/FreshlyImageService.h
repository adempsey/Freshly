//
//  FreshlyImageService.h
//  Freshly
//
//  Created by Andrew Dempsey on 7/29/14.
//  Copyright (c) 2014 Andrew Dempsey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FreshlyImageService : NSObject

+ (FreshlyImageService*)sharedInstance;

- (UIImage*)retrieveImageForCategory:(NSString *)category withSize:(NSUInteger)size;

@end
