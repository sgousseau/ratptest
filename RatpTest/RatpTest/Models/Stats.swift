//
//  Stats.swift
//  RatpTest
//
//  Created by Sébastien Gousseau on 20/12/2020.
//

import Foundation

struct Stats {
  
  static let storageKey = "live_stats"
  
  class Stat: Codable {
    let tag: String
    var hit: Int = 1
    
    init(tag: String) {
      self.tag = tag
    }
  }
  
  var getStats: () -> [Stat]
  var addStat: (String) -> Void
}

extension Stats {
  
  static let live: Stats = {
    
    let getStats: () -> [Stat] = {
      if
        let statsData = UserDefaults.standard.data(forKey: Stats.storageKey),
        let stats = try? JSONDecoder().decode([Stat].self, from: statsData) {
        return stats
      }
      return []
    }
    
    let saveStats: ([Stat]) -> Void = { stats in
      guard let data = try? JSONEncoder().encode(stats) else {
        return
      }
      UserDefaults.standard.set(data, forKey: Stats.storageKey)
      UserDefaults.standard.synchronize()
    }
    
    return Stats {
      return getStats()
    } addStat: { tag in
      var stats = getStats()
      if let stat = stats.first(where: { $0.tag == tag }) {
        stat.hit += 1
      } else {
        stats.append(Stat(tag: tag))
      }
      saveStats(stats)
    }
  }()
  
  ///We can describe any implementation this way, constructing each functions as needed here
  static var mock: Stats = {
    return Stats(
      getStats: {
        return []
      }) { _ in
      
    }
  }()
}
