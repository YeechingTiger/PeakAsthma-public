angular.module('asthmaZone', ['ui.bootstrap','ui.router','ngAnimate','pascalprecht.translate','willowApi']);
angular.module('asthmaZone').config(function($stateProvider, $translateProvider) {

  $stateProvider.state('symptoms', {
        url: '/symptoms',
        templateUrl: 'src/asthmaZone/views/symptoms/symptoms.html',
        resolve: {
            symptoms: function(symptomService) {
                return symptomService.getSymptoms();
            }
        }
    });

  /* Add New States Above */

  $translateProvider.translations('en', {
    asthmaZone: {
      modals: {
        common: {
          ok: 'OK',
          cancel: 'Cancel',
          dismiss: 'Remind Me Later',
          next: 'Next',
          complete: 'Complete',
          callEMS: 'Call 911/EMS'
        },
        greenZoneModal: {
          header: 'Alert: Green Zone',
          message: 'Great! You are in the Green zone. Keep up the good work!'
        },
        recordPeakFlow: {
          header: 'Record your Peak Flow',
          instructions: 'Swipe left/right to the input value.'
        },
        redZoneModal: {
          header: 'Alert: Red Zone',
          message: 'Oh no! Looks like you are in the red zone. Click next for instructions on quick relief medication.'
        },
        redZoneMedicationInstructionsModal: {
          header: 'Alert: Red Zone',
          instructions: 'Take {{dosage}} of {{medication}}, then check again in 20 minutes.',
          defaultInstructions: 'Take your red zone medications, then check again in 20 minutes.',
          message: 'If symptoms don\'t improve, seek emergency care. Call your doctor.'
        },
        yellowZoneModal: {
          header: 'Alert: Yellow Zone',
          message: 'Oh no! Looks like you are in the yellow zone. Click next for instructions on quick relief medication.'
        },
        yellowZoneMedicationInstructionsModal: {
          header: 'Alert: Yellow Zone',
          instructions: 'Take {{dosage}} of {{medication}}, then check again in 20 minutes.',
          defaultInstructions: 'Take your yellow zone medications, then check again in 20 minutes.',
          re_instructions: 'Take {{dosage}} of {{medication}}.',
        },
        controlMedicationReportModal: {
          header: 'Controller Medication Reminder',
          instructions: 'Remember to take your controller medications.',
          defaultInstructions: 'Remember to take your controller medications.',
          rp_header: 'Report Controller Medication',
          rp_instructions: 'Do you want to report that you have taken controller medication?'
        },
        determineAsthmaZone: {
          header: 'Determine Your Asthma Zone',
          inputPeakFlow: 'Record Peak Flow',
          recordSymptoms: 'Record Symptoms'
        },
        howAreYouFeeling: {
          header: 'How are you feeling today?',
          buttons: {
            green: "I'm feeling great",
            yellow: "I feel ok...",
            red: "I feel horrible"
          }
        },
        updateHowIFeel: {
          header: 'How do you feel now?'
        }
      },
      symptoms: {
        headers: {
          green: 'Green Zone Symptoms',
          yellow: 'Yellow Zone Symptoms',
          red: 'Red Zone Symptoms'
        },
        next: 'Next'
      }
    }
  });

});
