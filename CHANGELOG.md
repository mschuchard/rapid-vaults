### Roadmap
TODO: add gpg password option/decrypt/generate?(need change to .process and .main)/new system test; allow for multiple files at once? have a settings file and a settings text; improve encrypt/decrpyt failure messages; redesign action classes to have different methods depending upon whether cli or api and then main class main method looks like what? well maybe api accesses methods directly with some kind of wrapper built into the api class; cli returns settings to main/api passes settings to main; openssl versus gpg encrypt/decrypt method selection needs to occur in main class main and not sublass main; encrypt gpg non-interactive password (pass in key too?); error checking on file with password in cli

### 1.0
- Initial Release

https://github.com/ueno/ruby-gpgme/blob/master/examples/roundtrip.rb
https://stackoverflow.com/questions/11548337/how-can-i-asymmetrically-encrypt-data-using-openpgp-with-ruby
