#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController

@property(nonatomic, readonly) UINavigationController *paneNavigationController;
@property(nonatomic, readonly) NSArray *bills;

+ (id)sharedInstance;

- (void)pushSettings;
- (void)popPane;

@end

