#import "BillListView.h"

#import "Bill.h"
#import "BillListViewController.h"
#import "BillSummaryView.h"
#import "Separator.h"

@implementation BillListView {
  NSMutableArray *_billSummaryViews;
  NSMutableArray *_separators;
}

- (UIView *)initWithBills:(NSArray *)bills width:(CGFloat)width canDismiss:(BOOL)canDismiss {
  self = [self initWithFrame:CGRectMake(0, 0, width, 0)];
  if (self) {
    _billSummaryViews = [NSMutableArray array];
    _separators = [NSMutableArray array];
    for (Bill *bill in bills) {
      BillSummaryView *summaryView = [[BillSummaryView alloc] initWithBill:bill width:width];
      [_billSummaryViews addObject:summaryView];
      [self addSubview:summaryView];

      UITapGestureRecognizer *tapGestureRecognizer =
          [[UITapGestureRecognizer alloc] initWithTarget:summaryView action:@selector(pushBillView)];
      [summaryView addGestureRecognizer:tapGestureRecognizer];

      if (canDismiss) {
        UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(summaryViewWasAccepted:)];
        swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
        [summaryView addGestureRecognizer:swipeGestureRecognizer];

        swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(summaryViewWasRejected:)];
        swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
        [summaryView addGestureRecognizer:swipeGestureRecognizer];
      }
    }
    [self layoutList];
  }
  return self;
}

- (void)layoutList {
  CGFloat lastY = 0;
  for (Separator *separator in _separators) {
    [separator removeFromSuperview];
  }
  _separators = [NSMutableArray array];
  for (NSUInteger index = 0; index < _billSummaryViews.count; ++index) {
    UIView *billSummaryObject = _billSummaryViews[index];
    CGRect billFrame = billSummaryObject.frame;
    billFrame.origin.y = lastY;
    billSummaryObject.frame = billFrame;
    lastY = CGRectGetMaxY(billSummaryObject.frame);

/*    Separator *separator = [Separator horizontalSeparatorWithYOrigin:lastY];
    [_separators addObject:separator];
    [self addSubview:separator];
    lastY = CGRectGetMaxY(separator.frame);*/
  }
  CGRect frame = self.frame;
  frame.size.height = CGRectGetMaxY([[_billSummaryViews lastObject] frame]);
  self.frame = frame;
  [self.delegate resizeScrollView];
}

- (void)summaryViewWasAccepted:(UISwipeGestureRecognizer *)swipeRec {
  [self summaryViewWasSwiped:swipeRec];
}

- (void)summaryViewWasRejected:(UISwipeGestureRecognizer *)swipeRec {
  [self summaryViewWasSwiped:swipeRec];
}


- (void)summaryViewWasSwiped:(UISwipeGestureRecognizer *)swipeRec {
  BOOL votedYes = swipeRec.direction == UISwipeGestureRecognizerDirectionRight;
  BillSummaryView *summaryView = (BillSummaryView *)swipeRec.view;
  summaryView.bill.userVote = votedYes ? VoteStatusYes : VoteStatusNo;

  UIView *backgroundView = [[UIView alloc] initWithFrame:summaryView.frame];
  backgroundView.backgroundColor = [Bill colorForVoteStatus:summaryView.bill.userVote];
  [summaryView.superview addSubview:backgroundView];
  [summaryView.superview sendSubviewToBack:backgroundView];

  CGRect destination = summaryView.frame;
  if (votedYes) {
    destination.origin.x += 400;
  } else {
    destination.origin.x -= 400;
  }

  [_billSummaryViews removeObject:summaryView];

  [UIView animateWithDuration:0.5 animations:^{
    summaryView.frame = destination;
    summaryView.alpha = 0;
  } completion:^(BOOL finished) {
    [summaryView removeFromSuperview];
  }];

  [UIView animateKeyframesWithDuration:0.5 delay:0.25 options:0 animations:^{
    [self layoutList];
  } completion:^(BOOL finished) {
    [UIView animateWithDuration:0.25 animations:^{
      backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
      [backgroundView removeFromSuperview];
    }];
  }];
}

- (void)layoutSubviews {
  [super layoutSubviews];
  [self layoutList];
}

@end
