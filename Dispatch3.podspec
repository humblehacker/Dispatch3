Pod::Spec.new do |s|
  s.name             = 'Dispatch3'
  s.version          = '0.1.0'
  s.summary          = 'iOS10 workalike Dispatch framework'
  s.description      = <<-DESC
  Dispatch3 is a wrapper around the iOS9 Dispatch framework providing the same syntax and functionality as the new Dispatch framework in iOS10. It provides features like the ability to return values and throw exceptions from sync closures, dispatchPrecondition(), and the much simpler replacement for dispatch_after().
                       DESC

  s.homepage         = 'https://github.com/humblehacker/Dispatch3'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'David Whetstone' => 'david@humblehacker.com' }
  s.source           = { :git => 'https://github.com/humblehacker/Dispatch3.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/humblehacker'

  s.ios.deployment_target = '9.0'

  s.source_files = 'Dispatch3/Classes/**/*'
end
