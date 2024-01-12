angular.module('willowApi', ['ui.bootstrap','ui.router','ngAnimate']);
angular.module('willowApi').config(function($stateProvider, $httpProvider) {

    /* Add New States Above */
    $httpProvider.defaults.headers.common['X-Key-Inflection'] = 'camel';

});
