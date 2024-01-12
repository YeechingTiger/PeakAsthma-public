angular.module('authentication', ['ui.bootstrap','ui.router','ngAnimate','willowApi','pascalprecht.translate','mobileComponents']);
angular.module('authentication').config(function($stateProvider, $httpProvider, $translateProvider) {

    $stateProvider.state('login', {
        url: '/login',
        templateUrl: 'src/authentication/views/login/login.html'
    });
    /* Add New States Above */

    $httpProvider.interceptors.push('authResponseInterceptor');

    $translateProvider.translations('en', {
        authentication: {
            common: {
                cancel: 'Cancel',
                login: 'Log In',
                signup: 'Sign Up'
            },
            completed: {
                messageHeader: 'Completed!',
                messageBody: 'We\'ve sent you an email to confirm your email address. Once you\'ve confirmed that, we can get started.'
            },
            register: {
                submit: 'Confirm Information'
            },
            models: {
                guardian: {
                    relationshipToPatient: {
                        mother: 'Mother',
                        father: 'Father',
                        uncle: 'Uncle',
                        aunt: 'Aunt',
                        grandmother: 'Grandmother',
                        grandfather: 'Grandfather',
                        legalGuardian: 'Legal Guardian',
                        other: 'Other'
                    }
                },
                user: {
                    email: 'Email Address',
                    firstName: 'First Name',
                    lastName: 'Last Name',
                    username: 'Username',
                    birthday: 'Birthday',
                    password: 'Password',
                    gender: 'Gender',
                    fullName: 'Name',
                    emailAbbreviated: 'E-Mail',
                    guardian: 'Guardian',
                    guardianRelationship: 'Relationship to Patient',
                    physician: 'Doctor',
                    afterHoursPhone: 'ACH after hours resource phone #',
                    coordinatorPhone: "Research coordinator's office phone #"
                }
            }
        }
    });

});
