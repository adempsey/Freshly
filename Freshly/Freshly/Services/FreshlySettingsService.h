//
//  FreshlySettingsService.h
//  Freshly
//
//  Created by Andrew Dempsey on 8/24/14.
//  Copyright (c) 2014 Andrew Dempsey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FreshlySettingsService : NSObject

@property (nonatomic, readwrite, assign) NSInteger selectedSection;

+ (FreshlySettingsService*)sharedInstance;

@end
