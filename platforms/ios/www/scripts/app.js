'use strict';
angular.module('main', [
  'ionic',
  'ngCordova',
  'ui.router',
  // TODO: load other modules selected during generation
])
.config(function ($stateProvider, $urlRouterProvider) {

  console.log('Allo! Allo from your module: ' + 'main');

  $urlRouterProvider.otherwise('/main');

  // some basic routing
  $stateProvider
    .state('main', {
      url: '/main',
      templateUrl: 'main/templates/start.html',
      controller: 'StartCtrl as start'
    });
  // TODO: do your thing
})
.run(function ($ionicPlatform, $cordovaPush, $rootScope) {
  console.log(1111);

  $ionicPlatform.ready(function () {
    if (window.cordova && window.cordova.plugins.Keyboard) {
      cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true);
    }
                       
                       if (window.cordova && window.cordova.plugins.sprtprinter) {
//                       cordova.plugins.sprtprinter.hideKeyboardAccessoryBar(true);
                       }

    if (window.StatusBar) {
      // Set the statusbar to use the default style, tweak this to
      // remove the status bar on iOS or change it to use white instead of dark colors.
      StatusBar.styleDefault();
    }

    if ($ionicPlatform.is('ios')) {
      var iosConfig = {
        'badge': true,
        'sound': true,
        'alert': true,
      };
      $cordovaPush.register(iosConfig).then(function (result) {
        // Success -- send deviceToken to server, and store for future use
        console.log('deviceToken: ' + result);
        $rootScope.deviceToken = result;
        //$http.post('http://server.co/', {user: 'Bob', tokenID: result.deviceToken})
      }, function (err) {
        alert('Registration error: ' + err);
      });
    }
  });

  $rootScope.$on('$cordovaPush:notificationReceived', function (event, notification) {
    console.log('notificationReceived:', notification);
    if (notification.alert) {
      navigator.notification.alert(notification.alert);
    }

    if (notification.sound) {
      var snd = new Media(event.sound);
      snd.play();
    }

    if (notification.badge) {
      $cordovaPush.setBadgeNumber(notification.badge).then(function (result) {
        // Success!
        console.log(result);
      }, function (err) {
        // An error occurred. Show a message to the user
        console.error(err);
      });
    }
  });
});

'use strict';
angular.module('main')
.service('Start', function () {
  console.log('Hello from your Service: Start in module main');

  var server = "https://cnpvgvb1ep140.pvgl.sap.corp:29900/";
  var fingerprint = "37 97 FA 9B 70 DA 8C D5 B3 EF 19 99 1D D3 34 7D E0 7A F8 1C";

  // some initial data
  this.someData = {
    binding: 'Yes! Got that databinding working'
  };

  // TODO: do your service thing
  this.testCertConnect = function () {
//  	window.plugins.sslCertificateChecker.check(
//          successCallback,
//          errorCallback,
//          server,
//          fingerprint);
         
         if (window.cordova && window.cordova.plugins.sprtprinter) {
                                cordova.plugins.sprtprinter.printBarcode();
         }

   function successCallback(message) {
     alert(message);
     // Message is always: CONNECTION_SECURE.
     // Now do something with the trusted server.
   }

   function errorCallback(message) {
     alert(message);
     if (message == "CONNECTION_NOT_SECURE") {
       // There is likely a man in the middle attack going on, be careful!
     } else if (message.indexOf("CONNECTION_FAILED") >- 1) {
       // There was no connection (yet). Internet may be down. Try again (a few times) after a little timeout.
     }
   }
  }
});

'use strict';
angular.module('main')
.controller('StartCtrl', function (Start, Config) {

  // bind data from service
  this.someData = Start.someData;
  this.ENV = Config.ENV;
  this.BUILD = Config.BUILD;
  this.doTest = function () {
  	// alert(11);
  	Start.testCertConnect();
  };

  console.log('Hello from your Controller: StartCtrl in module main:. This is your controller:', this);
  // TODO: do your controller thing
});

'use strict';
angular.module('main')
.constant('Config', {

  // gulp environment: injects environment vars
  // https://github.com/mwaylabs/generator-m#gulp-environment
  ENV: {
    /*inject-env*/
    'SERVER_URL': 'https://DEVSERVER/api'
    /*endinject*/
  },

  // gulp build-vars: injects build vars
  // https://github.com/mwaylabs/generator-m#gulp-build-vars
  BUILD: {
    /*inject-build*/
    /*endinject*/
  }

});

'use strict';
angular.module('paper', [
  // your modules
  'main'
]);
