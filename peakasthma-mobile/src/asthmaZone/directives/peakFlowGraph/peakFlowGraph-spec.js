describe('peakFlowGraph', function() {

  // Have to pull in the whole module to test the template.
  // Def not ideal - but the fix will require some build process changes.

  // Consider this a TODO. :)
  beforeEach(module('willowPeakAsthmaHyrbid'));

  var scope,compile,element;

  beforeEach(inject(function($rootScope,$compile) {
    scope = $rootScope.$new();
    compile = $compile;

    scope.peakFlows = [
      {
        score: 0
      },
      {
        score: 100
      },
      {
        score: 200
      },
      {
        score: 300
      }
    ];

    element = compile(angular.element('<peak-flow-graph peak-flows="peakFlows"></peak-flow-graph>'))(scope);
    scope.$digest();

    element.css('width', 200);
    element.css('height', 200);
    scope.$digest();
  }));

  it('places a label with the last peakFlow score at the end of the chart', function() {
    var label = element.find('text');
    expect(label.text()).toEqual(scope.peakFlows[3].score.toString());
  });

  it('places the datapoints in visible places on the graph', function() {
    element.find('circle').each(function(index, point) {
      point = angular.element(point);
      expect(point.attr('cx')).toBeGreaterThan(0);
      expect(point.attr('cx')).toBeLessThan(element.width());
      expect(point.attr('cy')).toBeGreaterThan(0);
      expect(point.attr('cy')).toBeLessThan(element.height());
    });
  });

  it('evenly spaces out the data points based on their position in the array', function() {
    var prevCx;
    var prevDistance;

    element.find('circle').each(function(index, point) {
      point = angular.element(point);
      if (prevCx !== undefined && prevDistance !== undefined) {
        expect(Math.floor(point.attr('cx') - prevCx)).toEqual(prevDistance);
      }
      else if (prevCx !== undefined) {
        prevDistance = Math.floor(point.attr('cx') - prevCx);
      }

      prevCx = point.attr('cx');
    });
  });
});