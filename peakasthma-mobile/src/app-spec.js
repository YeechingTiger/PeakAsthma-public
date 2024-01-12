describe('willowPeakAsthmaHyrbid', function() {

  beforeEach(module('willowPeakAsthmaHyrbid'));

  it('should set the default app destination', inject(function($location, $rootScope, $state) {
    $location.url('');
    spyOn($location, 'url');
    $rootScope.$digest();
    
    expect($location.url).toHaveBeenCalledWith('/dashboard');
  }));

  it('should set the app\'s prefered language.', inject(function($translate) {

    expect($translate.use()).toEqual('en');

  }));

});
