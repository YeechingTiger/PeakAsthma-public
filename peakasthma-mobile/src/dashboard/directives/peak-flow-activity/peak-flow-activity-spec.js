describe('peakFlowActivity', function() {

  beforeEach(module('dashboard'));

  var scope,compile;

  beforeEach(inject(function($rootScope,$compile) {
    scope = $rootScope.$new();
    compile = $compile;
  }));

  it('compiles', function() {
    scope.peakFlow = {};
    scope.colorMap = {};

    var element = compile(angular.element('<peak-flow-activity peakFlow="peakFlow" colorMap="colorMap"></peak-flow-activity>'))(scope);
    expect(element).toBeDefined();
  });
});