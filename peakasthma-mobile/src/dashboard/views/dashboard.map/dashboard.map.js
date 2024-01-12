angular.module('dashboard').controller('DashboardMapCtrl', function ($scope, $window, $sce, mapService, NgMap) {
  $scope.latitude = 34.7464809;
  $scope.longitude = -92.2895948;
  $scope.weather = {};
  $scope.location = "Default";
  $scope.tab_type = {
    map: "map",
    weather: "weather"
  };
  var selected_tab = "map";

  $scope.DSWeather = function () {
    var weather_info = mapService.DSWeather;
    return weather_info.currently;
  };

  $scope.DSWeather_daily = function () {
    var weather_info = mapService.DSWeather;
    return weather_info.daily;
  };

  $scope.DSWeather_alerts = function () {
    var weather_info = mapService.DSWeather;
    if (weather_info.alerts) return weather_info.alerts;
    return {};
  };

  $scope.forecast = function () {
    return mapService.DSWeather;
  };

  $scope.dateToWeekday = function (date) {
    return moment(date).format('ddd');
  };

  var markers = [];
  var results_group = [];
  var marker;
  var center;
  var service;
  var infowindow;
  NgMap.getMap("map").then(function () {
    if (mapService.latitude && mapService.longitude) {
      renderMap(mapService.latitude, mapService.longitude);
    } else {
      navigator.geolocation.getCurrentPosition(function (position) {
        console.log("get position...");
        console.log(position);
        renderMap(position.coords.latitude, position.coords.longitude);
      });
    }
  });

  function renderMap(latitude, longitude) {
    $scope.latitude = latitude;
    $scope.longitude = longitude;
    mapService.getWeather($scope.latitude, $scope.longitude, callback_weather);
    mapService.getWeatherDS($scope.latitude, $scope.longitude);
    var geocoder = new google.maps.Geocoder;
    var res = geocoder.geocode({ 'location': { lat: $scope.latitude, lng: $scope.longitude } }, function (results, status) {
      if (status === 'OK') {
        if (results[0]) {
          console.log(results[0]);
          $scope.location = results[0].formatted_address;
        }
      }
    });


    console.log(res);
    center = new google.maps.LatLng($scope.latitude, $scope.longitude);
    marker = new google.maps.Marker({
      icon: "assets/imgs/origin1.png"
    });
    marker.setPosition(center);
    marker.setMap($scope.map);
    $scope.map.setCenter(center);
    service = new google.maps.places.PlacesService($scope.map);
    service.nearbySearch({
      location: center,
      radius: 12000,
      types: ["hospital"]
    }, callback_hos);
  }

  function callback_weather(e) {
    $scope.weather = e;
    $scope.weather.main.temp = Math.ceil($scope.weather.main.temp);
  }

  function callback_hos(results, status) {
    if (status === google.maps.places.PlacesServiceStatus.OK) {
      results_group = results_group.concat(results);
      console.log(results_group);
      service.nearbySearch({
        location: center,
        radius: 12000,
        types: ["pharmacy"]
      }, callback);
    } else {
      console.log("Error connecting to the google places api");
    }
  }

  function callback(results, status) {
    console.log(status);
    console.log(results_group);
    if (status === google.maps.places.PlacesServiceStatus.OK) {
      infowindow = new google.maps.InfoWindow();
      results_group = results_group.concat(results);
      for (var i = 0; i < results_group.length; i++) {
        // console.log(results_group[i]);
        if (results_group[i].types.includes("pharmacy")) {
          markers[i] = new google.maps.Marker({
            icon: "assets/imgs/pharmacy1.png"
          });
        } else {
          markers[i] = new google.maps.Marker({
            icon: "assets/imgs/hospital1.png"
          });
        }

        markers[i].setPosition(results_group[i].geometry.location);
        markers[i].setMap($scope.map);

        var contentString =
          "<br><b>" + results_group[i].name + "</b></br>" +
          "<a onclick=\"window.open('https://www.google.com/maps/search/?api=1&query=" + results_group[i].name +
          "&query_place_id=" + results_group[i].id + "', '_system');\">View on Google Maps</a>";

        markers[i].addListener('click', (function (i, infowindow, contentString) {
          infowindow.setContent(contentString);
          infowindow.open($scope.map, markers[i]);
        }).bind(null, i, infowindow, contentString));
      }

      // if (pagination.hasNextPage==true) {
      //   console.log(pagination);
      //   pagination.nextPage();
      // }
    } else {
      console.log("Error connecting to the google places api");
    }
  }

  $scope.timeToDate = function (time) {
    var d = new Date(time * 1000);
    var weekday = new Array(7);
    weekday[0] = "Sunday";
    weekday[1] = "Monday";
    weekday[2] = "Tuesday";
    weekday[3] = "Wednesday";
    weekday[4] = "Thursday";
    weekday[5] = "Friday";
    weekday[6] = "Saturday";

    var n = weekday[d.getDay()];
    return n;
  };

  $scope.tabSelect = function(tab) {
    console.log(tab);
    selected_tab = tab;
  };

  $scope.selected_tab_f = function() {
    return selected_tab;
  };
});
