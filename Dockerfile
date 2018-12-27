# RapidVaults: automated rake testing in reproducible environment

FROM fedora:26
RUN dnf install ruby -y
RUN gem install --no-document  grpc grpc-tools rubocop reek rspec rake
COPY / .
ENTRYPOINT ["rake"]
