import UIKit

var greeting = "Hello, playground"

//function dengan parameter data enum dengan switch trailing

enum Season {
    case Spring, Summer, Autumn, Winter
}

var currentSeason = Season.self

func addSeason (currentSeason: Season) -> String{
    switch currentSeason{
    case .Spring:
        return "Berangin"
    default:
        return "Hujan"
    }
}

print(addSeason(currentSeason: currentSeason.Autumn))
