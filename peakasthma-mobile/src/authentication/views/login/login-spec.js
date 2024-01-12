describe('LoginCtrl', function() {

    beforeEach(module('authentication'));

    var scope,ctrl,q;
    var _loginService;
    var failedCall;
    var serviceErrors = {
      errors: ['Password required']
    };

    beforeEach(inject(function($rootScope, $controller, $q, loginService) {
      scope = $rootScope.$new();
      ctrl = $controller('LoginCtrl', {$scope: scope});
      q = $q;
      failedCall = false;
      scope.user = {
        username: 'mockUser',
        password: 'password'
      };

      _loginService = loginService;
    }));

    describe('scope.logIn', function() {
      beforeEach(function() {
        spyOn(_loginService, 'createSession').and.callFake(function() {
          var deferred = q.defer();
          deferred.resolve(failedCall ? serviceErrors : {});
          return deferred.promise;
        });
      });

      it('should call the loginService with $scope.user', inject(function() {
        scope.logIn();
        scope.$apply();

        expect(_loginService.createSession).toHaveBeenCalledWith(scope.user);
      }));

      it('should set $scope.errors if any errors are returned', inject(function() {
        failedCall = true;
        scope.logIn();
        scope.$apply();

        expect(scope.errors.length).toEqual(1);
      }));
    });

});
