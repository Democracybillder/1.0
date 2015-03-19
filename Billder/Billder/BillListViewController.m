#import "BillListViewController.h"

#import "Bill.h"
#import "BillSummaryView.h"
#import "ExpandedBillViewController.h"
#import "Header.h"
#import "RootViewController.h"

static const NSUInteger kNumberOfBillsPerInitialRequest = 24;
static const NSUInteger kNumberOfBillsPerAdditionalRequest = 12;

static const CGFloat kRowSlideAnimationDuration = 0.5;
static const CGFloat kRowFadeAnimationDelay = 0.25;

static NSString *const kBillSummaryViewReuseableIdentifier = @"kBillSummaryViewReuseableIdentifier";
static NSString *const kLoadingViewReuseableIdentifier = @"kLoadingViewReuseableIdentifier";

static NSString *const kPullToLoadText = @"Pull to load";
static NSString *const kLoadingText = @"Loading...";
static NSString *const kFullyLoadedText = @"Nothing to see here";

@interface BillListViewController () <BillSummaryViewDelegate>

@property(nonatomic) BOOL loading;
@property(nonatomic) BOOL loadedEverything;


@end

@implementation BillListViewController {
  UITableView *_tableView;
  BOOL _isRoot;
  NSString *_title;
  BOOL (^_predicate)(Bill *bill);
  NSMutableArray *_billsToDisplay;
  UITableViewCell *_loadingCell;

}

- (instancetype)initWithTitle:(NSString *)title
                    predicate:(BOOL (^)(Bill *bill))predicate
                       isRoot:(BOOL)isRoot {
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
  Header *header = [[Header alloc] initWithWidth:self.view.bounds.size.width
                                           title:_title
                                     hasSettings:YES
                                  hasCloseButton:!_isRoot];
  [self.view addSubview:header];

  _tableView = [[UITableView alloc] initWithFrame:CGRectMake(
      0,
      CGRectGetMaxY(header.frame),
      self.view.bounds.size.width,
      self.view.bounds.size.height - CGRectGetMaxY(header.frame))
                style:UITableViewStylePlain];
  _tableView.backgroundColor = [UIColor colorWithRed:230.0/255.0
                                                green:230.0/255.0
                                                 blue:230.0/255.0
                                                alpha:1];
  _tableView.bounces = YES;
  _tableView.alwaysBounceVertical = YES;
  _tableView.delegate = self;
  _tableView.dataSource = self;
  _tableView.rowHeight = kBillSummaryRowHeight;
  _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  
  [self.view addSubview:_tableView];

  NSMutableArray *filteredList = [NSMutableArray array];
  for (Bill *bill in [[RootViewController sharedInstance] bills]) {
    if (_predicate(bill)) {
      [filteredList addObject:bill];
    }
  }
  _billsToDisplay = filteredList;
}

- (void)setLoading:(BOOL)loading {
  if (loading == _loading) return;
  _loading = loading;
  [self updateLoadingText];
  if (_loading) {
    [self fetchMoreBills];
  }
}

- (void)updateLoadingText {
  NSString *text;
  if (_loadedEverything) {
    text = kFullyLoadedText;
  } else if (_loading) {
    text = kLoadingText;
  } else {
    text = kPullToLoadText;
  }
  _loadingCell.textLabel.text = text;
}

- (void)fetchMoreBills {
  NSMutableArray *filteredList = [NSMutableArray array];
  for (Bill *bill in [[RootViewController sharedInstance] bills]) {
    if (_predicate(bill)) {
      [filteredList addObject:bill];
    }
  }
  if (filteredList.count == 0) { // This should be moved to before filtering when
    self.loadedEverything = YES;
  }
  [self updateLoadingText];
  [self addBills:filteredList];
}

- (void)addBills:(NSArray *)newBills {
  [_billsToDisplay addObjectsFromArray:newBills];

  NSIndexPath *loadingPath = [_tableView indexPathForCell:_loadingCell];
  NSIndexPath *newLoadingPath = [NSIndexPath indexPathForRow:_billsToDisplay.count
                                                   inSection:0];

  NSMutableArray *newIndexes = [NSMutableArray array];
  for (NSUInteger i = loadingPath.row; i <= newLoadingPath.row; ++i) {
    [newIndexes addObject:[NSIndexPath indexPathForRow:i inSection:0]];
  }

  [_tableView beginUpdates];
  [_tableView deleteRowsAtIndexPaths:@[loadingPath] withRowAnimation:UITableViewRowAnimationTop];
  [_tableView insertRowsAtIndexPaths:newIndexes withRowAnimation:UITableViewRowAnimationBottom];
  [_tableView endUpdates];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return _billsToDisplay.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSUInteger rowIndex = indexPath.row;
  if (rowIndex < _billsToDisplay.count) {
    BillSummaryView *summaryCell =
        (BillSummaryView *)[tableView dequeueReusableCellWithIdentifier:kBillSummaryViewReuseableIdentifier];
    if (summaryCell == nil) {
      summaryCell = [[BillSummaryView alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:kBillSummaryViewReuseableIdentifier];
      summaryCell.selectionStyle = UITableViewCellSelectionStyleNone;
      summaryCell.enableListGestures = YES;
      summaryCell.delegate = self;
    }
    [summaryCell resetView];
    summaryCell.bill = _billsToDisplay[rowIndex];
    return summaryCell;
  } else {
    _loadingCell = [tableView dequeueReusableCellWithIdentifier:kLoadingViewReuseableIdentifier];
    if (_loadingCell == nil) {
      _loadingCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:kLoadingViewReuseableIdentifier];
      _loadingCell.selectionStyle = UITableViewCellSelectionStyleNone;
      [self updateLoadingText];
    }
    return _loadingCell;
  }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  if (scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height) {
    [self setLoading:YES];
  } else {
    [self setLoading:NO];
  }
}

#pragma mark - BillSummaryViewDelegate

- (void)billSummaryViewWasSwiped:(BillSummaryView *)summaryView {
  summaryView.votingColor = [Bill colorForVoteStatus:summaryView.bill.userVote];

  CGRect destination = summaryView.containerView.frame;
  if (summaryView.bill.userVote == VoteStatusYes) {
    destination.origin.x += summaryView.containerView.frame.size.width;
  } else {
    destination.origin.x -= summaryView.containerView.frame.size.width;
  }

  BOOL willRemoveSummaryView = !_predicate(summaryView.bill);

  [UIView animateWithDuration:kRowSlideAnimationDuration
                   animations:^{
                     summaryView.containerView.frame = destination;
                     summaryView.containerView.alpha = 0;
                   } completion:^(BOOL finished) {
                     if (!willRemoveSummaryView) {
                       [summaryView resetView];
                       // Update the appearance to the new bill attributes.
                       summaryView.bill = summaryView.bill;
                     }
                   }];

  if (willRemoveSummaryView) {
    [self performSelector:@selector(removeSummaryView:)
               withObject:summaryView
               afterDelay:kRowFadeAnimationDelay];
  }
}

- (void)removeSummaryView:(BillSummaryView *)summaryView {
  NSIndexPath *rowIndexPath = [_tableView indexPathForCell:summaryView];
  [_billsToDisplay removeObjectAtIndex:rowIndexPath.row];
  [_tableView deleteRowsAtIndexPaths:@[rowIndexPath]
                    withRowAnimation:UITableViewRowAnimationTop];
}

@end
