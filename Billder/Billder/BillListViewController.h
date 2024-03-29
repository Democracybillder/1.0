#import <UIKit/UIKit.h>

@class Bill;

@interface BillListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

- (instancetype) initWithTitle:(NSString *)title predicate:(BOOL (^)(Bill *bill))predicate isRoot:(BOOL)isRoot;

@end
