//
//  ViewController.swift
//  NSURLSession
//
//  Created by lucas on 15/11/23.
//  Copyright © 2015年 三只小猪. All rights reserved.
//

import UIKit

class ViewController: UIViewController, NSURLSessionDelegate, NSURLSessionDownloadDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    
    private var inProcessSession: NSURLSession?
    private var backgroundSession: NSURLSession?
    
    private var cancellableTask: NSURLSessionDownloadTask?
    private var resumableTask: NSURLSessionDownloadTask?
    private var backgroundTask: NSURLSessionDownloadTask?
    
    private var partialDownload: NSData?
    
    @IBOutlet var startButtons: [UIBarButtonItem]!
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.progressView.hidden = true
        self.progressView.progress = 0.0
        
        self.createInProcessSession()
        self.backgroundSession = self.createBackgroundSession()
    }
    
    // MARK: IBAction Methods
 
    @IBAction func startCancellable(sender: UIBarButtonItem) {
        if self.cancellableTask == nil {
            if self.inProcessSession == nil {
                self.createInProcessSession()
            }
            self.cancellableTask = self.createURLSessionDownloadTask("https://farm6.staticflickr.com/5505/9824098016_0e28a047c2_b_d.jpg")
            self.setDowaloadButtonsAsEnabled(false)
            self.imageView.hidden = true
            self.cancellableTask!.resume()
        }
    }
    
    @IBAction func cancelCancellable(sender: UIBarButtonItem) {
        if (self.cancellableTask != nil) {
            self.cancellableTask!.cancel()
            self.cancellableTask = nil
        } else if (self.resumableTask != nil) {
            self.resumableTask?.cancelByProducingResumeData() {
                (resumeData: NSData?) -> Void in
                self.partialDownload = resumeData
                self.resumableTask = nil
            }
        } else if(self.backgroundTask != nil) {
            self.backgroundTask!.cancel()
            self.backgroundTask = nil
        }
    }

    @IBAction func startResumable(sender: UIBarButtonItem) {
        if (self.resumableTask == nil) {
            if self.inProcessSession == nil {
               self.createInProcessSession()
            }
            
            if self.partialDownload != nil {
                self.resumableTask = self.inProcessSession!.downloadTaskWithResumeData(self.partialDownload!)
            } else {
                self.resumableTask = self.createURLSessionDownloadTask("https://farm3.staticflickr.com/2846/9823925914_78cd653ac9_b_d.jpg")
            }
            self.setDowaloadButtonsAsEnabled(false)
            self.imageView.hidden = true
            self.resumableTask!.resume()
        }
    }
    
    @IBAction func startBackground(sender: UIBarButtonItem) {
        let request = NSURLRequest(URL: NSURL(string: "https://farm3.staticflickr.com/2831/9823890176_82b4165653_b_d.jpg")!)
        self.backgroundTask = self.backgroundSession?.downloadTaskWithRequest(request)
        self.setDowaloadButtonsAsEnabled(false)
        self.imageView.hidden = true
        self.backgroundTask?.resume()
    }
    
    // MARK: NSURLSessionDownloadDelegate
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        do {
            let fileManager = NSFileManager.defaultManager()
            let URLs = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask)
            let documentsDirectory = URLs.first
            let destinationPath = documentsDirectory?.URLByAppendingPathComponent(location.lastPathComponent!)
       
            if fileManager.fileExistsAtPath((destinationPath?.path)!) {
                try fileManager.removeItemAtURL(destinationPath!)
            }
            
            try fileManager.copyItemAtURL(location, toURL: destinationPath!)
            
            dispatch_async(dispatch_get_main_queue()) {
                let image = UIImage(contentsOfFile: (destinationPath?.path)!)
                self.imageView?.image = image
                self.imageView?.contentMode = .ScaleAspectFill
                self.imageView?.hidden = false
            }
        } catch {
            print(error)
            print("Couldn't copy the downloaded file.")
        }
        if downloadTask == self.cancellableTask {
            cancellableTask = nil
        } else if downloadTask == self.resumableTask {
            self.resumableTask = nil
            partialDownload = nil
        } else if session == self.backgroundSession {
            self.backgroundTask = nil
            let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
            if (appDelegate != nil && appDelegate!.backgroundURLSessionCompletionHandler != nil) {
                let handler = appDelegate?.backgroundURLSessionCompletionHandler
                appDelegate!.backgroundURLSessionCompletionHandler = nil
                handler!()
            }
        }
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        dispatch_async(dispatch_get_main_queue()) {
            self.progressView.hidden = true
            self.setDowaloadButtonsAsEnabled(true)
        }
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        let currentProgress = totalBytesWritten / totalBytesExpectedToWrite
        dispatch_async(dispatch_get_main_queue()) {
            self.progressView.hidden = false
            self.progressView.progress = Float(currentProgress)
        }
    }
    
    // MARK: Private Methods
    
    private func createInProcessSession() {
        let sessionConfigureation = NSURLSessionConfiguration.defaultSessionConfiguration()
        self.inProcessSession = NSURLSession(configuration: sessionConfigureation, delegate: self, delegateQueue: nil)
        self.inProcessSession?.sessionDescription = "in-process NSURLSession"
    }

    private func createURLSessionDownloadTask(URLString: String) -> NSURLSessionDownloadTask? {
        let request = NSURLRequest(URL: NSURL(string: URLString)!)
        return self.inProcessSession?.downloadTaskWithRequest(request)
    }
    
    private func setDowaloadButtonsAsEnabled(enabled: Bool) {
        for barButtonItem in self.startButtons {
            barButtonItem.enabled = enabled
        }
    }
    
    private func createBackgroundSession() -> NSURLSession {
        let URLSessionConfigureation = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier("io.github.lucasleelz.NSURLSession.BackgroundSession")
        let result = NSURLSession(configuration: URLSessionConfigureation, delegate: self, delegateQueue: nil)
        result.sessionDescription = "Background session"
        
        return result
    }
}


