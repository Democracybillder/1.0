#import <UIKit/UIKit.h>

@class BillListViewController;

@interface BillListView : UIView

@property (nonatomic) BillListViewController *delegate;

- (UIView *)initWithBills:(NSArray *)bills width:(CGFloat)width canDismiss:(BOOL)canDismiss;

@end
