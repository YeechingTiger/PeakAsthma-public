angular.module('dashboard').service('mapService', function ($http,$rootScope, apiEndpoints, $sce, $rootScope) {

  var _this = this;
  this.latitude;
  this.longitude;
  var weather_api_key = "5111796413fea31d001a59918608b532";
  this.weather = {};
  this.DSWeather = {};

  this.getLocation = function () {
    $rootScope.spinner.style.display = '';
    navigator.geolocation.getCurrentPosition(function (position) {
      console.log(position);
      _this.latitude = position.coords.latitude;
      _this.longitude = position.coords.longitude;
      console.log(_this.latitude);
      $rootScope.spinner.style.display = 'none';
    });
  }

  this.getWeather = function (latitude, longitude, callback) {
    $rootScope.spinner.style.display = '';
    const Http = new XMLHttpRequest();
    const url = "http://api.openweathermap.org/data/2.5/weather?units=Imperial&lon=" + longitude + "&lat=" + latitude + "&appid=" + weather_api_key;
    Http.open("GET", url);
    Http.send();

    Http.onreadystatechange = function (e) {
      if (Http.responseText) {
        console.log(JSON.parse(Http.responseText));
        this.weather = JSON.parse(Http.responseText);
        callback(this.weather);
      }
    }
    $rootScope.spinner.style.display = 'none';
  }

  this.getWeatherDS = function(latitude, longitude) {
    $rootScope.spinner.style.display = '';
    return $http({
          method: 'POST',
          url: apiEndpoints.weather,
          headers: {
            'Content-Type': 'application/json', /*or whatever type is relevant */
            'Accept': 'application/json'
          },
          data: {
            lon: longitude,
            lat: latitude
          }
        }).then(function successfulGetDSweather(response) {
          var data = response.data;
          console.log(data.data);
          _this.DSWeather = data.data;
          return response.data;
        }, function failedGetDSweather(response) {
          return response.data;
        }).finally(function() {
          $rootScope.spinner.style.display = 'none';
        });
  }

});
