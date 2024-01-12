describe('backTransitionService', function() {

  beforeEach(module('mobileComponents'));

  it('should start with the back transition flag to false', inject(function(backTransitionService) {
    expect(backTransitionService.backTransition).toEqual(false);
  }));

  it('should set the backTransitionService flag to true when going back', inject(function(backTransitionService) {
    backTransitionService.goBack();
    expect(backTransitionService.backTransition).toEqual(true);
  }));

  it('should set it to false with clearBackTransition', inject(function(backTransitionService) {
    backTransitionService.goBack();
    backTransitionService.clearBackTransition();
    expect(backTransitionService.backTransition).toEqual(false);
  }));

});
