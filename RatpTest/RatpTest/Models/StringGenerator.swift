//
//  StringGenerator.swift
//  RatpTest
//
//  Created by Sébastien Gousseau on 20/12/2020.
//

import Foundation


///The object used to compute strings as described by the given algorithm of known `FizzBuzz`
struct StringGenerator {
  
  ///A tuple wrapper for all parameters used in calculations
  typealias Parameters = (str1: String, str2: String, int1: Int, int2: Int, limit: Int)
  
  ///All handled errors
  enum StringGeneratorError: Error, Equatable {
    case limitTooLow
    case parameterOverflow(value: Int, max: Int)
    case indexOutOfRange(index: Int, limit: Int)
    
    var description: String {
      switch self {
      case .limitTooLow:
        return "The given limit is too low"
      case let .parameterOverflow(value: value, max: max):
        return "The maximum possible value is \(max) but \(value) was given"
      case let .indexOutOfRange(index: index, limit: limit):
        return "The maximum index is \(limit - 1) but \(index) was given"
      }
    }
  }
  
  ///The parameters wrapper object
  let parameters: Parameters
  
  ///At init, we check if integers are in authorized range of  `0..< Int.maxSquared` for simplicity. We additionally check if the limit is greater than our multipled integer parameters. Throws otherwise
  init(parameters: Parameters) throws {
    
    let max = Int.maxSquared
    
    guard parameters.int1 < max else {
      throw StringGeneratorError.parameterOverflow(value: parameters.int1, max: max)
    }
    
    guard parameters.int2 < max else {
      throw StringGeneratorError.parameterOverflow(value: parameters.int2, max: max)
    }
    
    guard (parameters.int1 * parameters.int2) <= parameters.limit else {
      throw StringGeneratorError.limitTooLow
    }
    
    self.parameters = parameters
  }
  
  ///Get is the generation method. Instead of generating the full list of possible strings at init we generates it dynamically with this method. Yolu pass the index `at: Int` and you get the result. Therefore, if you want to fill an array from 0 to limit, you have to DIY.
  func get(at: Int) throws -> String {
    guard at < parameters.limit else {
      throw StringGeneratorError.indexOutOfRange(index: at, limit: parameters.limit)
    }
    
    let n = at + 1
    let result = (n.isMultiple(of: parameters.int1) ? parameters.str1 : "") + (n.isMultiple(of: parameters.int2) ? parameters.str2 : "")
    
    return result.isEmpty ? "\(n)" : result
  }
}
