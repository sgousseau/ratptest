//
//  Stats.swift
//  RatpTest
//
//  Created by Sébastien Gousseau on 20/12/2020.
//

import Foundation

struct Stats {
  
  static let storageKey = "live_stats"
  
  class Stat {
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
    
    return Stats { () -> [Stat] in
      let stats = UserDefaults.standard.array(forKey: Stats.storageKey) as? [Stat]
      return stats ?? []
    } addStat: { tag in
      var stats = UserDefaults.standard.array(forKey: Stats.storageKey) as? [Stat]
      
      if let stat = stats?.first(where: { $0.tag == tag }) {
        stat.hit += 1
      } else {
        stats?.append(Stat(tag: tag))
      }
      
      UserDefaults.standard.setValue(stats, forKey: Stats.storageKey)
      UserDefaults.standard.synchronize()
    }
    
  }()
}
