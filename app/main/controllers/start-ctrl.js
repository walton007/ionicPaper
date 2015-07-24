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
