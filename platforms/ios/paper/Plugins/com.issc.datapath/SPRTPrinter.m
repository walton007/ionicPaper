#import "SPRTPrinter.h"

#define MFi_SPP_Protocol @"com.issc.datapath"
#define PACKAGE_SIZE 1024

static SPRTPrinter *g_SPRTPrinter = nil;

@interface SPRTPrinter (SPRTPrinterPrivateMethods)
- (BOOL) openAcessory;
- (void) closeAcessory;
- (void) writeDataToOutputStream;
@end

@implementation SPRTPrinter

@synthesize m_session;
@synthesize m_accessory;

- (id) init {
    if (self = [super init])
    {
        m_session = NULL;
        m_accessory = NULL;
        m_isOpen = false;
        [self resetSendData];
    }
    
    return self;
}


+ (SPRTPrinter*) getInstance {
    if ( g_SPRTPrinter == nil )
    {
        @synchronized( self )
        {
            if ( g_SPRTPrinter == nil )
            {
                g_SPRTPrinter = [[SPRTPrinter alloc] init];
                
                if ( g_SPRTPrinter != nil )
                {
                    [g_SPRTPrinter openAcessory];
                }
                else
                {
                    NSLog(@"Failed to create singleton instance of SPRTPrinter");
                }
            }
        }
    }
    
    return g_SPRTPrinter;
}

- (void) close {
    NSLog(@"SPRTPrinter close");

    
    [[EAAccessoryManager sharedAccessoryManager] unregisterForLocalNotifications];
    [self closeAcessory];
}

- (void) printBarcode: (void (^)(BOOL result, NSError *error))resultCallback  {
    NSLog(@"SPRTPrinter printBarcode");
    [self resetSendData];
    
    Byte byte[] = {29,72,2,29,104,100,29,107,73,10,123,66,78,111,46,123,67,12,34,56};
    
    // fill printing data
    m_outgoingData = [NSMutableData dataWithBytes:byte length:20];
    NSString *rawString3 = @"\n\n";
    NSData *ndata = [rawString3  dataUsingEncoding:NSMacOSRomanStringEncoding] ;
    [m_outgoingData appendData:ndata];
    
    
    [self writeDataToOutputStream];
    
    m_printResultCallback = resultCallback;
}


