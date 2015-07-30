#import <Cordova/CDV.h>
#import <Cordova/CDVPlugin.h>

#import "SPRTPrinter.h"

@interface CDVSPRTPrinterPlugin : CDVPlugin{
    
}
-(void)printImageData:(CDVInvokedUrlCommand *)command;
-(void)printBarcode:(CDVInvokedUrlCommand *)command;
@end
