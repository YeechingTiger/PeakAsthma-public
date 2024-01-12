describe('prescriptionActivity', function() {

  beforeEach(module('dashboard'));

  var scope,compile;

  beforeEach(inject(function($rootScope,$compile) {
    scope = $rootScope.$new();
    compile = $compile;
  }));

  it('compiles', function() {
    scope.activity = {};

    var element = compile(angular.element('<prescription-activity activity="activity"></prescription-activity>'))(scope);
    expect(element).toBeDefined();
  });
});
