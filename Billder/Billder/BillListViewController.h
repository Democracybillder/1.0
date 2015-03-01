#import <UIKit/UIKit.h>

@class Bill;

@interface BillListViewController : UIViewController

- (instancetype) initWithTitle:(NSString *)title predicate:(BOOL (^)(Bill *bill))predicate isRoot:(BOOL)isRoot;
- (void)resizeScrollView;

@end
