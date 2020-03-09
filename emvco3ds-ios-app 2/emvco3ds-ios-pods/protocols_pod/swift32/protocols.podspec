Pod::Spec.new do |s|

s.name = 'emvco3ds_protocols_ios'

s.version = '0.1.1.1'

s.license = { :type => 'BSD' }

s.homepage = 'https://www.ul-ts.com'

s.authors = { 'WilliamKinaan' => 'william.kinaan@ul.com' }

s.summary = 'UL iOS 3DS Emvco protocols'

s.platform = :ios

s.source = { :path => 'emvco3ds_protocols_ios.framework.zip' }

s.ios.deployment_target = '8.0'

s.ios.vendored_frameworks = 'emvco3ds_protocols_ios.framework'

end
