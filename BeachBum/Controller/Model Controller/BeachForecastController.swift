//
//  BeachForecastController.swift
//  JSON Weather
//
//  Created by Jordan Dumlao on 8/9/18.
//  Copyright © 2018 Jordan Dumlao. All rights reserved.
//

import Foundation

class BeachForecastController: NSObject {
  
  private var beachForecasts = [BeachForecast]()
  private var filteredBeachForecasts: [BeachForecast]?
  
  //Vars for sorting and filtering
  private var isFiltered = false
  private var temperatureSortDownward = true
  private var weatherSortedDownward = true
}

//Helper Interface Variable and Method

extension BeachForecastController {
  var beachForecastsCount: Int { return filteredBeachForecasts?.count ?? beachForecasts.count }
  
  var _beachForecastsArray: [BeachForecast] {
    get { return beachForecasts }
    set { beachForecasts = newValue }
  }
  
  func beachForecastForIndexAt(_ index: Int) -> BeachForecast { return filteredBeachForecasts?[index] ?? beachForecasts[index] }
  
  func addBeachForecast(_ beachForecast: BeachForecast) { beachForecasts.append(beachForecast) }
  
  func removeBeach(_ beachForecast: BeachForecast) {
    if let index = beachForecasts.index(where: { $0.beach.name == beachForecast.beach.name }) {
      beachForecasts.remove(at: index)
    }
  }
  
  func removeBeach(at index: Int) {
    if filteredBeachForecasts != nil {
      if let removedBeach = filteredBeachForecasts?.remove(at: index) {
       removeBeach(removedBeach)
      }
    } else {
     beachForecasts.remove(at: index)
    }
  }
}

//Mark: Sorting and filtering functions
extension BeachForecastController {
  func sortBeachForecasts(_ sortType: Sort) {
    beachForecasts.sort { (b1, b2) -> Bool in
      switch sortType {
      case .temperature:
        return temperatureSortDownward ? b1.forecast!.currently.temperature < b2.forecast!.currently.temperature : b1.forecast!.currently.temperature > b2.forecast!.currently.temperature
      case .weatherCondition:
        return weatherSortedDownward ? (b1.forecast!.currently.icon < b2.forecast!.currently.icon) : (b1.forecast!.currently.icon > b2.forecast!.currently.icon)
      case .distance:
        return false
      }
    }
    
    switch sortType {
    case .temperature: temperatureSortDownward = !temperatureSortDownward
    case .weatherCondition: weatherSortedDownward = !weatherSortedDownward
    default: break
    }
  }
  
  func filterBeachesBy(_ searchString: String?) {
    guard let searchString = searchString else { return }
    switch searchString.lowercased() {
    case "all": filteredBeachForecasts = nil; return
    case "north": filteredBeachForecasts = beachForecasts.filter { $0.beach.side == "North" }
    case "east": filteredBeachForecasts = beachForecasts.filter { $0.beach.side == "East" }
    case "south": filteredBeachForecasts = beachForecasts.filter { $0.beach.side == "South" }
    case "west": filteredBeachForecasts = beachForecasts.filter { $0.beach.side == "West" }
    default: filteredBeachForecasts = beachForecasts.filter { $0.beach.name.lowercased().contains(searchString.lowercased()) }
    }
  }
}
