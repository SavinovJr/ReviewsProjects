//
//  ViewController.swift
//  ReviewsApp
//
//  Created by Антон Савинов on 07/07/2019.
//  Copyright © 2019 ANTON.TESTOV.INC. All rights reserved.
//

import UIKit
import NaturalLanguage

class ViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageView: UIImageView!

    private lazy var sentimentClassifier: NLModel? = {
        let model = try? NLModel(mlModel: ReviewClassifier().model)
        return model
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func clearAction(_ sender: Any) {
        textView.text = ""
    }

}

extension ViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text.isEmpty == false,
            text == "\n" {

            if let label = sentimentClassifier?.predictedLabel(for: textView.text) {
                switch label {
                case "positive":
                    imageView.image = UIImage(named: "positive")
                case "negative":
                    imageView.image = UIImage(named: "negative")
                default:
                    imageView.image = UIImage(named: "neutral")
                }
            }
        }
        textView.resignFirstResponder()
        return true
    }
}

