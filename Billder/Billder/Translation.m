#import "Translation.h"

@implementation Translation

+ (instancetype)translationWithTitle:(NSString *)title upvotes:(NSUInteger)upvotes {
  Translation *translation = [[self alloc] init];
  translation.title = title;
  translation.upvotes = upvotes;
  return translation;
}

@end
