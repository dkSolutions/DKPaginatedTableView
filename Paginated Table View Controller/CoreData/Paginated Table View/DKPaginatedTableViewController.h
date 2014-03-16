//
//  DKPaginatedTableViewController.h
//
//  Created by Dzianis Kashyn on 12.02.14.
//
//

#import <UIKit/UIKit.h>

@interface DKPaginatedTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *rows;

- (NSUInteger)currentPage;
- (NSUInteger)totalPages;

- (void) loadDataWithRowsPerPage:(NSUInteger)rowsPerPage success:(void(^)())success failure:(void (^)(NSError *error))failure;
- (void) loadingData:(void (^)(NSUInteger totalRowsCount, NSArray *rows))success failure:(void (^)(NSError *error))failure;

@end
