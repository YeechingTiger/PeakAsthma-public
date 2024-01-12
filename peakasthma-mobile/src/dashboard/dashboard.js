angular.module('dashboard', ['ui.bootstrap','ui.router','ngAnimate','willowApi','mobileComponents','pascalprecht.translate','authentication','asthmaZone', 'ngMap']);
angular.module('dashboard').config(function($stateProvider, $translateProvider) {

    $stateProvider.state('dashboard', {
        abstract: true,
        url: '/dashboard',
        templateUrl: 'src/dashboard/views/dashboard/dashboard.html',
        resolve: {
            currentUser: function(loginService) {
                return loginService.getCurrentUser();
            },
            peakFlows: function(peakFlowService) {
                return peakFlowService.listPeakFlows();
            }
        }
    });
    $stateProvider.state('dashboard.patientProfile', {
        url: '/profile',
        templateUrl: 'src/dashboard/views/dashboard.patientProfile/dashboard.patientProfile.html'
    });
    $stateProvider.state('dashboard.root', {
        url: '',
        templateUrl: 'src/dashboard/views/dashboard.root/dashboard.root.html',
    });
    $stateProvider.state('dashboard.education', {
        url: '/education',
        templateUrl: 'src/dashboard/views/dashboard.education/dashboard.education.html'
    });
    $stateProvider.state('dashboard.map', {
        url: '/map',
        templateUrl: 'src/dashboard/views/dashboard.map/dashboard.map.html',
    });
    $stateProvider.state('dashboard.notifications', {
        url: '/notifications',
        templateUrl: 'src/dashboard/views/dashboard.notifications/dashboard.notifications.html'
    });
    $stateProvider.state('dashboard.medications', {
        url: '/medications',
        templateUrl: 'src/dashboard/views/dashboard.medications/dashboard.medications.html',
        resolve: {
            prescriptions: function(prescriptionService) {
                return prescriptionService.getPrescriptions();
            }
        }
    });
    /* Add New States Above */

    $translateProvider.translations('en', {
        dashboard: {
            common: {
                showMore: 'Show More',
                peakFlow: 'Asthma Zone'
            },
            modals: {
                common: {
                    dismiss: 'Dismiss'
                },
                notificationAlertModal: {
                    header: 'Alert'
                },
                policyViewerModal: {
                    header: 'Privacy Policy',
                    header_term: 'Terms of Service'
                },
                clincardBalance: {
                    header: 'Clincard Balance Request'
                }
            },
            activityHistory: {
                header: 'Activity History',
                peakFlow: {
                    score: 'You chose feeling {{feeling}}. You recorded a peak flow of {{score}}.',
                    symptoms: 'You chose feeling {{feeling}}. You recorded feeling:',
                    greenZone: 'You reported feeling great. Keep up the good work!'
                },
                takenPrescriptionRecord: {
                    nameAndDosage: '{{medication}} - {{dosage}}'
                }
            },
            education: {
                header: 'Education'
            }
            ,
            medications: {
                header: 'My Action Plan'
            },
            notifications: {
                header: 'Notifications'
            },
            patientProfile: {
                header: 'Patient Information',
                medications: 'Medications',
                control: "Report Controller Medication",
                policy: 'View Privacy Policy and Terms of Service',
                clincard_balance: 'Request Clincard Balance'
            },
            root: {
                header: 'Welcome to Peak Asthma!'
            },
            models: {
                medication: {
                    labels: {
                        med_reminder: 'Send me a reminder to take my medicine.',
                        rep_reminder: 'Send me a reminder to report peak flow or symptoms.',
                        takeMedicationTime: 'I want to get my reminder around:',
                        savePreferences: 'Save Preferences',
                        reminder_in_time_period: 'Remind me later'
                    }
                },
                prescription: {
                    formulation: {
                        suspension_syrup: 'Suspension/Syrup',
                        tablet_pill: 'Tablet/Pill',
                        inhaled_puffs: 'Inhaled Puffs',
                        inhaled_vials: 'Inhaled Solution- # of vials',
                        injection: 'Injection'
                    },
                    frequency: {
                        as_needed: 'As needed',
                        every_4_6_hrs: 'Every 4-6 hrs',
                        four_times_daily: 'Four times daily or every 6 hrs',
                        three_times_daily: 'Three times daily or every 8 hrs',
                        twice_daily: 'Twice daily or every 12 hrs',
                        daily: 'Daily',
                        every_other_day: 'Every other day',
                        weekly: 'Weekly',
                        twice_monthly: 'Twice monthly',
                        monthly: 'Monthly'
                    },
                    level_zone: {
                        yellow: 'Yellow zone',
                        green: 'Green zone',
                        red: 'Red zone',
                    }
                }
            }
        }
    });

});
