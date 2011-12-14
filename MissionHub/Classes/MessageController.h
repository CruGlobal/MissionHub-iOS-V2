#import "SearchTestController.h"

@class MockDataSource;

@interface MessageController : TTViewController
<TTMessageControllerDelegate> {
    NSTimer* _sendTimer;
}

@end

