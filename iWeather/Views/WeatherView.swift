//
//  WeatherView.swift
//  iWeather
//
//  Created by Mohamed Salah on 17/09/2023.
//

import SwiftUI
import MapKit

struct WeatherView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @State private var searchedLocation: String = ""
    var body: some View {
        ScrollView() {
            Text("\(viewModel.locationName ?? "iWeather")")
                .font(.title)
                .foregroundColor(.cyan)
            VStack {
                HStack {
                    Button(action: {
                        viewModel.getRandomLocationWeather()
                    }) {
                        Text("Get Random Weather")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    Button(action: {
                        viewModel.getCurrentLocationWeather()
                    }) {
                        Text("Get My Weather")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                TextField(
                    "You can search for any city here :)",
                    text: $searchedLocation
                )
                .padding()
                .onSubmit {
                    viewModel.getWeatherFor(location: searchedLocation)
                }
                .tint(.blue)
                .textFieldStyle(.roundedBorder)
                
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else if let weather = viewModel.weather {
                    let region = MKCoordinateRegion(
                        center: CLLocationCoordinate2D(
                            latitude: weather.coord.lat,
                            longitude: weather.coord.lon),
                        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
                    Map(coordinateRegion: .constant(region))
                        .frame(height: 300)
                                .cornerRadius(10)
                                .padding()
                    Text("Temperature: \(weather.main.temp)°C")
                    Text("Description: \(weather.weather.first?.description ?? "")")
                }
            }
        }
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}
