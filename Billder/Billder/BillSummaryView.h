#import <UIKit/UIKit.h>

@class Bill;
@class BillSummaryView;

extern const CGFloat kBillSummaryRowHeight;

@protocol BillSummaryViewDelegate <NSObject>

- (void)billSummaryViewWasSwiped:(BillSummaryView *)billSummaryView;

@end

@interface BillSummaryView : UITableViewCell

@property(nonatomic) Bill *bill;
@property(nonatomic) BOOL enableListGestures;
@property(nonatomic) id<BillSummaryViewDelegate> delegate;

@property(nonatomic, readonly) UIView *containerView;

@property(nonatomic) UIColor *votingColor;

- (instancetype)initWithBill:(Bill *)bill width:(CGFloat)width;

- (void)resetView;

@end
