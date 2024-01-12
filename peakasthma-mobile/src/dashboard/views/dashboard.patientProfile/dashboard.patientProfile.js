angular
  .module("dashboard")
  .controller(
    "DashboardPatientprofileCtrl",
    function (
      $scope,
      loginService,
      prescriptionService,
      notificationService,
      userService
    ) {
      $scope.currentUser = loginService.currentUser;
      $scope.medicationReminders = loginService.currentUser.medicationReminders;
      $scope.medicationReminderTime = new Date(
        loginService.currentUser.medicationReminderTime
      );
      $scope.reportReminderTime = new Date(
        loginService.currentUser.reportReminderTime
      );
      $scope.times = [
        { id: 0, display: "30 Minutes", value: 30 },
        { id: 1, display: "1 Hour", value: 60 },
        { id: 2, display: "2 Hours", value: 120 },
        { id: 3, display: "6 Hours", value: 360 },
      ];
      $scope.selectedTime = $scope.times[$scope.currentUser.remindLaterTime];

      $scope.reportControllerMed = function () {
        var notification = { controller_med_report: "true" };
        notificationService.openTakeMedicineModal(notification);
      };

      $scope.requestClincardBalance = function () {
        userService.requestClincardBalance().then((res) => {
          console.log(res);
          userService.openClincardBalanceModal(res.requestStatus);
        });
      };

      $scope.updatePrescriptionReminderPreference = function () {
        prescriptionService.updatePrescriptionReminderPreference(
          $scope.medicationReminders,
          $scope.medicationReminderTime
        );
      };

      $scope.updateReportReminderPreference = function () {
        prescriptionService.updateReportReminderPreference(
          $scope.medicationReminders,
          $scope.reportReminderTime
        );
      };

      $scope.updatePrescriptionRemindMeLater = function () {
        prescriptionService.updateRemindMeLaterTime($scope.selectedTime.id);
      };

      $scope.viewPrivacyPolicy = function () {
        var accepted = loginService.currentUser.acceptPolicy;
        userService.openPolicyModal(accepted);
      };
    }
  );
