describe('DashboardPatientprofileCtrl', function() {

    beforeEach(module('dashboard'));

    var scope,ctrl,_loginService,_prescriptionService;

    beforeEach(inject(function($rootScope, loginService, $controller, prescriptionService) {
      scope = $rootScope.$new();
      _loginService = loginService;
      _prescriptionService = prescriptionService;

      loginService.currentUser = {
        id: 1,
        name: 'mockUserModel',
        medicationReminders: true,
        medicationReminderTime: 'Jan 23, 2017 10:55 AM CST'
      };

      ctrl = $controller('DashboardPatientprofileCtrl', {$scope: scope});

      spyOn(prescriptionService, 'updatePrescriptionReminderPreference');
    }));

    it('binds the current user from the loginService into scope', function() {

      expect(scope.currentUser).toEqual(_loginService.currentUser);
      expect(scope.medicationReminders).toEqual(_loginService.currentUser.medicationReminders);
      expect(scope.medicationReminderTime).toEqual(new Date(_loginService.currentUser.medicationReminderTime));
        
    });

    describe('#updatePrescriptionReminderPreference', function() {
      it('calls the prescriptionService', function() {
        scope.updatePrescriptionReminderPreference();

        expect(_prescriptionService.updatePrescriptionReminderPreference)
          .toHaveBeenCalledWith(
            _loginService.currentUser.medicationReminders,
            new Date(_loginService.currentUser.medicationReminderTime));
      });
    });

});
