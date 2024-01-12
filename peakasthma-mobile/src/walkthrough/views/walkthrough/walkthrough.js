angular.module('walkthrough').controller('WalkthroughCtrl',function($scope){

  $scope.slides = [
    {
      id: 0,
      header: 'walkthrough.slides.first.header',
      imgPath: 'assets/imgs/Tablet.png',
      description: 'walkthrough.slides.first.description'
    },
    {
      id: 1,
      header: 'walkthrough.slides.second.header',
      imgPath: 'assets/imgs/Graph.png',
      description: 'walkthrough.slides.second.description'
    },
    {
      id: 2,
      header: 'walkthrough.slides.third.header',
      imgPath: 'assets/imgs/UserProfile.png',
      description: 'walkthrough.slides.third.description'
    },
    {
      id: 3,
      header: 'walkthrough.slides.fourth.header',
      imgPath: 'assets/imgs/MedicalCard.png',
      description: 'walkthrough.slides.fourth.description'
    }
  ];

});