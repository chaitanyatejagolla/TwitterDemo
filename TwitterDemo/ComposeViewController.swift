//
//  ComposeViewController.swift
//  TwitterDemo
//
//  Created by Golla, Chaitanya Teja on 4/16/17.
//  Copyright © 2017 Golla, Chaitanya Teja. All rights reserved.
//

import UIKit

protocol ComposeTweetDelegate {
    func onComposeTweet(from tweet: Tweet)
}

class ComposeViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    var tweet: Tweet!
    var composeTweetDelegate: ComposeTweetDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.textColor = UIColor.lightGray
        textView.delegate = self
        
        profilePic.setImageWith(tweet.user!.profileUrl!)
        nameLabel.text = tweet.user!.name
        screenNameLabel.text = "@\(tweet.user!.screenName!)"
        
        
        // Do any additional setup after loading the view.
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = nil
        textView.textColor = UIColor.black
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTweetButton(_ sender: UIBarButtonItem) {
        tweet.text = textView.text
        tweet.timestamp = Date()
        
        composeTweetDelegate.onComposeTweet(from: tweet)
        dismiss(animated: true, completion: nil)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
