//
//  FreshlyFoodItem.h
//  Freshly
//
//  Created by Andrew Dempsey on 7/24/14.
//  Copyright (c) 2014 Andrew Dempsey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FreshlyFoodItem : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSNumber * space;
@property (nonatomic, retain) NSNumber * inStorage;
@property (nonatomic, retain) NSDate * brand;
@property (nonatomic, retain) NSDate * dateOfExpiration;
@property (nonatomic, retain) NSDate * dateOfPurchase;

@end
