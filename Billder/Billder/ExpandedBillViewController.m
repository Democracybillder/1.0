#import "ExpandedBillViewController.h"

#import "Bill.h"
#import "BillSummaryView.h"
#import "Header.h"
#import "RootViewController.h"
#import "Separator.h"
#import "ShareViewController.h"
#import "Translation.h"

@implementation ExpandedBillViewController {
  Bill *_bill;
}

- (instancetype)initWithBill:(Bill *)bill {
  self = [self initWithNibName:nil bundle:nil];
  if (self) {
    _bill = bill;
  }
  return self;
}


- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];

  Header *header = [[Header alloc] initWithWidth:self.view.bounds.size.width title:@"Billder" hasSettings:YES hasCloseButton:YES];
  [self.view addSubview:header];

  CGFloat viewWidth = self.view.bounds.size.width;

  UIView *topView = [[BillSummaryView alloc] initWithBill:_bill width:viewWidth];
  CGRect topFrame = topView.frame;
  topFrame.origin.y = CGRectGetMaxY(header.frame);
  topView.frame = topFrame;

  [self.view addSubview:topView];

  Separator *separator = [Separator horizontalSeparatorWithYOrigin:CGRectGetMaxY(topView.frame)];
  [self.view addSubview:separator];

  UIView *buttonsView = [self buttonsViewWithYOrigin:CGRectGetMaxY(separator.frame)];
  [self.view addSubview:buttonsView];

  UIScrollView *scrollView =
      [self translationsViewWithFrame:CGRectMake(0, CGRectGetMaxY(buttonsView.frame),
                                                 viewWidth, self.view.bounds.size.height - CGRectGetMaxY(buttonsView.frame))];
  [self.view addSubview:scrollView];
}

- (UIView *)buttonsViewWithYOrigin:(CGFloat)yOrigin {
  CGFloat buttonViewWidth = 280;
  CGFloat imageWidth = 50;
  CGFloat verticalSpace = 32;
  UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - buttonViewWidth) / 2,
                                                                yOrigin,
                                                                buttonViewWidth,
                                                                verticalSpace * 2 + imageWidth)];
  buttonView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;


  CGFloat space = (buttonViewWidth - (imageWidth * 4)) / 3;

  UIImageView *petitionImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, verticalSpace, imageWidth, imageWidth)];
  petitionImage.contentMode = UIViewContentModeScaleAspectFit;
  petitionImage.image = [UIImage imageNamed:@"petition"];
  [buttonView addSubview:petitionImage];

  CGFloat nextX = CGRectGetMaxX(petitionImage.frame) + space;

  UIImageView *emailImage = [[UIImageView alloc] initWithFrame:CGRectMake(nextX, verticalSpace, imageWidth, imageWidth)];
  emailImage.contentMode = UIViewContentModeScaleAspectFit;
  emailImage.image = [UIImage imageNamed:@"email"];
  [buttonView addSubview:emailImage];

  nextX = CGRectGetMaxX(emailImage.frame) + space;

  UIImageView *writeImage = [[UIImageView alloc] initWithFrame:CGRectMake(nextX, verticalSpace, imageWidth, imageWidth)];
  writeImage.contentMode = UIViewContentModeScaleAspectFit;
  writeImage.image = [UIImage imageNamed:@"write"];
  [buttonView addSubview:writeImage];

  nextX = CGRectGetMaxX(writeImage.frame) + space;

  UIImageView *shareImage = [[UIImageView alloc] initWithFrame:CGRectMake(nextX, verticalSpace, imageWidth, imageWidth)];
  shareImage.contentMode = UIViewContentModeScaleAspectFit;
  shareImage.image = [UIImage imageNamed:@"share"];
  shareImage.userInteractionEnabled = YES;
  UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushSharePane)];
  [shareImage addGestureRecognizer:tapGR];
  [buttonView addSubview:shareImage];

  return buttonView;
}

- (UIScrollView *)translationsViewWithFrame:(CGRect)frame {
  UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
  scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

  CGFloat lastY = 0;

  for (Translation *translation in _bill.translations) {
    CGFloat rowHeight = 80;
    UIView *translationRow = [[UIView alloc] initWithFrame:CGRectMake(0, lastY, frame.size.width, rowHeight)];

    CGFloat imageWidth = 20;
    CGFloat imageBorder = (rowHeight - imageWidth) / 2;
    UIImageView *upvoteImage = [[UIImageView alloc] initWithFrame:CGRectMake(imageBorder, imageBorder, imageWidth, imageWidth)];
    upvoteImage.contentMode = UIViewContentModeScaleAspectFit;
    upvoteImage.image = [UIImage imageNamed:@"upvoteIcon"];
    [translationRow addSubview:upvoteImage];

    CGFloat nextX = CGRectGetMaxX(upvoteImage.frame) + 10;
    UILabel *upvoteLabel = [[UILabel alloc] initWithFrame:CGRectMake(nextX, 0, 50, 0)];
    upvoteLabel.text = [NSString stringWithFormat:@"%lu votes", (unsigned long)translation.upvotes];
    upvoteLabel.font = [UIFont systemFontOfSize:11];
    [upvoteLabel sizeToFit];
    CGRect upvoteFrame = upvoteLabel.frame;
    upvoteFrame.origin.y = (rowHeight - upvoteFrame.size.height) / 2;
    upvoteLabel.frame = upvoteFrame;
    [translationRow addSubview:upvoteLabel];

    CGFloat titleStart = 130;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleStart, 0, frame.size.width - titleStart - 10, 0)];
    titleLabel.numberOfLines = 3;
    titleLabel.text = translation.title;
    [titleLabel sizeToFit];
    CGRect titleFrame = titleLabel.frame;
    titleFrame.origin.y = (rowHeight - titleFrame.size.height) / 2;
    titleLabel.frame = titleFrame;
    [translationRow addSubview:titleLabel];

    [scrollView addSubview:translationRow];

    lastY = CGRectGetMaxY(translationRow.frame);
  }

  scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, lastY);
  return scrollView;
}

- (void)pushSharePane {
  ShareViewController *svc = [[ShareViewController alloc] init];
  [[RootViewController sharedInstance] pushViewController:svc animated:YES];
}

@end
