### 1.1.1
- Added Puppet and Chef integrations.
- Add `outdir` CLI option.

### 1.1.0
- Added capability to encrypt and decrypt with GNUPG/GPG.

### 1.0.0
- Initial Release

### Roadmap
TODO: have different settings for file versus read in file?; improve encrypt/decrpyt failure messages; encrypt/decrypt gpg utilize passed in key too? :keylist_mode http://www.rubydoc.info/github/ueno/ruby-gpgme/GPGME/Ctx#new-class_method (modify .process); error checking on file with password in cli; hiera, chef and inspec integrations; ansible integrations?; vagrant instance tests; change api to rpc or rest?

actions are ui dep
main and process are action dep

redesign action classes to have different methods depending upon whether cli or api and then main class main method looks like what? well maybe api accesses methods directly with some kind of wrapper built into the api class; but this may be a bad idea given the need for .process
