#import "ShareViewController.h"

#import "Header.h"

static NSString * const kSampleShareURL = @"https://www.facebook.com/sharer/sharer.php?app_id=309437425817038&u=http%3A%2F%2Fwww.scribd.com%2Fdoc%2F252841257%2FNet-Neutrality-legislation&display=popup&ref=plugin";

@interface ShareViewController()

@end

@implementation ShareViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.

  Header *header = [[Header alloc] initWithWidth:self.view.bounds.size.width title:@"Share" hasSettings:NO hasCloseButton:YES];
  [self.view addSubview:header];

  UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(header.frame), self.view.bounds.size.width, self.view.bounds.size.height - CGRectGetMaxY(header.frame))];
  [self.view addSubview:webView];

  NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:kSampleShareURL]];
  [webView loadRequest:urlRequest];
}

@end
