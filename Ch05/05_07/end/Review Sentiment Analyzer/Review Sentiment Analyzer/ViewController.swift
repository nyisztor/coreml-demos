//
//  ViewController.swift
//  Review Sentiment Analyzer
//
//  Created by Nyisztor, Karoly on 10/3/18.
//  Copyright © 2018 Nyisztor, Karoly. All rights reserved.
//
// **Machine Learning with Core ML 2 and Swift** - Source Code
//
// Get the course **[on Udemy using this discounted coupon](https://www.udemy.com/machine-learning-with-core-ml2-and-swift/?couponCode=GITHUB)**
//
// The book version is available **[on Amazon](https://www.amazon.com/dp/B07F2NYDTH)**
//
// _ _ _
//: ## Review sentiment analyzer app
//: This app uses the review sentiment analyzer to determine the sentiment of a written review
//:
//: - Callout(Interested in Swift programming?):
//: Check out my **[Youtube channel](https://www.youtube.com/c/swiftprogrammingtutorials)**
//: my courses on **[Udemy](https://www.udemy.com/user/karolynyisztor/)**, **[Lynda](https://www.lynda.com/Karoly-Nyisztor/9655357-1.html)** and **[Pluralsight](https://www.pluralsight.com/profile/author/karoly-nyisztor)**.
//: Website **[www.leakka.com](http://www.leakka.com)**
//: ---

import UIKit
import NaturalLanguage

class ViewController: UIViewController {
    
    @IBOutlet weak var sentimentImageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var clearButton: UIButton!
    
    private lazy var sentimentClassifier: NLModel? = {
        let model = try? NLModel(mlModel: ReviewClassifier().model)
        return model
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func onClearPressed(_ sender: Any) {
        textView.text = ""
        clearButton.isEnabled = false
    }
    
}

extension ViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text.isEmpty == false,
            text == "\n" {
            //...
            if let label = sentimentClassifier?.predictedLabel(for: textView.text) {
                switch label {
                case "positive":                    
                    sentimentImageView.image = UIImage(named: "positive")
                case "negative":
                    sentimentImageView.image = UIImage(named: "negative")
                default:
                    sentimentImageView.image = UIImage(named: "what")
                }
            }
            
            textView.resignFirstResponder()
        }
        return true
    }

    func textViewDidChange(_ textView: UITextView) {
        clearButton.isEnabled = !textView.text.isEmpty
    }
}
