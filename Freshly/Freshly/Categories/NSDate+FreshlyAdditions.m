//
//  NSDate+FreshlyAdditions.m
//  Freshly
//
//  Created by Andrew Dempsey on 7/30/14.
//  Copyright (c) 2014 Andrew Dempsey. All rights reserved.
//

#import "NSDate+FreshlyAdditions.h"

static const NSUInteger kDAY    = 86400;
static const NSUInteger kWEEK   = kDAY*7;
static const NSUInteger kMONTH  = kWEEK*4;
static const NSUInteger kYEAR   = kMONTH*12;

@implementation NSDate (FreshlyAdditions)

- (NSDateComponents*)calendarDescription
{
	return [[NSCalendar currentCalendar] components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear fromDate:self];
}

- (NSString*)monthAsString
{
	NSArray *months = @[@"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun",
						@"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dec"];
	return months[self.calendarDescription.month - 1];
}

- (NSDate*)normalizedDate
{
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *components = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self];
	return [gregorian dateFromComponents:components];
}

- (NSString*)approximateDescription
{
    NSInteger timeInterval = [[self normalizedDate] timeIntervalSinceNow];
    BOOL inPast = (timeInterval < 0);
    NSUInteger timeSince = abs(timeInterval);
    
    NSString *dateDescription;
    NSUInteger interval = 0;
    
    if (timeSince < kDAY) {
        dateDescription = @"today";
        
    } else if (timeSince >= kDAY && timeSince < kWEEK) {
        interval = timeSince/kDAY;
        dateDescription = [NSString stringWithFormat:@"%d day", interval];
        
    } else if (timeSince >= kWEEK && timeSince < kMONTH) {
        interval = timeSince/kWEEK;
        dateDescription = [NSString stringWithFormat:@"%d week", interval];
        
    } else if (timeSince >= kMONTH && timeSince < kYEAR) {
        interval = timeSince/kMONTH;
        dateDescription = [NSString stringWithFormat:@"%d month", interval];
        
    } else if (timeSince >= kYEAR) {
        interval = timeSince/kYEAR;
        dateDescription = [NSString stringWithFormat:@"%d year", interval];
    }
    
    NSString *prefix = @"";
    
    if (interval > 1) {
        dateDescription = [dateDescription stringByAppendingString:@"s"];
    }
    
    if (timeSince >= kWEEK) {
        prefix = @"over ";
    }
    
    if (timeSince >= kDAY) {
        if (inPast) {
            dateDescription = [NSString stringWithFormat:@"%@%@ ago", prefix, dateDescription];
        } else {
            dateDescription = [NSString stringWithFormat:@"in %@", dateDescription];
        }
    }
    
    return dateDescription;
}

@end
