#if os(iOS)
import Flutter
import UIKit
import Contacts
import ContactsUI

@available(iOS 9.0, *)
@available(macOS, unavailable)
public class ContactViewIOS: NSObject, CNContactViewControllerDelegate, CNContactPickerDelegate {

    private let flutterContactsPlugin: FlutterContactsPlugin
    
    private var keyWindow: UIWindow? {
        if #available(iOS 13, *) {
                // Get key window from currently active scene
                return UIApplication.shared.connectedScenes
                        .filter { $0.activationState == .foregroundActive }
                        .compactMap { $0 as? UIWindowScene }
                        .flatMap { $0.windows }
                        .first { $0.isKeyWindow }
        } else {
                // Fallback to old way from application delgate
                return UIApplication.shared.delegate!.window!
        }
    }

    public var rootViewController: UIViewController {
        let window = keyWindow
        assert(window != nil)
        return window!.rootViewController!
    }

    init(_ flutterContactsPlugin: FlutterContactsPlugin) {
        self.flutterContactsPlugin = flutterContactsPlugin;
    }

    public func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) { 
        if let result = flutterContactsPlugin.externalResult {
            result(contact?.identifier)
            flutterContactsPlugin.externalResult = nil
        }
        viewController.dismiss(animated: true, completion: nil)
    }

    public func contactPicker(_: CNContactPickerViewController, didSelect contact: CNContact) {
        if let result = flutterContactsPlugin.externalResult {
            result(contact.identifier)
            flutterContactsPlugin.externalResult = nil
        }
    }

    // public func contactPicker(_: CNContactPicker, didSelect contact: CNContact) {
    //     if let result = flutterContactsPlugin.externalResult {
    //         result(contact.identifier)
    //         flutterContactsPlugin.externalResult = nil
    //     }
    // }

    public func contactPickerDidCancel(_: CNContactPickerViewController) {
        if let result = flutterContactsPlugin.externalResult {
            result(nil)
            flutterContactsPlugin.externalResult = nil
        }
    }

    // public func contactPickerDidCancel(_: CNContactPicker) {
    //     if let result = flutterContactsPlugin.externalResult {
    //         result(nil)
    //         flutterContactsPlugin.externalResult = nil
    //     }
    // }
}
#endif
