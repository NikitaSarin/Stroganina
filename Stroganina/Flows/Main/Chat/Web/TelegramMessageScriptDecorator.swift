//
//  TelegramMessageScriptDecorator.swift
//  Stroganina
//
//  Created by Alex Shipin on 02.04.2022.
//

import Foundation
import SwiftUI

final class TelegramMessageScriptDecorator {
    func createScript(isSelf: Bool) -> String {
        var script = """
            document.getElementsByClassName('tgme_widget_message_user')[0].remove();
            document.getElementsByClassName('tgme_widget_message_bubble_tail')[0].remove();
            document.getElementsByClassName('tgme_widget_message_bubble_logo')[0].remove();
            document.getElementsByClassName('tgme_widget_message js-widget_message')[0].innerHTML =
            document.getElementsByClassName('tgme_widget_message js-widget_message')[0].innerHTML.replace('class=\"tgme_widget_message_bubble\"', '');
        """
        if isSelf {
            script += setColor(color.autor, element: "tgme_widget_message_owner_name")
            script += setColor(color.autor, element: "tgme_widget_message_author_name")
            script += setColor(color.replay, element: "tgme_widget_message_metatext js-message_reply_text")
            script += setColor(color.body, element: "tgme_widget_message_text js-message_text")
            script += setColor(color.link, element: "link_anchor flex_ellipsis")
            script += setColor(color.meta, element: "tgme_widget_message_views")
            script += setColor(color.meta, element: "tgme_widget_message_meta")
            script += setColor(color.meta, element: "tgme_widget_message_error")
        }
        return script
    }

    private let color: ColorScheme = .init()

    private func setColor(_ color: Color, element: String) -> String {
        guard let hex = color.toHexString() else {
            return ""
        }
        return """
            \n
            if (document.getElementsByClassName('\(element)').length > 0) {
                document.getElementsByClassName('\(element)')[0].innerHTML = "<font color=\\"\(hex)\\">" + document.getElementsByClassName('\(element)')[0].innerHTML + "</font>";
            }
        """
    }

    private struct ColorScheme {
        let autor: Color = .tg_autor
        let replay: Color = .tg_meta
        let body: Color = .tg_white
        let link: Color = .tg_link
        let meta: Color = .tg_meta
    }
}

extension Color {
    func toHexString() -> String? {
        #if canImport(UIKit)
        typealias NativeColor = UIColor
        #elseif canImport(AppKit)
        typealias NativeColor = NSColor
        #endif

        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0

        guard NativeColor(self).getRed(&r, green: &g, blue: &b, alpha: &a) else {
            return nil
        }

        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0

        return NSString(format:"#%06x", rgb) as String
    }
}
