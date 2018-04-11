### Roadmap
TODO: add gpg generate?(need change to .process and .main)/new system tests for gpgme; allow for multiple files at once? have a settings file and a settings text; improve encrypt/decrpyt failure messages; redesign action classes to have different methods depending upon whether cli or api and then main class main method looks like what? well maybe api accesses methods directly with some kind of wrapper built into the api class; cli returns settings to main/api passes settings to main; openssl versus gpg encrypt/decrypt method selection needs to occur in main class main and not sublass main; encrypt/decrypt gpg utilize passed in key too? :keylist_mode; error checking on file with password in cli; puppet, chef and inspec integrations; split process into two methods for each algorithm

### 1.1.0
- Added capability to encrypt and decrypt with GNUPG/GPG.

### 1.0.0
- Initial Release
