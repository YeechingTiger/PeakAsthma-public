angular.module('authentication').factory('authResponseInterceptor',function($window, backTransitionService, $state, $q) {

    var authTokenInterceptor = {};

    function clearTokens() {
      $window.localStorage.removeItem('authToken');
      $window.localStorage.removeItem('userId');
    }

    authTokenInterceptor.request = function configureAuthToken(config) {
      var authToken = $window.localStorage.getItem('authToken');
      var userId = $window.localStorage.getItem('userId');

      if (authToken && userId) {
        config.headers.Authorization = 'Token token=' + authToken + ', id=' + userId;
      }

      return config;
    };

    authTokenInterceptor.responseError = function verifyCorrectlyAuthed(response) {
      if (response.status === 401) {
        console.log(response);
        backTransitionService.goBack();
        $state.go('login');
        return $q.reject(response);
      }

      return response;
    };

    return authTokenInterceptor;

});