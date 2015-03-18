#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
  BillScopeFederal,
  BillScopeState,
  BillScopeCity
} BillScope;

typedef enum {
  VoteStatusNoVote,
  VoteStatusYes,
  VoteStatusNo,
} VoteStatus;


@interface Bill : NSObject

@property(nonatomic) NSString *billId;
@property(nonatomic) NSString *imageUrl;
@property(nonatomic) NSArray *translations;
@property(nonatomic) NSString *voteDate;
@property(nonatomic) BillScope scope;
@property(nonatomic) VoteStatus userVote;
@property(nonatomic) VoteStatus govVote;

- (UIColor *)fillColor;
+ (UIColor *)colorForVoteStatus:(VoteStatus)voteStatus;
+ (UIColor *)colorForScope:(BillScope)scope;

@end
