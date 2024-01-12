describe('authResponseInterceptor', function() {

  var _authResponseInterceptor, _$window, _backTransitionService, _$state, _$q;

  beforeEach(module('authentication'));
  beforeEach(inject(function(authResponseInterceptor, $window, backTransitionService, $state, $q) {
    _authResponseInterceptor = authResponseInterceptor;
    _$window = $window;
    _backTransitionService = backTransitionService;
    _$state = $state;
    _$q = $q;
  }));

  describe('#request', function() {
    beforeEach(function() {
      spyOn(_$window.localStorage, 'getItem').and.returnValue('value');
    });

    it('should add the Authorization header with the retrieved localStorage values', function() {
      var newConfig = _authResponseInterceptor.request({
        headers: {}
      });

      expect(_$window.localStorage.getItem).toHaveBeenCalledWith('authToken');
      expect(_$window.localStorage.getItem).toHaveBeenCalledWith('userId');

      expect(newConfig.headers.Authorization).toEqual('Token token=value, id=value');
    });
  });

  describe('#responseError', function() {
    beforeEach(function() {
      spyOn(_backTransitionService, 'goBack');
      spyOn(_$state, 'go');
      spyOn(_$q, 'reject');
    });

    it('should return the body of a call with a 200 status request', function() {
      expect(_authResponseInterceptor.responseError({ status: 200 }).status).toEqual(200);
    });

    it('rejects the promise chain as it detects a 401 status code, and transition to the login state', function() {
      var response = {
        status: 401
      };
      var newConfig = _authResponseInterceptor.responseError(response);

      expect(_backTransitionService.goBack).toHaveBeenCalled();
      expect(_$state.go).toHaveBeenCalledWith('login');
      expect(_$q.reject).toHaveBeenCalledWith(response);
    });
  });

});
