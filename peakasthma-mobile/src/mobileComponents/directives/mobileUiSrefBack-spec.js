describe('mobileUiSrefBack', function() {

  beforeEach(module('mobileComponents'));

  var scope,compile,rootScope,_backTransitionService,directiveElement;

  beforeEach(inject(function($rootScope,$compile,backTransitionService) {
    scope = $rootScope.$new();
    compile = $compile;
    _backTransitionService = backTransitionService;
  }));

  beforeEach(function() {
    directiveElement = compile('<a mobile-ui-sref-back>Link</a>')(scope);
    spyOn(_backTransitionService, 'goBack');
  });

  it('should call the transition service\'s go back function on click', function() {

    directiveElement.triggerHandler('click');
    expect(_backTransitionService.goBack).toHaveBeenCalled();

  });

  it('should call the transition service\'s go back function on touchstart', function() {

    directiveElement.triggerHandler('touchstart');
    expect(_backTransitionService.goBack).toHaveBeenCalled();

  });
});