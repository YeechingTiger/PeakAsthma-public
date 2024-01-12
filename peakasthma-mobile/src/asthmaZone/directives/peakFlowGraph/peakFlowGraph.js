angular.module('asthmaZone').directive('peakFlowGraph', function() {
    return {
        restrict: 'E',
        replace: true,
        scope: {
          peakFlows: '='
        },
        templateUrl: 'src/asthmaZone/directives/peakFlowGraph/peakFlowGraph.html',
        link: function(scope, element, attrs, fn) {
          var hpadding = parseInt(attrs.hpadding, 10) || 15;
          var vpadding = parseInt(attrs.vpadding, 10) || 30;

          var highScore;
          var lowScore;
          var range;

          function calculateScales() {
            highScore = scope.peakFlows.reduce(function (prev, current) {
            return prev.score > current.score ? prev : current;
            }).score;
            lowScore = 0;
            range = highScore - lowScore;
          }

          calculateScales();

          scope.getNodeXPosition = function(index) {
            var width = element.width();
            calculateScales();

            return index * ((width - hpadding * 2) / (scope.peakFlows.length - 1)) + hpadding;
          };

          scope.getNodeYPosition = function(index) {
            var height = element.height();
            calculateScales();
            var score = scope.peakFlows[index].score;
            return (highScore - score) * ((height - vpadding * 2) / range) + vpadding;
          };

          scope.getLinePath = function(i) {
            if (i < scope.peakFlows.length - 1) {
              var xi = scope.getNodeXPosition(i);
              var yi = scope.getNodeYPosition(i);
              var pathString = 'M ' + xi + ' ' + yi;
              return pathString + scope.getLinearGraphPath(i);
            }
            return "";
          };

          scope.getAreaPath = function() {
            var height = element.height();
            var startX = scope.getNodeXPosition(0);
            var startY = scope.getNodeYPosition(0);
            var endX = scope.getNodeXPosition(scope.peakFlows.length - 1);

            return 'M ' + startX + ' ' + height + ' L ' + startX + ' ' + startY + scope.getLinearGraphPath() + ' L ' + endX + ' ' + height;
          };

          scope.getLinearGraphPath = function(i) {
            // console.log(i);
            var pathString = '';
            pathString += ' L ';
            var x = scope.getNodeXPosition(i + 1);
            var y = scope.getNodeYPosition(i + 1);
            pathString += x + ' ' + y;
            return pathString;
          };
        }
    };
});
