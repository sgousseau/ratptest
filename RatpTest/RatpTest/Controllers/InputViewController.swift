//
//  InputViewController.swift
//  RatpTest
//
//  Created by Sébastien Gousseau on 19/12/2020.
//

import UIKit

class InputViewController: UIViewController {
  
  @IBOutlet private weak var str1TextField: UITextField!
  @IBOutlet private weak var str2TextField: UITextField!
  @IBOutlet private weak var int1TextField: UITextField!
  @IBOutlet private weak var int2TextField: UITextField!
  @IBOutlet private weak var limitTextField: UITextField!
  
  @IBOutlet private weak var str1ErrorLabel: UILabel!
  @IBOutlet private weak var str2ErrorLabel: UILabel!
  @IBOutlet private weak var int1ErrorLabel: UILabel!
  @IBOutlet private weak var int2ErrorLabel: UILabel!
  @IBOutlet private weak var limitErrorLabel: UILabel!
  
  ///Association of input and its corresponding error label
  private lazy var inputErrorPairs: [UITextField: UILabel] = [
    str1TextField: str1ErrorLabel,
    str2TextField: str2ErrorLabel,
    int1TextField: int1ErrorLabel,
    int2TextField: int2ErrorLabel,
    limitTextField: limitErrorLabel
  ]
  
  ///The view has errors if at least one error label is shown
  private var hasErrors: Bool {
    return inputErrorPairs.reduce(false) { res, new in
      return res || !new.value.isHidden
    }
  }
  
  ///The StringGenerator we want to build with given parameters
  private var generator: StringGenerator?
  
  ///The stat service
  private let statsService: Stats = .live(storageKey: Stats.liveStorageKey)
  
  ///Function used to filter `value` as String input and eventually replace it with `errorString` if filter predicate doesn't match.
  func stringValidationError(_ value: String, _ errorString: String) -> String? {
    return value.isEmpty ? errorString : nil
  }
  
  ///Function used to filter `value` as String input, convert it to Int and compare to `testValue`, eventually replace it with `errorString` if filter predicate doesn't match.
  func integerValidationError(_ value: String, _ testValue: Int, _ errorString: String) -> String? {
    if let value = Int(value) {
      return value < testValue ? nil : errorString
    } else {
      return errorString
    }
  }
  
  ///Function binded to `UITextField.editingDidChange` via Storyboard. Used to process input values and errors
  @IBAction
  func processInput(_ textField: UITextField) {
    let str = textField.text ?? ""
    switch textField {
    case str1TextField, str2TextField:
      inputErrorPairs[textField]?.text = stringValidationError(str, "Please enter any string")
    case int1TextField, int2TextField:
      inputErrorPairs[textField]?.text = integerValidationError(str, Int.maxSquared, "Please enter a valid number between 1 and \(Int.maxSquared)")
    case limitTextField:
      inputErrorPairs[textField]?.text = integerValidationError(str, Int.max, "Please enter a valid number between 1 and \(Int.max)")
    default:
      break
    }
    inputErrorPairs[textField]?.isHidden = inputErrorPairs[textField]?.text == nil
  }
  
  ///Returns a StringGenerator object if initialization suceed, nil otherwise and raise an alert
  func makeStringGenerator(parameters: StringGenerator.Parameters) -> StringGenerator? {
    do {
      let generator = try StringGenerator(parameters: parameters)
      return generator
    } catch {
      if let error = error as? StringGenerator.StringGeneratorError {
        UIAlertController.alert(message: error.description, on: self)
      }
    }
    
    return nil
  }
  
  ///Returns a `StringGenerator.Parameters` object if initialization suceed, nil otherwise.
  func getStringGeneratorParameters() -> StringGenerator.Parameters? {
    guard
      let str1 = str1TextField.text,
      let str2 = str2TextField.text,
      let int1 = Int(int1TextField.text ?? ""),
      let int2 = Int(int2TextField.text ?? ""),
      let limit = Int(limitTextField.text ?? "") else {
      return nil
    }
    
    return (str1: str1, str2: str2, int1: int1, int2: int2, limit: limit)
  }
  
  ///Converts a `StringGenerator.Parameters` tuple to a readable string value used as a tag
  func inputToStat(input: StringGenerator.Parameters) -> String {
    return "\(input.str1)\(input.str2) (\(input.int1), \(input.int2), \(input.limit))"
  }
  
  ///Route to the display list screen. It prepares the `StringGenerator` object as well as processing the stat hits before requesting the corresponding `UIStoryboardSegue`
  @IBAction func goToDisplay() {
    if
      let parameters = getStringGeneratorParameters(),
      let generator = makeStringGenerator(parameters: parameters),
       !hasErrors {
      
      self.statsService.addStat(inputToStat(input: parameters))
      self.generator = generator
      
      performSegue(withIdentifier: Constants.Segue.inputToDisplay, sender: self)
    }
  }
  
  ///Configure the display list screen before presentation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //Inputs have been filtered so it's not possible to get here with wrong values
    if
      let displayController = segue.destination as? DisplayViewController,
      let generator = generator {
      displayController.generator = generator
    }
  }
}

extension InputViewController: UITextFieldDelegate {
  
  ///Called when user hits the cross button
  func textFieldShouldClear(_ textField: UITextField) -> Bool {
    processInput(textField)
    return true
  }
  
  ///Called when user hits the keyboard return button, we tabulate to other field or validate
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    switch textField {
    case str1TextField:
      str2TextField.becomeFirstResponder()
    case str2TextField:
      int1TextField.becomeFirstResponder()
    case int1TextField:
      int2TextField.becomeFirstResponder()
    case int2TextField:
      limitTextField.becomeFirstResponder()
    case limitTextField:
      goToDisplay()
    default:
      break
    }
    
    return true
  }
}
