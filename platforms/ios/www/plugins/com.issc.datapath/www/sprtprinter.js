cordova.define("com.issc.datapath.sprtprinter", function(require, exports, module) {

               var argscheck = require('cordova/argscheck'),
               channel = require('cordova/channel'),
               utils = require('cordova/utils'),
               exec = require('cordova/exec'),
               cordova = require('cordova');
               
    var sprtprinter = function() {};
               
    sprtprinter.printImageData = function() {
        exec(null, null, "SPRTPrinter", "printImageData", []);
    };
               
    sprtprinter.printBarcode = function() {
        exec(null, null, "SPRTPrinter", "printBarcode", []);
    };

               
    module.exports = sprtprinter;
});
