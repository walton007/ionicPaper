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

    if (window.StatusBar) {
      // Set the statusbar to use the default style, tweak this to
      // remove the status bar on iOS or change it to use white instead of dark colors.
      StatusBar.styleDefault();
    }

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
