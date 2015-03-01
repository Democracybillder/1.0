#import "Header.h"

#import "BillSummaryView.h"
#import "RootViewController.h"

const CGFloat kTextXOrigin = 106;

@implementation Header

- (instancetype)initWithWidth:(CGFloat)width title:(NSString *)title hasSettings:(BOOL)hasSettings hasCloseButton:(BOOL)hasCloseButton {
  CGFloat headerHeight = 60;
  self = [self initWithFrame:CGRectMake(0, 0, width, headerHeight)];
  if (self) {
    self.backgroundColor = [UIColor colorWithRed:51.0/255.0 green:105.0/255.0 blue:232.0/255.0 alpha:1];
    CGFloat imageSize = 30;
    CGFloat buttonPadding = (headerHeight - imageSize) / 2;

    if (hasSettings) {
      UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, headerHeight, headerHeight)];
      buttonView.backgroundColor = [UIColor clearColor];
      [self addSubview:buttonView];

      UIImageView *settingsButton = [[UIImageView alloc] initWithFrame:CGRectMake(buttonPadding, buttonPadding, imageSize, imageSize)];
      settingsButton.contentMode = UIViewContentModeScaleAspectFit;
      settingsButton.image = [UIImage imageNamed:@"settings"];
      [buttonView addSubview:settingsButton];

      buttonView.userInteractionEnabled = YES;
      UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:[RootViewController sharedInstance] action:@selector(pushSettings)];
      [buttonView addGestureRecognizer:tapGR];
    }

    CGFloat titleRight = width - buttonPadding;
    if (hasCloseButton) {
      UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(width - headerHeight, 0, headerHeight, headerHeight)];
      buttonView.backgroundColor = [UIColor clearColor];
      [self addSubview:buttonView];

      CGFloat closeSize = imageSize - 15;
      CGFloat closePadding = (headerHeight - closeSize) / 2;

      UIImageView *closeButton = [[UIImageView alloc] initWithFrame:CGRectMake(closePadding, closePadding, closeSize, closeSize)];
      closeButton.contentMode = UIViewContentModeScaleAspectFit;
      closeButton.image = [UIImage imageNamed:@"close"];
      titleRight = CGRectGetMinX(closeButton.frame) - buttonPadding;
      [buttonView addSubview:closeButton];

      buttonView.userInteractionEnabled = YES;
      UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:[RootViewController sharedInstance] action:@selector(popPane)];
      [buttonView addGestureRecognizer:tapGR];
   }

    CGFloat titleOriginX = hasSettings ? kTextXOrigin : 16;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleOriginX, 0, titleRight - titleOriginX, 0)];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel sizeToFit];
    CGRect titleFrame = titleLabel.frame;
    titleFrame.origin.y = (headerHeight - titleFrame.size.height) / 2;
    titleLabel.frame = titleFrame;
    [self addSubview:titleLabel];
  }
  return self;
}

@end
