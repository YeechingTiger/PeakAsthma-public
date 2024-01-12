angular.module('asthmaZone').service('asthmaZoneModalManager',function($uibModal) {

  var _this = this;
  this.modelList = [];
  this.MODAL_TYPES = {
    determineAsthmaZone: {
      templateUrl: 'src/asthmaZone/modals/determineAsthmaZone/determineAsthmaZone.html',
      controller: 'DetermineasthmazoneCtrl',
      backdrop: 'static',
      keyboard: false
    },
    greenZoneModal: {
      templateUrl: 'src/asthmaZone/modals/greenZoneModal/greenZoneModal.html',
      controller: 'GreenzonemodalCtrl',
      backdrop: 'static',
      keyboard: false
    },
    howAreYouFeeling: {
      templateUrl: 'src/asthmaZone/modals/howAreYouFeeling/howAreYouFeeling.html',
      controller: 'HowareyoufeelingCtrl',
      backdrop: 'static',
      keyboard: false
    },
    recordPeakFlow: {
      templateUrl: 'src/asthmaZone/modals/recordPeakFlow/recordPeakFlow.html',
      controller: 'RecordpeakflowCtrl',
      backdrop: 'static',
      keyboard: false
    },
    redZoneModal: {
      templateUrl: 'src/asthmaZone/modals/redZoneModal/redZoneModal.html',
      controller: 'RedzonemodalCtrl',
      backdrop: 'static',
      keyboard: false
    },
    redZoneMedicationInstructionsModal: {
      templateUrl: 'src/asthmaZone/modals/redZoneMedicationInstructionsModal/redZoneMedicationInstructionsModal.html',
      controller: 'RedzonemedicationinstructionsmodalCtrl',
      backdrop: 'static',
      keyboard: false
    },
    updateHowIFeel: {
      templateUrl: 'src/asthmaZone/modals/updateHowIFeel/updateHowIFeel.html',
      controller: 'HowareyoufeelingCtrl',
      backdrop: 'static',
      keyboard: false
    },
    yellowZoneModal: {
      templateUrl: 'src/asthmaZone/modals/yellowZoneModal/yellowZoneModal.html',
      controller: 'YellowzonemodalCtrl',
      backdrop: 'static',
      keyboard: false
    },
    yellowZoneMedicationInstructionsModal: {
      templateUrl: 'src/asthmaZone/modals/yellowZoneMedicationInstructionsModal/yellowZoneMedicationInstructionsModal.html',
      controller: 'YellowzonemedicationinstructionsmodalCtrl',
      backdrop: 'static',
      keyboard: false
    },
    controlMedicationReportModal: {
      templateUrl: 'src/asthmaZone/modals/controlMedicationReportModal/controlMedicationReportModal.html',
      controller: 'ControlMedicationReportModalCtrl',
      backdrop: 'static',
      keyboard: false
    }
  };

  this.reportLevel = function(level, prescription) {
    var resolveData = {
      prescription: prescription
    };

    switch (level) {
      case 'red_now':
        _this.redZoneModal(resolveData);
        break;
      case 'red':
        _this.redZoneModal(resolveData);
        break;
      case 'yellow':
        _this.yellowZoneModal(resolveData);
        break;
      case 'green':
        _this.greenZoneModal(resolveData);
        break;
    }
  };

  this.determineAsthmaZone = function(callback) {
    openModal(this.MODAL_TYPES.determineAsthmaZone, callback);
  };

  this.greenZoneModal = function(callback) {
    openModal(this.MODAL_TYPES.greenZoneModal, callback);
  };

  this.howAreYouFeeling = function(callback) {
    openModal(this.MODAL_TYPES.howAreYouFeeling, callback);
  };

  this.updateHowIFeel = function(callback) {
    openModal(this.MODAL_TYPES.updateHowIFeel, callback);
  };

  this.recordPeakFlow = function(callback) {
    openModal(this.MODAL_TYPES.recordPeakFlow, callback);
  };

  this.redZoneModal = function(resolve, callback) {
    openModal(this.MODAL_TYPES.redZoneModal, callback, resolve);
  };

  this.redZoneMedicationInstructionsModal = function(resolve, callback) {
    openModal(this.MODAL_TYPES.redZoneMedicationInstructionsModal, callback, resolve);
  };

  this.yellowZoneModal = function(resolve, callback) {
    var yellowModel = openModal(this.MODAL_TYPES.yellowZoneModal, callback, resolve);
    _this.modelList.push(yellowModel);
    console.log(_this.modelList);
  };

  this.yellowZoneMedicationInstructionsModal = function(resolve, callback) {
    var yellowMedModel = openModal(this.MODAL_TYPES.yellowZoneMedicationInstructionsModal, callback, resolve);
    _this.modelList.push(yellowMedModel);
    console.log(_this.modelList);
  };

  this.controlMedicationReportModal = function(resolve, callback) {
    openModal(this.MODAL_TYPES.controlMedicationReportModal, callback, resolve);
  };

  function openModal(modalTemplateData, callback, resolve) {
    if (resolve) {
      modalTemplateData.resolve = resolve;
    }

    var instance = $uibModal.open(modalTemplateData);
    instance.result.then(function(result){
      if (callback) {
        callback(result);
      }
    });

    return instance;
  }

});
