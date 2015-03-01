#import "SettingsViewController.h"

#import "Bill.h"
#import "BillListViewController.h"
#import "Header.h"
#import "Separator.h"

static const CGFloat kTextMargin = 16;

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.

  Header *header = [[Header alloc] initWithWidth:self.view.bounds.size.width title:@"Settings" hasSettings:NO hasCloseButton:YES];
  [self.view addSubview:header];

  UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(header.frame), self.view.bounds.size.width, self.view.bounds.size.height - CGRectGetMaxY(header.frame))];
  scrollView.backgroundColor = [UIColor colorWithWhite:.94 alpha:1];
  scrollView.bounces = YES;
  scrollView.alwaysBounceVertical = YES;
  [self.view addSubview:scrollView];

  CGFloat titleTopSpace = 30;

  UIColor *titleColor = [UIColor colorWithWhite:0.5 alpha:1];

  UILabel *scopeTitle = [[UILabel alloc] initWithFrame:CGRectMake(kTextMargin, titleTopSpace, self.view.bounds.size.width - (2 * kTextMargin), 0)];
  scopeTitle.font = [UIFont systemFontOfSize:14];
  scopeTitle.textColor = titleColor;
  scopeTitle.text = @"SCOPE";
  [scopeTitle sizeToFit];
  [scrollView addSubview:scopeTitle];

  CGFloat titleBotSpace = 5;

  CGFloat lastY = CGRectGetMaxY(scopeTitle.frame) + titleBotSpace;
  
  NSArray *scopes = @[@"Federal", @"State", @"Local"];
  for (NSString *scope in scopes) {
    Separator *separator = [Separator horizontalSeparatorWithYOrigin:lastY];
    [scrollView addSubview:separator];
    lastY = CGRectGetMaxY(separator.frame);

    UIView *row = [self rowForSettingTitle:scope yOrigin:lastY isCheck:YES];
    [scrollView addSubview:row];
    lastY = CGRectGetMaxY(row.frame);
  }

  Separator *separator = [Separator horizontalSeparatorWithYOrigin:lastY];
  [scrollView addSubview:separator];
  lastY = CGRectGetMaxY(separator.frame);

  UILabel *interestsTitle = [[UILabel alloc] initWithFrame:CGRectMake(kTextMargin, lastY + titleTopSpace, self.view.bounds.size.width - (2 * kTextMargin), 0)];
  interestsTitle.font = [UIFont systemFontOfSize:14];
  interestsTitle.textColor = titleColor;
  interestsTitle.text = @"INTERESTS";
  [interestsTitle sizeToFit];
  [scrollView addSubview:interestsTitle];


  lastY = CGRectGetMaxY(interestsTitle.frame) + titleBotSpace;

  NSArray *interests = @[@"Driving", @"Taxes", @"Guns", @"Small Business", @"Environment"];
  for (NSString *scope in interests) {
    Separator *separator = [Separator horizontalSeparatorWithYOrigin:lastY];
    [scrollView addSubview:separator];
    lastY = CGRectGetMaxY(separator.frame);

    UIView *row = [self rowForSettingTitle:scope yOrigin:lastY isCheck:YES];
    [scrollView addSubview:row];
    lastY = CGRectGetMaxY(row.frame);
  }

  separator = [Separator horizontalSeparatorWithYOrigin:lastY];
  [scrollView addSubview:separator];
  lastY = CGRectGetMaxY(separator.frame);

  lastY += titleTopSpace;

  separator = [Separator horizontalSeparatorWithYOrigin:lastY];
  [scrollView addSubview:separator];
  lastY = CGRectGetMaxY(separator.frame);

  UIView *row = [self rowForSettingTitle:@"My Bills" yOrigin:lastY isCheck:NO];
  [scrollView addSubview:row];
  lastY = CGRectGetMaxY(row.frame);

  UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushMyBills)];
  [row addGestureRecognizer:tapGR];

  separator = [Separator horizontalSeparatorWithYOrigin:lastY];
  [scrollView addSubview:separator];
  lastY = CGRectGetMaxY(separator.frame);

  lastY += titleTopSpace;

  separator = [Separator horizontalSeparatorWithYOrigin:lastY];
  [scrollView addSubview:separator];
  lastY = CGRectGetMaxY(separator.frame);

  UIView *anonrow = [self rowForSettingTitle:@"Anonymous Feed" yOrigin:lastY isCheck:NO];
  [scrollView addSubview:anonrow];
  lastY = CGRectGetMaxY(anonrow.frame);

  separator = [Separator horizontalSeparatorWithYOrigin:lastY];
  [scrollView addSubview:separator];
  lastY = CGRectGetMaxY(separator.frame);

  lastY += titleTopSpace;

  separator = [Separator horizontalSeparatorWithYOrigin:lastY];
  [scrollView addSubview:separator];
  lastY = CGRectGetMaxY(separator.frame);

  UIView *aboutrow = [self rowForSettingTitle:@"About" yOrigin:lastY isCheck:NO];
  [scrollView addSubview:aboutrow];
  lastY = CGRectGetMaxY(aboutrow.frame);

  separator = [Separator horizontalSeparatorWithYOrigin:lastY];
  [scrollView addSubview:separator];
  lastY = CGRectGetMaxY(separator.frame);

  lastY += titleTopSpace;

  separator = [Separator horizontalSeparatorWithYOrigin:lastY];
  [scrollView addSubview:separator];
  lastY = CGRectGetMaxY(separator.frame);

  UIView *privrow = [self rowForSettingTitle:@"Privacy" yOrigin:lastY isCheck:NO];
  [scrollView addSubview:privrow];
  lastY = CGRectGetMaxY(privrow.frame);

  separator = [Separator horizontalSeparatorWithYOrigin:lastY];
  [scrollView addSubview:separator];
  lastY = CGRectGetMaxY(separator.frame);

  lastY += titleTopSpace;

  scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, lastY);
}

- (UIView *)rowForSettingTitle:(NSString *)settingTitle yOrigin:(CGFloat)yOrigin isCheck:(BOOL)isCheck {
  CGFloat rowHeight = 44;
  CGFloat width = self.view.bounds.size.width;
  UIView *settingView = [[UIView alloc] initWithFrame:CGRectMake(0, yOrigin, width, rowHeight)];
  settingView.backgroundColor = [UIColor whiteColor];

  UILabel *settingName = [[UILabel alloc] init];
  settingName.text = settingTitle;
  [settingName sizeToFit];
  CGFloat settingHeight = settingName.frame.size.height;
  settingName.frame = CGRectMake(kTextMargin, (rowHeight - settingHeight) / 2, 300, settingHeight);
  [settingView addSubview:settingName];

  NSString *imageName = @"check";
  if (!isCheck) {
    imageName = @"goArrow";
  }
  CGFloat imageSize = isCheck ? 38 : 25;
  CGFloat imagePadding = (rowHeight - imageSize) / 2;
  CGFloat horizontalPadding = isCheck ? 20 : imagePadding;
  UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(width - horizontalPadding - imageSize, imagePadding, imageSize, imageSize)];
  imageView.contentMode = UIViewContentModeScaleAspectFill;
  imageView.image = [UIImage imageNamed:imageName];
  [settingView addSubview:imageView];

  return settingView;
}

- (void)pushMyBills {
  UIViewController *vc = [[BillListViewController alloc] initWithTitle:@"My Bills" predicate:^BOOL(Bill *bill) {
    return bill.userVote != VoteStatusNoVote;
  } isRoot:NO];
  [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
