#import "CDVSPRTPrinterPlugin.h"
#import "SPRTPrinter.h"
#import <Cordova/CDV.h>
#import <Cordova/CDVPluginResult.h>

@implementation CDVSPRTPrinterPlugin

- (void)pluginInitialize
{
}

-(void)printBarcode:(CDVInvokedUrlCommand *)command
{
    NSLog(@"@@@@ SPRT printBarcode");

    SPRTPrinter* gSPRTPrinter = [SPRTPrinter getInstance];
    
    if ([gSPRTPrinter isConnected]) {
        [gSPRTPrinter printBarcode: ^(BOOL result, NSError *error) {
            if (result) {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            } else {
                CDVPluginResult* _result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
                [self.commandDelegate sendPluginResult:_result callbackId: command.callbackId];
            };
        }];
    } else {
        
    }
}

-(void)printImageData:(CDVInvokedUrlCommand *)command{
    NSLog(@"@@@@ SPRT printImageDataX");
    
    
    SPRTPrinter* gSPRTPrinter = [SPRTPrinter getInstance];
    if ([gSPRTPrinter isConnected]) {
        NSString* base64String =(NSString*)[command argumentAtIndex:0];
        NSData* data = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
        UIImage* image = [UIImage imageWithData:data];
        [gSPRTPrinter printeImage:image resultCallback: ^(BOOL result, NSError *error) {
            if (result) {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            } else {
                CDVPluginResult* _result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
                [self.commandDelegate sendPluginResult:_result callbackId: command.callbackId];
            };
        }];
    } else {
        
    }
    
}

@end