- (void)printeImage:(UIImage *) newImage resultCallback: (void (^)(BOOL result, NSError *error))resultCallback  {
    NSLog(@"SPRTPrinter printeImage");
    [self resetSendData];

    
    CGImageRef imageref = [newImage CGImage];
    CGColorSpaceRef colorspace=CGColorSpaceCreateDeviceRGB();
    
    int width= CGImageGetWidth(imageref);
    int height = CGImageGetHeight(imageref);
    int bytesPerPixel=4;
    int bytesPerRow=bytesPerPixel*width;
    int bitsPerComponent = 8;
    int intPointValue = 0;
    int s = 0;
    unsigned char * imagedata=malloc(width*height*bytesPerPixel);
    
    Byte * printdata=malloc((width / 8 + 4) * height);
    
    CGContextRef cgcnt = CGBitmapContextCreate(imagedata,
                                               width,
                                               height,
                                               bitsPerComponent,
                                               bytesPerRow,
                                               colorspace,
                                               kCGImageAlphaPremultipliedFirst);
    CGRect therect = CGRectMake(0, 0, width, height);
    CGContextDrawImage(cgcnt, therect, imageref);
    
    Byte *bitbuf = malloc(width / 8);
    
    int intPix = 0;
    
    int p0=0, p1=0, p2=0, p3=0, p4=0, p5=0, p6=0, p7=0;
    for (int i = 0; i < height; i++) {
        for (int k = 0; k < width / 8 ; k++) {
            intPix = i * width * 4 + k * 8 * 4 + 1;
            intPointValue = imagedata[intPix];
            
            if (intPointValue == 255)
                p0 = 0;
            else {
                p0 = 1;
            }
            
            intPix = intPix + 4;
            intPointValue = imagedata[intPix];
            if (intPointValue == 255)
                p1 = 0;
            else {
                p1 = 1;
            }
            intPix = intPix + 4;
            intPointValue = imagedata[intPix];
            if (intPointValue == 255)
                p2 = 0;
            else {
                p2 = 1;
            }
            intPix = intPix + 4;
            intPointValue = imagedata[intPix];
            if (intPointValue == 255)
                p3 = 0;
            else {
                p3 = 1;
            }
            intPix = intPix + 4;
            intPointValue = imagedata[intPix];
            if (intPointValue == 255)
                p4 = 0;
            else {
                p4 = 1;
            }
            intPix = intPix + 4;
            intPointValue = imagedata[intPix];
            if (intPointValue == 255)
                p5 = 0;
            else {
                p5 = 1;
            }
            intPix = intPix + 4;
            intPointValue = imagedata[intPix];
            if (intPointValue == 255)
                p6 = 0;
            else {
                p6 = 1;
            }
            intPix = intPix + 4;
            intPointValue = imagedata[intPix];
            if (intPointValue == 255)
                p7 = 0;
            else {
                p7 = 1;
            }
            
            int value = p0 * 128 + p1 * 64 + p2 * 32 + p3 * 16 + p4 * 8
            + p5 * 4 + p6 * 2 + p7;
            bitbuf[k] = (Byte) value;
        }
        
        if (i!= 0)
            s += 1;
        
        printdata[s] = (Byte) 0x16;
        s += 1;
        printdata[s] = (Byte) (width / 8);
        for (int t = 0; t < width / 8; t++) {
            s += 1;
            printdata[s] = bitbuf[t];
        }
        s += 1;
        printdata[s] = (Byte) 0x15;
        s += 1;
        printdata[s] = (Byte) 0x01;
    }
    
    // fill printing data
    m_outgoingData = [NSMutableData dataWithBytes:printdata length:(width / 8 + 4) * height] ;
    
    NSString *rawString3 = @"\n\n";
    NSData *ndata = [rawString3  dataUsingEncoding:NSMacOSRomanStringEncoding];
    [m_outgoingData appendData:ndata];
    
    [self writeDataToOutputStream];

}

- (BOOL)isConnected {
    BOOL retVal = m_accessory && m_session;
    NSLog(@"SPRTPrinter isConnected %@", retVal ? @"yes" : @"no");
    return retVal;
}

#pragma mark - EAAccessoryDelegate
- (void)accessoryDidDisconnect:(EAAccessory *)theAccessory {
    NSLog(@"SPRTPrinter accessoryDidDisconnect");
    if (theAccessory == m_accessory) {
        [self setAccessory:NULL];
    }
}

#pragma mark - NSStreamDelegate
- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)streamEvent
{
    NSLog(@"SPRTPrinter stream handleEvent");
    
    
    
    switch (streamEvent) {
        case NSStreamEventHasBytesAvailable:
            break;
        case NSStreamEventHasSpaceAvailable:
            NSLog(@"SPRTPrinter NSStreamEventHasSpaceAvailable");
            // if m_printResultCallback and all data have been written
            [self writeDataToOutputStream];
            break;
        case NSStreamEventOpenCompleted:
            NSLog(@"SPRTPrinter NSStreamEventOpenCompleted");
            m_isOpen = TRUE;

            break;
        case NSStreamEventErrorOccurred:
            NSLog(@"SPRTPrinter NSStreamEventErrorOccurred");
            if (m_printResultCallback) {
                m_printResultCallback(FALSE, nil);
            }
            [self resetSendData];

            break;
        default:
            break;
    }
}

#pragma mark - Private methods
- (EAAccessory *)obtainAccessoryForProtocol:(NSString *)protocolString
{
    NSLog(@"SPRTPrinter obtainAccessoryForProtocol");
    NSArray *accessories = [[EAAccessoryManager sharedAccessoryManager]
                            connectedAccessories];
    
    EAAccessory *accessory = nil;
    
    for (EAAccessory *obj in accessories) {
        if ([[obj protocolStrings] containsObject:protocolString]) {
            accessory = obj;
            break;
        }
    }
    
    return accessory;
}

