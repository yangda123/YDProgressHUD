Pod::Spec.new do |s|

s.name = "YDProgressHUD"

s.version = "1.0"

s.summary = "加载进度框／提示框"

s.homepage = "https://github.com/yangda123/YDProgressHUD"

s.license = "MIT"

s.author = { "yangda" => "18205598086@163.com" }

s.platform = :ios, "8.0"

s.source = { :git => "https://github.com/yangda123/YDProgressHUD.git", :tag => "1.0" }

s.source_files = "YDProgressHUD", "YDProgressHUD/*.{h,m}"

s.framework = "UIKit"

s.requires_arc = true

end
