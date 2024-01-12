describe('peakFlowSlider', function() {

  // Have to pull in the whole module to test the template.
  // Def not ideal - but the fix will require some build process changes.

  // Consider this a TODO. :)
  beforeEach(module('willowPeakAsthmaHyrbid'));

  var scope,compile,element;

  function triggerTouch(eventName, screenX) {
    var touchEvent = $.Event(eventName, {
      originalEvent: {
        targetTouches: [
          {
            screenX: screenX
          }
        ]
      }
    });

    element.trigger(touchEvent);
  }

  beforeEach(inject(function($rootScope,$compile) {
    scope = $rootScope.$new();
    compile = $compile;

    scope.peakFlow = {
      score: 270
    };
  }));

  describe('default attributes', function() {
    beforeEach(function() {
      element = compile(angular.element('<peak-flow-slider peak-flow="peakFlow"></peak-flow-slider>'))(scope);
      scope.$digest();
    });

    it('binds the template correctly', function() {
      expect(element.hasClass('peak-flow-slider')).toEqual(true);
    });

    it('increases the peak flow score when moving the touch event to the right (with default dampening of 0.5)', function() {
      triggerTouch('touchstart', 0);
      triggerTouch('touchmove', 20);

      expect(scope.peakFlow.score).toEqual(280);

      triggerTouch('touchmove', 40);
      triggerTouch('touchend', 40);

      expect(scope.peakFlow.score).toEqual(290);
    });

    it('reduces the peak flow score when moving the touch event to the left (with default dampening of 0.5)', function() {
      triggerTouch('touchstart', 100);
      triggerTouch('touchmove', 80);

      expect(scope.peakFlow.score).toEqual(260);

      triggerTouch('touchmove', 60);
      triggerTouch('touchend', 60);

      expect(scope.peakFlow.score).toEqual(250);
    });

    it('won\'t allow the value to go over the max (default 700)', function() {
      triggerTouch('touchstart', 0);
      triggerTouch('touchmove', 10000);
      triggerTouch('touchend', 10000);

      expect(scope.peakFlow.score).toEqual(700);
    });

    it('won\'t allow the value to go under the min (default 0)', function() {
      triggerTouch('touchstart', 1000);
      triggerTouch('touchmove', 0);
      triggerTouch('touchend', 0);

      expect(scope.peakFlow.score).toEqual(0);
    });
  });

  describe('changing the maximum and minimum', function() {
    beforeEach(function() {
      element = compile(angular.element('<peak-flow-slider peak-flow="peakFlow" max="400" min="100"></peak-flow-slider>'))(scope);
      scope.$digest();
    });

    it('won\'t allow the value to go over the max', function() {
      triggerTouch('touchstart', 0);
      triggerTouch('touchmove', 1000);
      triggerTouch('touchend', 1000);

      expect(scope.peakFlow.score).toEqual(400);
    });

    it('won\'t allow the value to go under the min', function() {
      triggerTouch('touchstart', 1000);
      triggerTouch('touchmove', 0);
      triggerTouch('touchend', 0);

      expect(scope.peakFlow.score).toEqual(100);
    });
  });

  describe('changing the touch speed dampening', function() {
    beforeEach(function() {
      element = compile(angular.element('<peak-flow-slider peak-flow="peakFlow" dampening="1"></peak-flow-slider>'))(scope);
      scope.$digest();
    });

    it('increases the peak flow score when moving the touch event to the right', function() {
      triggerTouch('touchstart', 0);
      triggerTouch('touchmove', 10);

      expect(scope.peakFlow.score).toEqual(280);

      triggerTouch('touchmove', 20);
      triggerTouch('touchend', 20);

      expect(scope.peakFlow.score).toEqual(290);
    });

    it('reduces the peak flow score when moving the touch event to the left', function() {
      triggerTouch('touchstart', 100);
      triggerTouch('touchmove', 90);

      expect(scope.peakFlow.score).toEqual(260);

      triggerTouch('touchmove', 80);
      triggerTouch('touchend', 80);

      expect(scope.peakFlow.score).toEqual(250);
    });
  });
});