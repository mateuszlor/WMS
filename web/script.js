// create the module and name it app
var app = angular.module('app', []);

// create the controller and inject Angular's variables
app.controller('controller', function($scope, $location, $sce, $http) {
	$scope.trustSrc = function(src) {
    	return $sce.trustAsResourceUrl(src);
    }

    $scope.setChannel = function(channel) {
    	$scope.params.channel = channel

    	rewriteUrl()
    }

    $scope.setChart = function(chart) {
    	$scope.params.chart = chart

    	if(chart == "1") {
    		$scope.chartType = "Temperature"
    	}
    	else {
    		$scope.chartType = "Humidity"
    	}

    	rewriteUrl()
    }

    getChannels() {
    	return $http.get("https://api.thingspeak.com/users/mateuszlor")
    }

    rewriteUrl = function() {
    	var url = "?"

		angular.forEach($scope.params, function(value, key) {
			url += key + '=' + value + '&'
			});

		$location.url(url)
    	$location.replace();
		reloadIframe()
    }

    reloadIframe = function() {
    		$scope.iframe = "http://api.thingspeak.com/channels/" + 
					$scope.params.channel +
					"/charts/" +
					$scope.params.chart +
					"?width=auto&height=400&results=200&dynamic=true&title=" +
					$scope.chartType
    }

	$scope.params = $location.search()

	$scope.setChart($scope.params.chart)

	$scope.channels = getChannels()
    });