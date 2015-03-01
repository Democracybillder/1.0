#import "BillListViewController.h"

#import "Bill.h"
#import "BillListView.h"
#import "Header.h"
#import "RootViewController.h"

@interface BillListViewController ()

@end

@implementation BillListViewController {
  UIScrollView *_scrollView;
  BillListView *_listView;
  BOOL _isRoot;
  NSString *_title;
  BOOL (^_predicate)(Bill *bill);
}

- (instancetype) initWithTitle:(NSString *)title predicate:(BOOL (^)(Bill *bill))predicate isRoot:(BOOL)isRoot {
  self = [self initWithNibName:nil bundle:nil];
  if (self) {
    _predicate = predicate;
    _title = title;
    _isRoot = isRoot;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  Header *header = [[Header alloc] initWithWidth:self.view.bounds.size.width title:_title hasSettings:YES hasCloseButton:!_isRoot];
  [self.view addSubview:header];

  _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(header.frame), self.view.bounds.size.width, self.view.bounds.size.height - CGRectGetMaxY(header.frame))];
  _scrollView.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1];
  _scrollView.bounces = YES;
  _scrollView.alwaysBounceVertical = YES;
  [self.view addSubview:_scrollView];

  NSMutableArray *filteredList = [NSMutableArray array];
  for (Bill *bill in [[RootViewController sharedInstance] bills]) {
    if (_predicate(bill)) {
      [filteredList addObject:bill];
    }
  }

  _listView = [[BillListView alloc] initWithBills:filteredList
                                            width:_scrollView.frame.size.width
                                       canDismiss:_isRoot];
  _listView.delegate = self;
  [_scrollView addSubview:_listView];
  [self resizeScrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)resizeScrollView {
  _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, _listView.frame.size.height);
}

@end
