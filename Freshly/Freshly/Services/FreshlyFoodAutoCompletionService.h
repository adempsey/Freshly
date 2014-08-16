//
//  FreshlyFoodAutoCompletionService.h
//  Freshly
//
//  Created by Andrew Dempsey on 8/16/14.
//  Copyright (c) 2014 Andrew Dempsey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FreshlyFoodAutoCompletionService : NSObject

+ (FreshlyFoodAutoCompletionService*)sharedInstance;
- (void)insertString:(NSString*)string;
- (NSArray*)wordsWithPrefix:(NSString*)prefix;

@end
