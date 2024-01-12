angular.module('pa.firebase').service('pushNotificationService',function($window, $transitions, $http) {

  var _this = this;
  this.deviceToken = null;

  function initFireBaseHooks() {
    if ($window && $window['FCMPlugin']) {
      _this.FCMPlugin = $window['FCMPlugin'];
      _this.FCMPlugin.onTokenRefresh(setToken);
      _this.FCMPlugin.getToken(setToken);
    }
  }

  function setToken(token) {
    if (token) {
      console.log(token);
      _this.deviceToken = token;
      setDeviceKeyHeader();
    }
  }

  function setDeviceKeyHeader() {
    $http.defaults.headers.common['X-PeakAsthma-Device-Token'] = _this.deviceToken;
  }

  $window.document.addEventListener("deviceready", initFireBaseHooks, false);

});
