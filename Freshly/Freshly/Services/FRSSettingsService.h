//
//  FreshlySettingsService.h
//  Freshly
//
//  Created by Andrew Dempsey on 8/24/14.
//  Copyright (c) 2014 Andrew Dempsey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FRSSettingsService : NSObject

@property (nonatomic, readwrite, assign) NSInteger selectedSection;
@property (nonatomic, readwrite, assign) NSInteger storageSorting;
@property (nonatomic, readwrite, assign) NSInteger storageGrouping;
@property (nonatomic, readwrite, assign) BOOL showPurchaseDate;
@property (nonatomic, readwrite, assign) BOOL showExpirationDate;
@property (nonatomic, readwrite, assign) BOOL showStorageLocation;

+ (FRSSettingsService*)sharedInstance;

@end
