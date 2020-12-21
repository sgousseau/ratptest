//
//  Stats.swift
//  RatpTest
//
//  Created by Sébastien Gousseau on 20/12/2020.
//

import Foundation

///The stat service base interface
struct Stats {
  
  static let liveStorageKey = "live_stats"
  
  ///A stat object
  class Stat: Codable {
    let tag: String
    var hits: Int = 1
    
    init(tag: String) {
      self.tag = tag
    }
  }
  
  ///Get all stats
  var getStats: () -> [Stat]
  
  ///Adds a stat
  var addStat: (String) -> Void
}

extension Stats {
  
  ///A production implementatiojn of the Stat service using an inline implementation of UserDefaults storage with a dynamic key.
  ///TODO: refactor UserDefaults implementation with a Storage interface following the same principles
  static func live(storageKey: String) -> Stats {
    
    let getStats: () -> [Stat] = {
      if
        let statsData = UserDefaults.standard.data(forKey: storageKey),
        let stats = try? JSONDecoder().decode([Stat].self, from: statsData) {
        return stats
      }
      return []
    }
    
    let saveStats: ([Stat]) -> Void = { stats in
      guard let data = try? JSONEncoder().encode(stats) else {
        return
      }
      UserDefaults.standard.set(data, forKey: storageKey)
      UserDefaults.standard.synchronize()
    }
    
    return Stats {
      return getStats()
    } addStat: { tag in
      var stats = getStats()
      if let stat = stats.first(where: { $0.tag == tag }) {
        stat.hits += 1
      } else {
        stats.append(Stat(tag: tag))
      }
      saveStats(stats)
    }
  }
  
  ///We can describe any implementation this way, constructing each functions as needed like for tests or anything
  static var mock: Stats = {
    return Stats(
      getStats: {
        return []
      }) { _ in
      
    }
  }()
}
