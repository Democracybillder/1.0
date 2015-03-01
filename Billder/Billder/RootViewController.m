#import "RootViewController.h"

#import "Bill.h"
#import "BillListViewController.h"
#import "SettingsViewController.h"
#import "Translation.h"

@interface RootViewController ()

@property(nonatomic) UINavigationController *paneNavigationController;

@end

@implementation RootViewController {
  BillListViewController *_blVC;
}

- (instancetype)init {
  self = [self initWithNibName:nil bundle:nil];
  if (self) {
    _paneNavigationController = [[UINavigationController alloc] init];
    [self addChildViewController:_paneNavigationController];
    [_paneNavigationController didMoveToParentViewController:self];
    _paneNavigationController.navigationBar.hidden = YES;

    NSMutableArray *bills = [NSMutableArray array];
    //Hacky stuff for now:
    NSArray *imageUrls = @[@"http://i2.cdn.turner.com/cnn/dam/assets/130704041649-sesame-street-muppet-elmo-horizontal-gallery.jpg",
                           @"http://www.themillions.com/wp-content/uploads/2012/10/570_big-bird-wins.jpg",
                           @"http://i2.cdn.turner.com/cnn/dam/assets/130704041649-sesame-street-muppet-elmo-horizontal-gallery.jpg",
                           @"http://i2.cdn.turner.com/cnn/dam/assets/130704041649-sesame-street-muppet-elmo-horizontal-gallery.jpg",
                           @"http://i2.cdn.turner.com/cnn/dam/assets/130704041649-sesame-street-muppet-elmo-horizontal-gallery.jpg",
                           @"http://i2.cdn.turner.com/cnn/dam/assets/130704041649-sesame-street-muppet-elmo-horizontal-gallery.jpg",
                           ];
    NSArray *billScopes = @[@(BillScopeFederal),
                            @(BillScopeState),
                            @(BillScopeCity),
                            @(BillScopeCity),
                            @(BillScopeCity),
                            @(BillScopeState),
                            ];
    NSArray *alternateDescriptions = @[@[[Translation translationWithTitle:@"Bill 1 with a really really really really long name" upvotes:200],
                                         [Translation translationWithTitle:@"Bill 1 AD1" upvotes:100],
                                         [Translation translationWithTitle:@"Bill 1 AD2" upvotes:50],
                                         ],
                                       @[[Translation translationWithTitle:@"Bill 2" upvotes:200],
                                         [Translation translationWithTitle:@"Bill 2 AD1" upvotes:100],
                                         [Translation translationWithTitle:@"Bill 2 AD2" upvotes:50],
                                         ],
                                       @[[Translation translationWithTitle:@"Bill 3" upvotes:200],
                                         [Translation translationWithTitle:@"Bill 3 AD1" upvotes:100],
                                         [Translation translationWithTitle:@"Bill 3 AD2" upvotes:50],
                                         ],
                                       @[[Translation translationWithTitle:@"Bill 3" upvotes:200],
                                         [Translation translationWithTitle:@"Bill 3 AD1" upvotes:100],
                                         [Translation translationWithTitle:@"Bill 3 AD2" upvotes:50],
                                         [Translation translationWithTitle:@"Bill 3 AD2" upvotes:50],
                                         [Translation translationWithTitle:@"Bill 3 AD2" upvotes:50],
                                         [Translation translationWithTitle:@"Bill 3 AD2" upvotes:50],
                                         [Translation translationWithTitle:@"Bill 3 AD2" upvotes:50],
                                         [Translation translationWithTitle:@"Bill 3 AD2" upvotes:50],
                                         [Translation translationWithTitle:@"Bill 3 AD2" upvotes:50],
                                         ],
                                       @[[Translation translationWithTitle:@"Bill 3" upvotes:200],
                                         [Translation translationWithTitle:@"Bill 3 AD1" upvotes:100],
                                         [Translation translationWithTitle:@"Bill 3 AD2" upvotes:50],
                                         ],
                                       @[[Translation translationWithTitle:@"Bill 3" upvotes:200],
                                         [Translation translationWithTitle:@"Bill 3 AD1" upvotes:100],
                                         [Translation translationWithTitle:@"Bill 3 AD2" upvotes:50],
                                         ],
                                       ];
    NSArray *govVote = @[@(VoteStatusNoVote),
                         @(VoteStatusNoVote),
                         @(VoteStatusYes),
                         @(VoteStatusNo),
                         @(VoteStatusNoVote),
                         @(VoteStatusNoVote),
                         ];
    NSArray *userVote = @[@(VoteStatusNoVote),
                         @(VoteStatusNoVote),
                         @(VoteStatusNo),
                         @(VoteStatusNo),
                         @(VoteStatusNoVote),
                         @(VoteStatusYes),
                         ];
    NSArray *voteDate = @[@"3/10",
                          @"3/13",
                          @"2/13",
                          @"2/13",
                          @"2/13",
                          @"2/13",
                          ];
    for (NSUInteger index = 0; index < imageUrls.count; ++index) {
      Bill *bill = [[Bill alloc] init];
      bill.imageUrl = imageUrls[index];
      bill.translations = alternateDescriptions[index];
      bill.voteDate = voteDate[index];
      bill.scope = [billScopes[index] intValue];
      bill.govVote = [govVote[index] intValue];
      bill.userVote = [userVote[index] intValue];

      [bills addObject:bill];
    }

    _bills = bills;
  }
  return self;
}

+ (instancetype)sharedInstance {
  static dispatch_once_t once;
  static id sharedInstance = nil;
  dispatch_once(&once, ^{
    sharedInstance = [[self alloc] init];
  });
  return sharedInstance;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  self.view.backgroundColor = [UIColor greenColor];

  [[UIApplication sharedApplication] setStatusBarHidden:YES
                                          withAnimation:UIStatusBarAnimationFade];

  _paneNavigationController.view.frame = self.view.bounds;
  _paneNavigationController.view.autoresizingMask =
  UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
  [self.view addSubview:_paneNavigationController.view];
  _paneNavigationController.view.backgroundColor = [UIColor redColor];

  _blVC = [[BillListViewController alloc] initWithTitle:@"Billder" predicate:^BOOL(Bill *bill) {
    return bill.userVote == VoteStatusNoVote && bill.govVote == VoteStatusNoVote;
  } isRoot:YES];
  [_paneNavigationController pushViewController:_blVC animated:NO];
}

- (void)pushSettings {
  UIViewController *settingsViewController = [[SettingsViewController alloc] init];
  [self.paneNavigationController pushViewController:settingsViewController animated:YES];
}

- (void)popPane {
  [self.paneNavigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
