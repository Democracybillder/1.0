#import "ShareViewController.h"
#import "Header.h"


@interface ShareViewController()

@end

@implementation ShareViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  self.view.backgroundColor = [UIColor colorWithRed:236./255 green:239./255 blue:245./255 alpha:1];

  Header *header = [[Header alloc] initWithWidth:self.view.bounds.size.width title:@"Share" hasSettings:NO hasCloseButton:YES];
  [self.view addSubview:header];

  UIImage *pageImage = [UIImage imageNamed:@"sharePage"];
  CGFloat whRatio = pageImage.size.height / pageImage.size.width;
  UIImageView *webView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(header.frame), self.view.bounds.size.width, self.view.bounds.size.width * whRatio)];
  [self.view addSubview:webView];
  webView.image = pageImage;
}

@end
