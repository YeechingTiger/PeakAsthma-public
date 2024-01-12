describe('loginService', function() {

  beforeEach(module('authentication'));

  var _loginService, willowApiEndpoints, httpBackend, state, request, scope;

  var mockUserModel = { id: 0, username: 'testuser', password: 'testpassword1', authenticationToken: 'authtoken1' };

  beforeEach(inject(function(loginService, $httpBackend, apiEndpoints, $state, $rootScope) {
    _loginService = loginService;
    httpBackend = $httpBackend;
    willowApiEndpoints = apiEndpoints;
    state = $state;
    scope = $rootScope;
  }));

  describe('#createSession', function() {
    beforeEach(function() {
      spyOn(state, 'go');
      spyOn(willowApiEndpoints, 'setAuthTokens');
      request = httpBackend.when('POST', willowApiEndpoints.user.signIn)
        .respond({ user: mockUserModel });
    });

    it('should call the user signIn route, and after a success, goes to the dashboard, and sets up the user\'s auth tokens', function() {
      httpBackend.expectPOST(willowApiEndpoints.user.signIn);
      _loginService.createSession({});
      httpBackend.flush();

      expect(state.go).toHaveBeenCalledWith('dashboard.root');
      expect(willowApiEndpoints.setAuthTokens).toHaveBeenCalledWith(mockUserModel.authenticationToken, mockUserModel.id);
    });

    it('should call the user signIn route, and after a success, goes to the walkthrough if this is the user\'s first login', function() {
      var mockUserFirstTimeLogin = mockUserModel;
      mockUserFirstTimeLogin.firstTimeLogin = true;
      request.respond(200, { user: mockUserFirstTimeLogin });
      httpBackend.expectPOST(willowApiEndpoints.user.signIn);
      _loginService.createSession({});
      httpBackend.flush();

      expect(state.go).toHaveBeenCalledWith('walkthrough');
      expect(willowApiEndpoints.setAuthTokens).toHaveBeenCalledWith(mockUserModel.authenticationToken, mockUserModel.id);
    });

    it('should transition to the login state on a failed auth, and return the response', function() {
      var responseFromApi;
      request.respond(401, { errors: ['There aren\'t enough varieties of yogurt.'] });
      httpBackend.expectPOST(willowApiEndpoints.user.signIn);

      _loginService.createSession({}).then(function (response) {
        responseFromApi = response;
      });

      httpBackend.flush();
      scope.$apply();
      expect(state.go).toHaveBeenCalledWith('login');
      expect(responseFromApi.errors.length).toEqual(1);
    });
  });

describe('#getCurrentUser', function() {
  beforeEach(function() {
      spyOn(state, 'go');
      request = httpBackend.when('GET', willowApiEndpoints.user.current)
        .respond({ user: mockUserModel });
    });

    it('should set the current user on a success', function() {
      httpBackend.expectGET(willowApiEndpoints.user.current);
      _loginService.getCurrentUser();
      httpBackend.flush();

      expect(_loginService.currentUser).toEqual(mockUserModel);
    });

    it('should not set the current user on a failed call', function() {
      var responseFromApi;
      request.respond(401, { errors: ['There aren\'t enough varieties of yogurt.'] });
      httpBackend.expectGET(willowApiEndpoints.user.current);

      _loginService.currentUser = null;
      _loginService.getCurrentUser({}).then(function (response) {
        responseFromApi = response;
      });

      httpBackend.flush();
      scope.$apply();
      expect(_loginService.currentUser).toEqual(null);
    });
});

});
