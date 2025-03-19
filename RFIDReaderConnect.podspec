Pod::Spec.new do |spec|
    spec.name          = "RFIDReaderConnect"
    spec.version       = "1.0.0"
    spec.summary       = "A multiplatform framework for RFID reading."
    spec.homepage      = "https://github.com/RFIDReader/RFIDReaderConnect-swift-distribution"
    spec.license       = { :type => "Proprietary", :text => <<-LICENSE
RFIDReaderConnect SDK License Agreement

Copyright (c) 2025 Pratham Jaiswal. All rights reserved.

1. Grant of License
   Pratham Jaiswal ("Licensor") grants you ("Licensee") a non-exclusive, non-transferable, revocable license to use the RFIDReaderConnect SDK ("Software") solely for the purpose of integrating it into your applications, subject to the terms of this Agreement.

2. Ownership
   The Software is owned by Pratham Jaiswal and is protected by copyright laws and international treaties. All rights not expressly granted herein are reserved by the Licensor.

3. Restrictions
   You may not:
   - Modify, adapt, translate, or create derivative works of the Software.
   - Reverse engineer, decompile, disassemble, or attempt to derive the source code of the Software, except as permitted by applicable law.
   - Distribute, sublicense, lease, rent, or otherwise transfer the Software to any third party.
   - Remove or alter any copyright, trademark, or other proprietary notices in the Software.

4. Distribution
   The Software may only be distributed by the Licensor. Any distribution by Licensee or third parties is strictly prohibited.

5. Termination
   This license is effective until terminated. The Licensor may terminate this license at any time if you breach its terms. Upon termination, you must cease all use of the Software and destroy all copies in your possession.

6. No Warranty
   The Software is provided "as is" without warranty of any kind, express or implied, including but not limited to warranties of merchantability, fitness for a particular purpose, or non-infringement.

7. Limitation of Liability
   In no event shall the Licensor be liable for any damages arising from the use of the Software, including but not limited to indirect, incidental, or consequential damages.

By using the Software, you agree to be bound by the terms of this Agreement.
                            LICENSE
                         }
    spec.author        = { "Pratham Jaiswal" => "pr47h4m@gmail.com" }
    spec.source       = { :http => "https://github.com/RFIDReader/RFIDReaderConnect-swift-distribution/raw/refs/heads/master/releases/download/v1.0.0/RFIDReaderConnect.xcframework.zip" }
    spec.vendored_frameworks = "RFIDReaderConnect.xcframework"
    spec.platforms     = { :ios => "13.0", :macos => "13.0" }
end
