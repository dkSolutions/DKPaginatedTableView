//
//  DKPaginatedTableViewController.m
//
//  Created by Dzianis Kashyn on 12.02.14.
//
//

#define HEIGHT_LOADING_VIEW 44.0

#import "DKPaginatedTableViewController.h"

@interface DKPaginatedTableViewController ()

{
    NSUInteger _totalPages;
    NSUInteger _totalRowsCount;
    NSUInteger _rowsPerPage;
    NSUInteger _currentPage;
    
    BOOL _isLoading;
    BOOL _shouldLoad;
    
    UIView *_backgroundView;
    UIView *_loadingView;
    UILabel *_loadingLabel;
    UIActivityIndicatorView *_activitiIndicator;
}

@end

@implementation DKPaginatedTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        _rows = [[NSMutableArray alloc] init];
        _isLoading = NO;
        _shouldLoad = NO;
        _currentPage = 0;
        _totalPages = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialization];
}

- (void) initialization{
    
    _backgroundView = [[UIView alloc] initWithFrame:self.tableView.frame];
    self.tableView.backgroundView = _backgroundView;
    UIColor *backgroundColor = self.tableView.backgroundColor;
    if(backgroundColor){
        _backgroundView.backgroundColor = backgroundColor;
    }
    
    _loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, _backgroundView.frame.size.height - HEIGHT_LOADING_VIEW, _backgroundView.frame.size.width, HEIGHT_LOADING_VIEW)];
    _loadingView.backgroundColor = [UIColor lightGrayColor];
    [_backgroundView addSubview:_loadingView];
    [_loadingView setHidden:YES];
}

- (void) initLoadingView{
    _activitiIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_activitiIndicator setFrame:CGRectMake(11, 11, 30, 30)];
    [_activitiIndicator startAnimating];
    [_loadingView addSubview:_activitiIndicator];
    
    _loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(_activitiIndicator.frame.origin.x + _activitiIndicator.frame.size.width, 14, 220, 20)];
    [_loadingView addSubview:_loadingLabel];
    _loadingLabel.text = @"Loading...";
    [_loadingView setHidden:YES];
}

- (void) showLoadingView:(BOOL)isAnimated{

    if(_activitiIndicator == nil || _loadingLabel == nil) {
        [self initLoadingView];
    }
    
    [_loadingView setHidden:NO];
    [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height - self.tableView.bounds.size.height + HEIGHT_LOADING_VIEW * 2) animated:isAnimated];
}

- (void) hideLoadingView{
    [_loadingView setHidden:YES];
    [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y) animated:YES];
}

- (void) setBackgroundColorLoadingView:(UIColor *) color{
    if(_loadingView)
        _loadingView.backgroundColor = color;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView{
    if(_shouldLoad){
        [self showLoadingView:YES];
    }
}


- (void) scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if (self.tableView.contentOffset.y == self.tableView.contentSize.height - self.tableView.bounds.size.height){
        _shouldLoad = YES;
    }
    else{
        _shouldLoad = NO;
    }
}

#pragma mark - Table view data source

- (int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _rows.count;
}


- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == _rows.count - 1){
        if((_isLoading == NO && _totalPages > _currentPage && _totalPages > 1) || (_totalPages == 0 && _isLoading == NO) )
        {
            if(_totalRowsCount >0){
                _loadingLabel.text = [NSString stringWithFormat:@"Loading... %d / %d", _rows.count, _totalRowsCount];
            }
            
            [self showLoadingView:YES];
            [self loadingData:^(NSUInteger totalRowsCount, NSArray *rows) {
                
                [self setTotalRowsCount:totalRowsCount];
                [self setTotalPagesCountForTotalRowsCount:totalRowsCount rowsPerPage:_rowsPerPage];
                _isLoading = NO;
                [_rows addObjectsFromArray:rows];
                ++_currentPage;
                [self.tableView reloadData];
                [self hideLoadingView];
                
            } failure:^(NSError *error) {
                _isLoading = NO;
                [self hideLoadingView];
            }];
        }
    }
}

- (NSArray *)rows{
    return [_rows copy];
}

- (NSUInteger)currentPage{
    return _currentPage;
}

- (NSUInteger)totalPages{
    return _totalPages;
}

- (void) setRowsPerPage:(NSUInteger)rows{
    _rowsPerPage = rows;
}

- (void) setTotalRowsCount:(NSUInteger)totalRowsCount{
    _totalRowsCount = totalRowsCount;
}

- (void) setTotalPagesCountForTotalRowsCount:(NSUInteger)totalRowsCount rowsPerPage:(NSUInteger)rowsPerPage{
    if(rowsPerPage > 0){
        _totalPages = (int)ceil((float)totalRowsCount / (float)rowsPerPage);
    }
}

- (void) loadDataWithRowsPerPage:(NSUInteger)rowsPerPage{
    [self loadingData:^(NSUInteger totalRowsCount, NSArray *rows) {
        [self setRowsPerPage:rowsPerPage];
        _currentPage = 1;
        [_rows addObjectsFromArray:rows];
        [self.tableView reloadData];
        _isLoading = NO;
        
    } failure:^(NSError *error) {
        _isLoading = NO;
    }];
}

- (void) loadingData:(void (^)(NSUInteger totalRowsCount, NSArray *rows))success failure:(void (^)(NSError *error))failure{
    _isLoading = YES;
}

@end
