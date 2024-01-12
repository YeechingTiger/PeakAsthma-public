describe('willowApi', function() {

  beforeEach(module('willowApi'));

  it('should set the default http header for OliveBranch', inject(function($http) {
    expect($http.defaults.headers.common['X-Key-Inflection']).toEqual('camel');
  }));

});
