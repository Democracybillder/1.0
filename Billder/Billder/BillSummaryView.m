#import "BillSummaryView.h"

#import "Bill.h"
#import "ExpandedBillViewController.h"
#import "Header.h"
#import "ImageFetcher.h"
#import "RootViewController.h"

static const CGFloat kRowHeight = 96;
static const CGFloat kTextMargin = 10;

@implementation BillSummaryView

- (instancetype)initWithBill:(Bill *)bill width:(CGFloat)width {
  self = [self initWithFrame:CGRectMake(0, 0, width, kRowHeight)];
  if (self) {
    _bill = bill;

    self.backgroundColor = [_bill fillColor];
    UIImageView *sponsorImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kRowHeight, kRowHeight)];
    sponsorImage.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    sponsorImage.contentMode = UIViewContentModeScaleAspectFill;
    [ImageFetcher fetchImageWithURL:[NSURL URLWithString:_bill.imageUrl] completionBlock:^(BOOL succeeded, UIImage *image) {
      if (succeeded) {
        sponsorImage.image = image;
      }
    }];
    CAShapeLayer *circle = [CAShapeLayer layer];
    // Make a circular shape
    UIBezierPath *circularPath = [UIBezierPath bezierPathWithOvalInRect:sponsorImage.bounds];

    circle.path = circularPath.CGPath;

    // Configure the apperence of the circle
    circle.fillColor = [UIColor blackColor].CGColor;
    circle.strokeColor = [UIColor blackColor].CGColor;
    circle.lineWidth = 0;

    sponsorImage.layer.mask=circle;
    [self addSubview:sponsorImage];

    UIColor *fontColor = [UIColor whiteColor];

    UILabel *billName = [[UILabel alloc] initWithFrame:CGRectMake(kTextXOrigin,
                                                                  16, width - kTextXOrigin - kTextMargin, 0)];
    billName.text = [_bill.translations[0] title];
    billName.numberOfLines = 2;
    billName.textColor = fontColor;
    billName.font = [UIFont systemFontOfSize:20];
    [billName sizeToFit];
    [self addSubview:billName];

    UILabel *voteOnLabel = [[UILabel alloc] initWithFrame:CGRectMake(kTextXOrigin,
                                                                  70, width - kTextXOrigin - kTextMargin, 0)];
    if (_bill.govVote == VoteStatusNoVote) {
      voteOnLabel.text = [@"Vote on " stringByAppendingString:_bill.voteDate];
      voteOnLabel.font = [UIFont systemFontOfSize:12];
      voteOnLabel.textColor = fontColor;
    } else if (_bill.govVote == VoteStatusYes) {
      voteOnLabel.text = [@"Passed on " stringByAppendingString:_bill.voteDate];
      voteOnLabel.textColor = fontColor;//[UIColor colorWithRed:0.0/255 green:200.0/255.0 blue:20.0/255 alpha:1];
      voteOnLabel.font = [UIFont systemFontOfSize:14];
    } else if (_bill.govVote == VoteStatusNo) {
      voteOnLabel.text = [@"Failed on " stringByAppendingString:_bill.voteDate];
      voteOnLabel.textColor = fontColor;//[UIColor colorWithRed:200.0/255 green:20.0/255.0 blue:0.0/255 alpha:1];
      voteOnLabel.font = [UIFont systemFontOfSize:14];
    }
    [voteOnLabel sizeToFit];
    [self addSubview:voteOnLabel];
  }
  return self;
}

- (void)pushBillView {
  ExpandedBillViewController *viewController = [[ExpandedBillViewController alloc] initWithBill:_bill];
  [[[RootViewController sharedInstance] paneNavigationController] pushViewController:viewController animated:YES];
}

@end
