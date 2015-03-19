#import "Bill.h"

@implementation Bill

- (UIColor *)fillColor {
  if (self.userVote != VoteStatusNoVote) {
    return [Bill colorForVoteStatus:self.userVote];
  } else {
    return [Bill colorForScope:self.scope];
  }
}

+ (UIColor *)colorForVoteStatus:(VoteStatus)voteStatus {
  switch (voteStatus) {
    case VoteStatusNo:
      return [UIColor colorWithRed:249.0/255.0 green:1.0/255.0 blue:1.0/255 alpha:1];
    case VoteStatusYes:
      return [UIColor colorWithRed:0.0/255.0 green:147.0/255.0 blue:59.0/255 alpha:1];
    default:
      return [UIColor whiteColor];
      break;
  }
}

+ (UIColor *)colorForScope:(BillScope)scope {
  switch (scope) {
    case BillScopeFederal:
      return [UIColor colorWithRed:53.0/255.0 green:122.0/255.0 blue:232.0/255 alpha:1];
    case BillScopeState:
      return [UIColor colorWithRed:45.0/255.0 green:45.0/255.0 blue:45.0/255 alpha:1];
    case BillScopeCity:
      return [UIColor colorWithRed:92.0/255.0 green:15.0/255.0 blue:184.0/255 alpha:1];
  }
}

@end
