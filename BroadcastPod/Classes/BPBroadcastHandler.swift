//
//  BroadcastHandler.swift
//  BroadcastPod
//
//  Created by Zeeshan Saiyed on 16/09/21.
//

import Foundation
//
//  SampleHandler.swift
//  BroadCastExtension
//
//  Created by Zeeshan Saiyed on 15/09/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import ReplayKit

//private enum Constants {
//    // the App Group ID value that the app and the broadcast extension targets are setup with. It differs for each app.
//    static let appGroupIdentifier = "group.com.signalwire.screensharing.appgroup"
//}

open class BPBroadcastHandler: RPBroadcastSampleHandler {
    
    private var clientConnection: SocketConnection?
    private var uploader: SampleUploader?
    
    private var frameCount: Int = 0
    
    var appGroupIdentifier : String = ""
         
    
    var socketFilePath: String {
        let sharedContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupIdentifier)
        return sharedContainer?.appendingPathComponent("rtc_SSFD").path ?? ""
    }
    
    public init(identifier:String) {
        super.init()
        self.appGroupIdentifier = identifier
        if let connection = SocketConnection(filePath: socketFilePath) {
            clientConnection = connection
            setupConnection()
            
            uploader = SampleUploader(connection: connection)
        }
    }
   public override init() {
        super.init()
        if let connection = SocketConnection(filePath: socketFilePath) {
            clientConnection = connection
            setupConnection()
            
            uploader = SampleUploader(connection: connection)
        }
    }
    
    open override func broadcastStarted(withSetupInfo setupInfo: [String: NSObject]?) {
        // User has requested to start the broadcast. Setup info from the UI extension can be supplied but optional.
        print("@@broadcastStarted")
        frameCount = 0
        
        DarwinNotificationCenter.shared.postNotification(.broadcastStarted)
        openConnection()
    }
    
    open override func broadcastPaused() {
        // User has requested to pause the broadcast. Samples will stop being delivered.
    }
    
    open override func broadcastResumed() {
        // User has requested to resume the broadcast. Samples delivery will resume.
    }
    
    open override func broadcastFinished() {
        // User has requested to finish the broadcast.
        print("@@broadcastStarted")
        DarwinNotificationCenter.shared.postNotification(.broadcastStopped)
        clientConnection?.close()
    }
    
    open override func processSampleBuffer(_ sampleBuffer: CMSampleBuffer, with sampleBufferType: RPSampleBufferType) {
        print("@@processSampleBuffer")
        switch sampleBufferType {
        case RPSampleBufferType.video:
            // very simple mechanism for adjusting frame rate by using every third frame
            frameCount += 1
            if frameCount % 3 == 0 {
                uploader?.send(sample: sampleBuffer)
            }
        default:
            break
        }
    }
}

private extension BPBroadcastHandler {
    
    func setupConnection() {
        clientConnection?.didClose = { [weak self] error in
            print("client connection did close \(String(describing: error))")
            
            if let error = error {
                self?.finishBroadcastWithError(error)
            } else {
                // the displayed failure message is more user friendly when using NSError instead of Error
                let JMScreenSharingStopped = 10001
                let customError = NSError(domain: RPRecordingErrorDomain, code: JMScreenSharingStopped, userInfo: [NSLocalizedDescriptionKey: "Screen sharing stopped"])
                self?.finishBroadcastWithError(customError)
            }
        }
    }
    
    func openConnection() {
        let queue = DispatchQueue(label: "broadcast.connectTimer")
        let timer = DispatchSource.makeTimerSource(queue: queue)
        timer.schedule(deadline: .now(), repeating: .milliseconds(100), leeway: .milliseconds(500))
        timer.setEventHandler { [weak self] in
            guard self?.clientConnection?.open() == true else {
                return
            }
            
            timer.cancel()
        }
        
        timer.resume()
    }
}
