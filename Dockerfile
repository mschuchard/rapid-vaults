# RapidVaults: automated rake testing in reproducible environment

FROM fedora:25
RUN dnf install ruby -y
RUN gem install --no-document rubocop reek rspec rake
COPY / .
ENTRYPOINT ["rake"]
