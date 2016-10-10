
import Cocoa

@NSApplicationMain

class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var drawingView: DrawingView!
    @IBOutlet weak var imageWell: NSImageView!
    //@IBOutlet weak var label: NSTextField!
    //@IBOutlet weak var view: NSView!
    
    var view = NSView(frame: NSMakeRect(0,0,1920,1080))
    var coordArray: [CGPoint] = []
    
    
    func applicationWillUpdate(aNotification: NSNotification) { }


        ///////////////////////////////////////////
        ////// Use flipped coordinate system //////
        ///////////////////////////////////////////
    
        internal var flipped: Bool { return true }
        deinit { }
    
    
    
    func applicationDidFinishLaunching(notification: NSNotification) { }
    
    func applicationWillTerminate(aNotification: NSNotification) { }
}

//the end of code