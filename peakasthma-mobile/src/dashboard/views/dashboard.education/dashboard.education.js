angular.module('dashboard').controller('DashboardEducationCtrl', function ($scope, $rootScope,$http, apiEndpoints, $window, $sce, loginService) {
  $scope.tip_content = "";
  $scope.width = $window.outerWidth;
  $scope.height = $scope.width;
  $scope.selectedVideo = null;
  video_list = [];
  $scope.video_display = function () {
    var result_array = []
    for (var index in video_list) {
      row = video_list[index]
      var week = row.week;
      var day = row.day;
      var period = day - 1 + ((week - 1) * 7);
      date = calculate_day();
      if (period <= date) {
        result_array.push(row);
      }
    }
    return result_array;
  }

  $scope.process_url = function (url) {
    if (url) {
      return url;
    }
  }

  $scope.return_url = function (src) {
    return $sce.trustAsResourceUrl(src);
  }

  $scope.getTip = function () {
    $rootScope.spinner.style.display = '';
    $http({
      method: 'GET',
      url: apiEndpoints.tips.get
    }).then(function successfulGetTip(response) {
      $scope.tip_content = response.data[0].tip;
      $rootScope.spinner.style.display = 'none';
      return response.data;
    }, function failedGetTip(response) {
      $rootScope.spinner.style.display = 'none';
      return response.data;
    }).finally(function() {
      $rootScope.spinner.style.display = 'none';
    });
  }

  $scope.likeToggle = function(video) {
    if (video.like == "0") {
      video.like = "1";
    } else {
      video.like = "0";
    }
    $http({
      method: 'POST',
      url: apiEndpoints.videos.like,
      data: {
        video_id: video.id
      }
    }).then(function successfulGetVideo(response) {
      return response.data;
    }, function failedGetVideo(response) {
      return response.data;
    });
  }

  $scope.getVideo = function() {
    $http({
      method: 'GET',
      url: apiEndpoints.videos.like
    }).then(function successfulGetVideo(response) {
      console.log(response.data);
      like_id = [];
      response.data[1].forEach(function(video) {
        like_id.push(video.id);
      });
      
      video_list = response.data[0];
      video_list.forEach(function(video) {
        if (like_id.includes(video.id)) {
          video.like = 1;
        } else {
          video.like = 0;
        }
      });
      console.log(video_list);
      return response.data;
    }, function failedGetVideo(response) {
      return response.data;
    });
  }

  $scope.getTip();
  $scope.getVideo();
  function calculate_day(){
    date_string = loginService.currentUser.enrollTime;
    date = new Date(date_string);
    console.log(date);
    var current_date = new Date();
    var period = Math.round((current_date - date)/(1000*60*60*24));
    console.log(period);
    return period;
  }
});