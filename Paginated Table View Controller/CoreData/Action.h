//
//  Action.h
//
//  Created by Dzianis Kashyn on 06.02.14.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface Action : NSManagedObject

@property (nonatomic, strong) NSString * actionName;
@property (nonatomic, strong) NSSet *relationship;

@end

@interface Action (CoreDataGeneratedAccessors)

- (void)addRelationshipObject:(Event *)value;
- (void)removeRelationshipObject:(Event *)value;
- (void)addRelationship:(NSSet *)values;
- (void)removeRelationship:(NSSet *)values;

@end
