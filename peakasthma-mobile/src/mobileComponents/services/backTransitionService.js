angular.module('mobileComponents').service('backTransitionService',function($rootScope) {

  var _this = this;
  this.backTransition = false;

  this.goBack = function() {
    _this.backTransition = true;
  };

  this.clearBackTransition = function() {
    _this.backTransition = false;
  };

});
