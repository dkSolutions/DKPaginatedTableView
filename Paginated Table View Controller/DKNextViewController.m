//
//  DKNextViewController.m
//
//  Created by Dzianis Kashyn on 12.02.14.

//Fake data
#define ROWS_PER_PAGE 20
#define TOTAL_PAGES 43

#import "DKNextViewController.h"

@interface DKNextViewController ()

@end

@implementation DKNextViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [super loadDataWithRowsPerPage:ROWS_PER_PAGE];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    if(indexPath.row < self.rows.count){
        cell.textLabel.text = [self.rows objectAtIndex:indexPath.row];
    }
    
    
    return cell;
}

- (void)loadingData:(void (^)(NSUInteger totalRowsCount, NSArray *rows))success failure:(void (^)(NSError *error))failure{
    [super loadingData:success failure:failure];
    NSLog(@"waiting 2 seconds...");
    [self performSelector:@selector(wait:) withObject:success afterDelay:2];
}

//Fake Data for paging
- (void) wait:(void (^)(NSUInteger totalRowsCount, NSArray *rows))success{
    

    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    int dataChunk = TOTAL_PAGES - [self currentPage] * ROWS_PER_PAGE;
    if(dataChunk > ROWS_PER_PAGE){
        dataChunk = ROWS_PER_PAGE;
    }
    
    if(dataChunk > 0){
        for (int i = 0; i < dataChunk; i++) {
            int t = [[NSDate date] timeIntervalSinceReferenceDate];
            long int x = arc4random() % t;
            [dataArray addObject:[NSString stringWithFormat:@"%ld", x]];
        }
        success(TOTAL_PAGES, [dataArray copy]);
    }
}

@end
