### Roadmap
TODO: allow for multiple files at once? have a settings file and a settings text; improve encrypt/decrpyt failure messages; redesign action classes to have different methods depending upon whether cli or api and then main class main method looks like what? well maybe api accesses methods directly with some kind of wrapper built into the api class; encrypt/decrypt gpg utilize passed in key too? :keylist_mode http://www.rubydoc.info/github/ueno/ruby-gpgme/GPGME/Ctx#new-class_method (modify .process); error checking on file with password in cli; puppet, chef and inspec integrations; ansible integrations? (rpc interface probably); split process into two methods for each algorithm; vagrant instance tests; change api to rpc or rest?

### 1.1.0
- Added capability to encrypt and decrypt with GNUPG/GPG.

### 1.0.0
- Initial Release
