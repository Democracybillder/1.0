#import <UIKit/UIKit.h>

@class Bill;


@interface BillSummaryView : UIView

@property(nonatomic, readonly) Bill *bill;

- (instancetype)initWithBill:(Bill *)bill width:(CGFloat)width;

- (void)pushBillView;

@end
