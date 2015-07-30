cordova.define('cordova/plugin_list', function(require, exports, module) {
module.exports = [
    {
        "file": "plugins/cordova-plugin-device/www/device.js",
        "id": "cordova-plugin-device.device",
        "clobbers": [
            "device"
        ]
    },
    {
        "file": "plugins/cordova-plugin-inappbrowser/www/inappbrowser.js",
        "id": "cordova-plugin-inappbrowser.inappbrowser",
        "clobbers": [
            "cordova.InAppBrowser.open",
            "window.open"
        ]
    },
    {
        "file": "plugins/com.phonegap.plugins.PushPlugin/www/PushNotification.js",
        "id": "com.phonegap.plugins.PushPlugin.PushNotification",
        "clobbers": [
            "PushNotification"
        ]
    },
    {
        "file": "plugins/com.ionic.keyboard/www/keyboard.js",
        "id": "com.ionic.keyboard.keyboard",
        "clobbers": [
            "cordova.plugins.Keyboard"
        ]
    },
    {
        "file": "plugins/nl.x-services.plugins.sslcertificatechecker/www/SSLCertificateChecker.js",
        "id": "nl.x-services.plugins.sslcertificatechecker.SSLCertificateChecker",
        "clobbers": [
            "window.plugins.sslCertificateChecker"
        ]
    },
                  {
                  "file": "plugins/com.issc.datapath/www/sprtprinter.js",
                  "id": "com.issc.datapath.sprtprinter",
                  "clobbers": [
                               "cordova.plugins.sprtprinter"
                               ]
                  }
];
module.exports.metadata = 
// TOP OF METADATA
{
    "cordova-plugin-whitelist": "1.0.0",
    "cordova-plugin-device": "1.0.0",
    "cordova-plugin-inappbrowser": "1.0.0",
    "com.phonegap.plugins.PushPlugin": "2.4.0",
    "com.ionic.keyboard": "1.0.4",
    "cordova-plugin-crosswalk-webview": "1.2.0",
    "nl.x-services.plugins.sslcertificatechecker": "3.5.0"
}
// BOTTOM OF METADATA
});