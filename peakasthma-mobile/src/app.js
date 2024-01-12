var app = angular.module('willowPeakAsthmaHyrbid', ['ui.bootstrap', 'ui.router', 'ngAnimate', 'ngTouch', 'authentication', 'willowApi', 'pascalprecht.translate', 'mobileComponents', 'walkthrough', 'dashboard', 'asthmaZone', 'pa.firebase']);
angular.module('willowPeakAsthmaHyrbid').config(function($stateProvider, $urlRouterProvider, $translateProvider) {

    /* Add New States Above */
    $urlRouterProvider.otherwise('/dashboard');

    $translateProvider.preferredLanguage('en');

    // Get rid of the 300ms delay
    // $touchProvider.ngClickOverrideEnabled(true);
});

// Commented For Development
app.run(function ($window, $rootScope, $log, $state, backTransitionService, $http, $uibModalStack, apiEndpoints) {
    var timeout;
    var inactive_time = 1200000;
    returnToLogin();
    
    function logout_timer (inactive_time) {
        return setTimeout(function () {
            console.log("done!");
            returnToLogin();
        }, inactive_time);
    }
    
    function returnToLogin() {
        $http({
          method: 'GET',
          url:  apiEndpoints.user.logout,
        }).then(function successfulLogOut(response) {
            console.log(response);
            console.log("Session cleared!");
            return response;
        }, function failedLogOut(response) {
            console.log(response);
            console.log("Session cleared!");
            return response;
        }).finally(function() {
            $window.localStorage.removeItem('authToken');
            $window.localStorage.removeItem('userId');
            getCookies();
            clearCookies();
            getCookies();
            backTransitionService.goBack();
            $state.go('login');
        });
    }
    
    $window.addEventListener('touchend', function() {
        console.log('Reset Timer');
        getCookies();
        $window.clearTimeout(timeout);
        timeout = logout_timer(inactive_time);
    });

    function clearCookies () {
        $window.cookieMaster.clearCookies(
        function() {
            console.log('Cookies have been cleared');
        },
        function() {
            console.log('Cookies could not be cleared');
        });
    }

    function getCookies() {
        cookie_value = null;
        $window.cookieMaster.getCookieValue("https://peakasthma.org", "_rails_app_session", 
                function(data) {
                    console.log('Cookies have been found');
                    cookie_value = data.cookieValue;
                    console.log(cookie_value);
                },
                function(error) {
                    console.log('Cookies could not be found');
                });
        return cookie_value;
    }
    
    $rootScope.spinner = document.getElementsByClassName("spinner")[0];
    $rootScope.spinner.style.display = 'none';
});
