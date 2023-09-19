//
//  WeatherViewModel.swift
//  iWeather
//
//  Created by Mohamed Salah on 19/09/2023.
//

import Foundation
import CoreLocation
import Combine

private let apiKey = "2333a2fc6d5dbaf527c73c35a225f5bf"

class WeatherViewModel: ObservableObject {
    private var locationViewModel = LocationManager()
    @Published var weather: Weather?
    @Published var locationName: String?
    @Published var isLoading = false
    private var cancellables = Set<AnyCancellable>()
    private var geoCoder = CLGeocoder()
    
    func getRandomLocationWeather() {
        let randomLocation = generateRandomLocation()
        let latitude = randomLocation.coordinate.latitude
        let longitude = randomLocation.coordinate.longitude
        getWeather(latitude: latitude, longitude: longitude)
    }
    
    func getCurrentLocationWeather() {
        if let location = locationViewModel.userLocation {
            getWeather(latitude: location.latitude, longitude: location.longitude)
        }
    }
    
    func getWeatherFor(location: String) {
        geoCoder.geocodeAddressString(location) { location, error in
            guard let coordinates = location?.first?.location else {
                return
            }
            self.getWeather(latitude: coordinates.coordinate.latitude, longitude: coordinates.coordinate.longitude)
        }
    }
    
    private func getWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        getCurrentWeather(latitude: latitude, longitude: longitude)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error)")
                }
            }, receiveValue: { [weak self] weather in
                self?.weather = weather
                self?.getLocationName(latitude: weather.coord.lat, longitude: weather.coord.lon)
            })
            .store(in: &cancellables)
    }
    
    private func getCurrentWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees)-> AnyPublisher<Weather,Error> {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric") else {fatalError("Missing URL")}
        
        let urlRequest = URLRequest(url: url)
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .map(\.data)
            .decode(type: Weather.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    private func getLocationName(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        geoCoder.reverseGeocodeLocation(location) { placemarks, error in
            guard let placemark = placemarks?.first else { return }
            let address = [
                placemark.name,
                placemark.thoroughfare,
                placemark.subThoroughfare,
                placemark.locality,
                placemark.administrativeArea,
                placemark.country
            ]
                .compactMap { $0 }
                .joined(separator: ", ")
            self.locationName = address
        }
    }
    
    private func generateRandomLocation() -> CLLocation {
        let minLatitude: CLLocationDegrees = -90.0
        let maxLatitude: CLLocationDegrees = 90.0
        let minLongitude: CLLocationDegrees = -180.0
        let maxLongitude: CLLocationDegrees = 180.0
        
        let randomLatitude = Double.random(in: minLatitude...maxLatitude)
        let randomLongitude = Double.random(in: minLongitude...maxLongitude)
        
        return CLLocation(latitude: randomLatitude, longitude: randomLongitude)
    }
}

