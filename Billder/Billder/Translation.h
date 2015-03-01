#import <Foundation/Foundation.h>

@interface Translation : NSObject

@property(nonatomic) NSString *title;
@property(nonatomic) NSUInteger upvotes;

+ (instancetype)translationWithTitle:(NSString *)title upvotes:(NSUInteger)upvotes;

@end
