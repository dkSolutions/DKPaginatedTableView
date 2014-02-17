//
//  Event.h
//
//  Created by Dzianis Kashyn on 06.02.14.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Event : NSManagedObject

@property (nonatomic, strong) NSDate * timeStamp;

@end
