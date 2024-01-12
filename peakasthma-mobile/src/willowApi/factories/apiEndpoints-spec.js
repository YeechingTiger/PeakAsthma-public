describe('apiEndpoints', function() {

  var _apiEndpoints, _$window;

  beforeEach(module('willowApi'));
  beforeEach(inject(function(apiEndpoints, $window) {
    _apiEndpoints = apiEndpoints;
    _$window = $window;
  }));

  describe('#setAuthTokens', function() {
    beforeEach(function() {
      spyOn(_$window.localStorage, 'setItem');
    });

    it('should set the proper localStorage keys', function() {
      _apiEndpoints.setAuthTokens('auth', 0);

      expect(_$window.localStorage.setItem).toHaveBeenCalledWith('authToken', 'auth');
      expect(_$window.localStorage.setItem).toHaveBeenCalledWith('userId', 0);
    });
  });

});
