describe('mobileUiViewBackTransition', function() {

  beforeEach(module('mobileComponents'));

  var scope,compile,rootScope,animate,_backTransitionService,directiveElement;

  beforeEach(inject(function($rootScope,$compile,$animate,backTransitionService) {
    scope = $rootScope.$new();
    compile = $compile;
    animate = $animate;
    _backTransitionService = backTransitionService;
  }));

  describe('toggling the \'back-transition\' class', function() {

    beforeEach(function() {
      directiveElement = compile('<a mobile-ui-view-back-transition>Link</a>')(scope);
    });

    it('should add the class when the backTransitionService reports a back transition is happening', function() {
      _backTransitionService.backTransition = true;
      scope.$apply();
      expect(directiveElement.hasClass('back-transition')).toEqual(true);
    });

    it('should remove the class when the backTransitionService reports a back transition is not happening', function() {
      _backTransitionService.backTransition = false;
      scope.$apply();
      expect(directiveElement.hasClass('back-transition')).toEqual(false);
    });

  });

  describe('$animate.on leave', function() {

    var checkTransition;

    beforeEach(function() {
      spyOn(animate, 'on').and.callFake(function (code, element, callback) {
        checkTransition = callback;
      });
      spyOn(_backTransitionService, 'clearBackTransition');
      directiveElement = compile('<a mobile-ui-view-back-transition>Link</a>')(scope);
    });

    it('should have configured the event properly', function() {
      expect(animate.on).toHaveBeenCalledWith('leave', jasmine.any(Object), checkTransition);
    });

    describe('#checkTransition', function() {

      it('should not call backTransitionService when the event is at the beginning of the animation', function() {
        checkTransition(null, 'start');
        expect(_backTransitionService.clearBackTransition).not.toHaveBeenCalled();
      });

      it('should not call backTransitionService when an element other than the directive\'s fires the event', function() {
        var element = angular.element(compile('<p></p>')(scope));
        checkTransition(element, 'end');
        expect(_backTransitionService.clearBackTransition).not.toHaveBeenCalled();
      });

      it('should call the service when it\'s the end of the transition, and it\'s the parent element', function() {
        checkTransition(directiveElement, 'end');
        expect(_backTransitionService.clearBackTransition).toHaveBeenCalled();
      });

    });

  });
});