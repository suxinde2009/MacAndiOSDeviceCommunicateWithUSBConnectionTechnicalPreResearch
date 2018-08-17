//
//  ViewController.swift
//  iOSClient
//
//  Created by SuXinDe on 2018/8/18.
//  Copyright © 2018年 su xinde. All rights reserved.
//

import UIKit
import AVFoundation
import PeerTalk

enum USBProtocol: UInt32 {
    case PING = 102
    case PONG = 103
    case DATA = 104
}

class ViewController: UIViewController, PTChannelDelegate, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    private weak var peerChannel:PTChannel? = nil
    private weak var serverChannel: PTChannel? = nil
    let captureSession = AVCaptureSession()
    var previewLayer : AVCaptureVideoPreviewLayer?
    var captureDevice : AVCaptureDevice?
    let bufferQueue = DispatchQueue(label: "buffer")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let c = PTChannel(delegate: self)
        
        c?.listen(onPort: 2345, iPv4Address: INADDR_LOOPBACK, callback: { err in
            if let err = err {
                NSLog("%s", err.localizedDescription)
            } else {
                self.serverChannel = c
            }
        })
        
        captureSession.sessionPreset = AVCaptureSession.Preset.high
        if let devices = AVCaptureDevice.devices() as? [AVCaptureDevice] {
            for device in devices {
                if let device = device as? AVCaptureDevice {
                    if (device.hasMediaType(AVMediaType.video)) {
                        if(device.position == .back) {
                            captureDevice = device
                            beginSession()
                        }
                    }
                }
            }
        }
        
        let videoDataOutput = AVCaptureVideoDataOutput.init()
        videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as AnyHashable: kCVPixelFormatType_32BGRA] as! [String : Any]
        videoDataOutput.setSampleBufferDelegate(self, queue: bufferQueue)
        self.captureSession.addOutput(videoDataOutput)
    }
    
    func beginSession() {
        
        do {
            try captureSession.addInput(AVCaptureDeviceInput(device: captureDevice!))
        }
        catch  {
            NSLog("\(error)")
        }
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        if let previewLayer = previewLayer {
            self.view.layer.addSublayer(previewLayer)
            previewLayer.frame = self.view.layer.frame
        }
        
        captureSession.startRunning()
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
//        guard let buffer = sampleBuffer as? else {
//            return
//        }
//
        
        if let buf = CMSampleBufferGetImageBuffer(sampleBuffer) {
            let ciImage = CIImage(cvPixelBuffer: buf)
            
            let context = CIContext()
            if let cgImage = context.createCGImage(ciImage, from: ciImage.extent) {
                let uiImage = UIImage(cgImage: cgImage)
                
                if let data = UIImageJPEGRepresentation(uiImage, 0.5) {
                    peerChannel?.sendFrame(ofType: 104, tag: peerChannel?.protocol?.newTag() ?? 0, withPayload: (data as NSData).createReferencingDispatchData(), callback: nil)
                }
            }
        }
    }
    

    
    func ioFrameChannel(_ channel: PTChannel!, shouldAcceptFrameOfType type: UInt32, tag: UInt32, payloadSize: UInt32) -> Bool {
        
        if (channel != peerChannel) {
            return false
        }
        
        if (type != USBProtocol.PING.rawValue) {
            channel.close()
            return false;
        }
        
        return true
    }
    
    func ioFrameChannel(_ channel: PTChannel!, didAcceptConnection otherChannel: PTChannel!, from address: PTAddress!) {
        if let peerChannel = self.peerChannel {
            peerChannel.cancel()
        }
        
        peerChannel = otherChannel
        peerChannel?.userInfo = address
        
        NSLog("Connect to %s", address)
    }
    
    func ioFrameChannel(_ channel: PTChannel!, didEndWithError error: Error!) {
        if let error = error {
            NSLog("%s", error.localizedDescription)
        } else {
            NSLog("Disconnected")
        }
    }
    
    func ioFrameChannel(_ channel: PTChannel!, didReceiveFrameOfType type: UInt32, tag: UInt32, payload: PTData!) {
        if type == USBProtocol.PING.rawValue {
            peerChannel?.sendFrame(ofType: USBProtocol.PONG.rawValue, tag: tag, withPayload: nil, callback: nil)
        }
    }
}


