#import <ExternalAccessory/ExternalAccessory.h>

@interface SPRTPrinter : NSObject <EAAccessoryDelegate, NSStreamDelegate> {
    NSMutableData *m_outgoingData;
    BOOL m_isOpen;
    unsigned int m_sendByteIndex;
    void (^m_printResultCallback)(BOOL result, NSError *error) ;
}

@property (nonatomic, retain) EASession *m_session;
@property (nonatomic, retain) EAAccessory *m_accessory;

+ (SPRTPrinter*) getInstance;

- (BOOL) isConnected;
- (void) printBarcode: (void (^)(BOOL result, NSError *error))resultCallback;
- (void)printeImage:(UIImage *) newImage resultCallback: (void (^)(BOOL result, NSError *error))resultCallback;
- (void) close;
@end
