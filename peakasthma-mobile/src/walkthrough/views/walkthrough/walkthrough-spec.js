describe('WalkthroughCtrl', function() {

    beforeEach(module('walkthrough'));

    var scope,ctrl;

    beforeEach(inject(function($rootScope, $controller) {
      scope = $rootScope.$new();
      ctrl = $controller('WalkthroughCtrl', {$scope: scope});
    }));

    it('should have 4 slides with the correct translations', inject(function() {

        expect(scope.slides.length).toEqual(4);
        expect(scope.slides[0].header).toEqual('walkthrough.slides.first.header');
        expect(scope.slides[1].header).toEqual('walkthrough.slides.second.header');
        expect(scope.slides[2].header).toEqual('walkthrough.slides.third.header');
        expect(scope.slides[3].header).toEqual('walkthrough.slides.fourth.header');

        expect(scope.slides[0].description).toEqual('walkthrough.slides.first.description');
        expect(scope.slides[1].description).toEqual('walkthrough.slides.second.description');
        expect(scope.slides[2].description).toEqual('walkthrough.slides.third.description');
        expect(scope.slides[3].description).toEqual('walkthrough.slides.fourth.description');

    }));

});
