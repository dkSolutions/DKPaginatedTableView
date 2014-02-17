//
//
//  Created by Dzianis Kashyn on 06.02.14.
//

#import <UIKit/UIKit.h>

@interface DKViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)actionButton:(id)sender;

@end
