import UIKit

struct Dimens {
    static let button_size_main         = CGFloat(40)
    static let button_size_cuisine      = CGFloat(96)
    static let button_size_retry        = CGFloat(120)
    
    static let font_size_main           = CGFloat(16)
    static let font_size_headings       = font_size_main * 1.5
    static let font_size_cuisine_button = font_size_main * 0.75
    static let font_size_error_message  = font_size_headings
    
    static let icon_size_cuisine        = CGFloat(48)
    static let icon_size_error          = CGFloat(96)
    
    static let padding_main             = CGFloat(8)
    static let padding_viewport         = CGFloat(8)
    static let padding_button_text      = padding_main * 2
    static let padding_button_cuisine   = padding_main * 1.5
    
    static let margin_main              = CGFloat(4)
    static let margin_error_message     = CGFloat(24)
    
    static let border_radius_main       = CGFloat(3)
    static let border_radius_cuisine    = CGFloat(5)
    
    static let max_text_width           = CGFloat(550)
    static let placeholder_height       = CGFloat(240)
    static let recipe_image_height      = CGFloat(180)
    
    static let line_spacing_recipe_card = CGFloat(2.5)
}