- (BOOL) tryQueryAccessory {
    NSLog(@"SPRTPrinter tryQueryAccessory");

    NSArray *accessories = [[EAAccessoryManager sharedAccessoryManager]
                            connectedAccessories];
    EAAccessory * _accessory = [self obtainAccessoryForProtocol: MFi_SPP_Protocol];
    if (_accessory != nil){
        [self setAccessory: _accessory];
        return YES;
    } else {
        return NO;
    }
}

- (BOOL) openAcessory {
    NSLog(@"open SPRTPrinter acessory");
    [[EAAccessoryManager sharedAccessoryManager] registerForLocalNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(acessoryDidConnectNotification:)
                                                 name:EAAccessoryDidConnectNotification
                                               object:NULL];
    return [self tryQueryAccessory];
}


- (void)acessoryDidConnectNotification:(NSNotification *)notification {
    NSLog(@"SPRTPrinter acessoryDidConnectNotification");
    if ([self isConnected]) {
        return;
    } else {
        [self tryQueryAccessory];
    }
}

- (void)setAccessory:(EAAccessory*)newAccessory {
    NSLog(@"SPRTPrinter setAccessory");
    if (newAccessory != m_accessory) {
        [m_accessory setDelegate:NULL];
        [self setSession:NULL];
        
        m_accessory = newAccessory;
        [m_accessory setDelegate:self];
        
        if (m_accessory) {
            EASession *newSession = [[EASession alloc] initWithAccessory:m_accessory
                                                             forProtocol:MFi_SPP_Protocol];
            [self setSession:newSession];
            
        }
    }
    
    if (newAccessory == NULL) {
        m_isOpen = false;
    }
}

- (void)setSession:(EASession*)newSession {
    NSLog(@"SPRTPrinter setSession");
    if (m_session) {
        [[m_session inputStream] close];
        [[m_session inputStream] removeFromRunLoop:[NSRunLoop currentRunLoop]
                                           forMode:NSDefaultRunLoopMode];
        [[m_session outputStream] close];
        [[m_session outputStream] removeFromRunLoop:[NSRunLoop currentRunLoop]
                                            forMode:NSDefaultRunLoopMode];
    }
    m_session = newSession;
    
    if (m_session) {
        [[m_session inputStream] setDelegate:self];
        [[m_session inputStream] scheduleInRunLoop:[NSRunLoop currentRunLoop]
                                         forMode:NSDefaultRunLoopMode];
        [[m_session inputStream] open];
        [[m_session outputStream] setDelegate:self];
        [[m_session outputStream] scheduleInRunLoop:[NSRunLoop currentRunLoop]
                                          forMode:NSDefaultRunLoopMode];
        [[m_session outputStream] open];
    }
}


- (void)writeDataToOutputStream {
    NSLog(@"SPRTPrinter writeDataToOutputStream");
    
    if ([[m_session outputStream] hasSpaceAvailable]) {
        //We need some good algorithm here
        int data_len = [m_outgoingData length];
        if (data_len > 0 ) {
            //        NSLog(@"writeDataOutputStream length>0");
            uint8_t *readBytes = (uint8_t *)[m_outgoingData mutableBytes];
            readBytes += m_sendByteIndex;
            
            unsigned int sendLength = ((data_len - m_sendByteIndex >= PACKAGE_SIZE) ?
                                PACKAGE_SIZE : (data_len - m_sendByteIndex));
            
            NSInteger bytesWritten = [[m_session outputStream] write:(const uint8_t *)readBytes
                                                           maxLength:sendLength];
            m_sendByteIndex += bytesWritten;
            if (m_sendByteIndex >= data_len) {
                // send finish
                if (m_printResultCallback) {
                    m_printResultCallback(TRUE, nil);
                    [self resetSendData];
                }
            }
        }
    }
}

- (void) closeAcessory {
    [self setSession: NULL];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:nil object:nil];
    [self resetSendData];
}

- (void) resetSendData {
    m_printResultCallback = nil;
    m_sendByteIndex = 0;
    m_outgoingData = NULL;
}

@end
