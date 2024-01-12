angular.module('walkthrough', ['ui.bootstrap','ui.router','ngAnimate','pascalprecht.translate']);
angular.module('walkthrough').config(function($stateProvider, $translateProvider) {

    $stateProvider.state('walkthrough', {
        url: '/walkthrough',
        templateUrl: 'src/walkthrough/views/walkthrough/walkthrough.html'
    });
    /* Add New States Above */

    $translateProvider.translations('en', {
        walkthrough: {
          common: {
            get_started: "Get Started",
            skip: "Skip"
          },
          slides: {
            first: {
              header: 'Easy Asthma Management',
              description: 'Peak asthma is an easy way to keep your asthma under control at all times.'
            },
            second: {
              header: 'Track Your Symptoms',
              description: 'Record your symptoms with a simple tap of the screen and we\'ll keep a log for you.'
            },
            third: {
              header: 'Peak Flow Tracking',
              description: 'Simply record your peak flow each day and we\'ll guide you through the next steps.'
            },
            fourth: {
              header: 'Request Help If Needed',
              description: 'If you\'re asthma is really troubling you, a provider can be ready to assist at moments notice.'
            }
          }
        }
    });

});
