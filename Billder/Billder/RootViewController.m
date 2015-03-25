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
    NSArray *imageUrls = @[@"http://law.huji.ac.il/upload/Leslie.jpg",
                           @"http://www.vanleer.org.il/sites/files/image_field/VardaShiffer_2010.jpg",
                           @"http://www.education.ox.ac.uk/wordpress/wp-content/uploads/2012/04/Judy-Sebba.jpg",
                           @"http://www.thejc.com/files/imagecache/simchach_galleria/images/JCOS-Time-capsule-a114.jpg",
                           @"http://www.lib.cam.ac.uk/Taylor-Schechter/GF/21/sebba-reif.jpeg",
                           ];
    NSArray *billScopes = @[@(BillScopeFederal),
                            @(BillScopeState),
                            @(BillScopeCity),
                            @(BillScopeCity),
                            @(BillScopeCity),
                            @(BillScopeState),
                            ];
    NSArray *alternateDescriptions = @[@[[Translation translationWithTitle:@"Tea Party to Ban Coffee" upvotes:200],
                                         [Translation translationWithTitle:@"Finally congress will put an end to the world's most dangerous drug!" upvotes:100],
                                         [Translation translationWithTitle:@"Coffee apocalypse - coffee drinkers unite!" upvotes:50],
                                         ],
                                       @[[Translation translationWithTitle:@"Government trying to end domestic use of high fructose corn syrup" upvotes:200],
                                         [Translation translationWithTitle:@"The nut syrup lobby is taking over! American's unite behind corn." upvotes:100],
                                         [Translation translationWithTitle:@"President's wife invading RI with fructose ban" upvotes:50],
                                         ],
                                       @[[Translation translationWithTitle:@"New unicycle lane proposed between mall and downtown" upvotes:200],
                                         [Translation translationWithTitle:@"Circus lobby controlling PVD again - diverting funds from bi-to-uni-cycle transit." upvotes:100],
                                         [Translation translationWithTitle:@"Another offensive bill for non-cyclists. When will this abuse end??" upvotes:50],
                                         ],
                                       @[[Translation translationWithTitle:@"Providence bills Brown University for years of noise abuse" upvotes:200],
                                         [Translation translationWithTitle:@"Brown University neighbors have been complaining for years. Finally we see something in return" upvotes:100],
                                         [Translation translationWithTitle:@"City to build new noise capturing device over Brown University" upvotes:50],
                                         [Translation translationWithTitle:@"Providence trying to make Brown consider relocation through rediculous taxes - don't let this important job/tax center leave!" upvotes:50],
                                         [Translation translationWithTitle:@"A welcome punishment for Brown University (noise tax) for years of abuse, but doesn't disincentivise most important crime - smell" upvotes:50],
                                         [Translation translationWithTitle:@"Providence discriminating Chinese/ Spanish/ Hebrew/ French speakers of Brown University" upvotes:50],
                                         [Translation translationWithTitle:@"It's not that loud, get the mall for its noise!" upvotes:50],
                                         [Translation translationWithTitle:@"PVD selling CDs at discount price to Brown students" upvotes:50],
                                         [Translation translationWithTitle:@"Providence trying to take over the world with stolen monies from Brown University for a 'sound device'" upvotes:50],
                                         ],
                                       @[[Translation translationWithTitle:@"Mayoral candidate Smiley bans frowns" upvotes:200],
                                         [Translation translationWithTitle:@"secret evil deal between the Mayor and Smiley in exchange for mayorship" upvotes:100],
                                         [Translation translationWithTitle:@"Smiley's attack on frownies. Stand up PVD frownies, and fight!" upvotes:50],
                                         ],
                                       @[[Translation translationWithTitle:@"RI to ban 'hipsters' from downtown" upvotes:200],
                                         [Translation translationWithTitle:@"trying to prevent Brown's student body from purchasing their shaving needs downtown" upvotes:100],
                                         [Translation translationWithTitle:@"Finally I can walk my children safely in the streets of downtown" upvotes:50],
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
