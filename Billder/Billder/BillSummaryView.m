#import "BillSummaryView.h"

#import "Bill.h"
#import "ExpandedBillViewController.h"
#import "Header.h"
#import "ImageFetcher.h"
#import "RootViewController.h"

const CGFloat kBillSummaryRowHeight = 96;
static const CGFloat kTextMargin = 10;

@implementation BillSummaryView {
  UIView *_backgroundView;
  UIImageView *_sponsorImageView;
  UILabel *_titleLabel;
  UILabel *_voteOnLabel;
  UISwipeGestureRecognizer *_acceptGestureRecognizer;
  UISwipeGestureRecognizer *_rejectGestureRecognizer;
  UITapGestureRecognizer *_tapGestureRecognizer;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleHeight;
    [self.contentView addSubview:_backgroundView];

    _containerView = [[UIView alloc] initWithFrame:self.bounds];
    _containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
        UIViewAutoresizingFlexibleHeight;
    [self.contentView addSubview:_containerView];

    _sponsorImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _sponsorImageView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    _sponsorImageView.contentMode = UIViewContentModeScaleAspectFill;

    [_containerView addSubview:_sponsorImageView];

    UIColor *fontColor = [UIColor whiteColor];

    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.numberOfLines = 2;
    _titleLabel.textColor = fontColor;
    _titleLabel.font = [UIFont systemFontOfSize:20];
    [_containerView addSubview:_titleLabel];

    _voteOnLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _voteOnLabel.textColor = fontColor;
    [_containerView addSubview:_voteOnLabel];
  }
  return self;
}

- (instancetype)initWithBill:(Bill *)bill width:(CGFloat)width {
  self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
  if (self) {
    self.frame = CGRectMake(0, 0, width, kBillSummaryRowHeight);
    [self setBill:bill];
  }
  return self;
}

- (void)setBill:(Bill *)bill {
  _bill = bill;

  _containerView.backgroundColor = [_bill fillColor];
  [ImageFetcher fetchImageWithURL:[NSURL URLWithString:_bill.imageUrl]
                  completionBlock:^(BOOL succeeded, UIImage *image) {
                    if (succeeded) {
                      _sponsorImageView.image = image;
                    }
                  }];

  _titleLabel.text = [_bill.translations[0] title];

  if (_bill.govVote == VoteStatusNoVote) {
    _voteOnLabel.text = [@"Vote on " stringByAppendingString:_bill.voteDate];
    _voteOnLabel.font = [UIFont systemFontOfSize:12];
  } else if (_bill.govVote == VoteStatusYes) {
    _voteOnLabel.text = [@"Passed on " stringByAppendingString:_bill.voteDate];
    _voteOnLabel.font = [UIFont systemFontOfSize:14];
  } else if (_bill.govVote == VoteStatusNo) {
    _voteOnLabel.text = [@"Failed on " stringByAppendingString:_bill.voteDate];
    _voteOnLabel.font = [UIFont systemFontOfSize:14];
  }

  [self setNeedsLayout];
}

- (void)setVotingColor:(UIColor *)backgroundColor {
  _backgroundView.backgroundColor = backgroundColor;
}

- (UIColor *)votingColor {
  return _backgroundView.backgroundColor;
}

- (void)resetView {
  self.containerView.alpha = 1;
  self.containerView.frame = self.bounds;
}

- (void)layoutSubviews {
  [super layoutSubviews];

  CGFloat width = self.bounds.size.width;
  CGFloat height = self.bounds.size.height;
  _sponsorImageView.frame = CGRectMake(0, 0, height, height);

  CAShapeLayer *circle = [CAShapeLayer layer];
  // Make a circular shape
  UIBezierPath *circularPath = [UIBezierPath bezierPathWithOvalInRect:_sponsorImageView.bounds];
  circle.path = circularPath.CGPath;
  // Configure the apperence of the circle
  circle.fillColor = [UIColor blackColor].CGColor;
  circle.strokeColor = [UIColor blackColor].CGColor;
  circle.lineWidth = 0;

  _sponsorImageView.layer.mask = circle;

  _titleLabel.frame = CGRectMake(kTextXOrigin, 16, width - kTextXOrigin - kTextMargin, 0);
  [_titleLabel sizeToFit];

  _voteOnLabel.frame = CGRectMake(kTextXOrigin, 70, width - kTextXOrigin - kTextMargin, 0);
  [_voteOnLabel sizeToFit];
}

- (void)setEnableListGestures:(BOOL)enableListGestures {
  if (_enableListGestures == enableListGestures) return;
  if (enableListGestures) {
    if (!_tapGestureRecognizer) {
      _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                      action:@selector(pushExpandedBillView)];
    }
    [self addGestureRecognizer:_tapGestureRecognizer];

    if (!_acceptGestureRecognizer) {
      _acceptGestureRecognizer =
      [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(summaryViewWasAccepted:)];
      _acceptGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    }
    [self addGestureRecognizer:_acceptGestureRecognizer];

    if (!_rejectGestureRecognizer) {
      _rejectGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                           action:@selector(summaryViewWasRejected:)];
      _rejectGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    }
    [self addGestureRecognizer:_rejectGestureRecognizer];
  } else {
    [self removeGestureRecognizer:_tapGestureRecognizer];
    [self removeGestureRecognizer:_acceptGestureRecognizer];
    [self removeGestureRecognizer:_rejectGestureRecognizer];
  }
}

- (void)summaryViewWasAccepted:(UISwipeGestureRecognizer *)swipeRec {
  [self summaryViewWasSwiped:swipeRec];
}

- (void)summaryViewWasRejected:(UISwipeGestureRecognizer *)swipeRec {
  [self summaryViewWasSwiped:swipeRec];
}


- (void)summaryViewWasSwiped:(UISwipeGestureRecognizer *)swipeRec {
  BOOL votedYes = swipeRec.direction == UISwipeGestureRecognizerDirectionRight;
  VoteStatus newVoteStatus = votedYes ? VoteStatusYes : VoteStatusNo;

  if (newVoteStatus == self.bill.userVote) return;

  self.bill.userVote = newVoteStatus;

  [self.delegate billSummaryViewWasSwiped:self];
}

- (void)pushExpandedBillView {
  ExpandedBillViewController *viewController = [[ExpandedBillViewController alloc] initWithBill:_bill];
  [[[RootViewController sharedInstance] paneNavigationController] pushViewController:viewController animated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  // TBI
}

@end
