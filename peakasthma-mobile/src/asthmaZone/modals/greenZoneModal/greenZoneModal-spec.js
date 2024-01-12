describe('GreenzonemodalCtrl', function() {

    beforeEach(module('asthmaZone'));

    var scope,ctrl;

    beforeEach(inject(function($rootScope, $controller) {
      scope = $rootScope.$new();
      ctrl = $controller('GreenzonemodalCtrl', {$scope: scope});
    }));

    it('initializes', inject(function() {
        
    }));

});
