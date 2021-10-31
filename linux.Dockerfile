# escape=`
FROM lacledeslan/steamcmd:linux as SATISFACT-builder

ARG contentServer=content.lacledeslan.net

# Copy cached build files (if any)
# COPY ./dist/build-cache /output

# Download Satisfactory Dedicated Server
RUN mkdir --parents /output &&`
    /app/steamcmd.sh +login anonymous +force_install_dir /output +app_update 1690800 validate +quit;


#=======================================================================
FROM debian:bullseye-slim

ARG BUILDNODE=unspecified
ARG SOURCE_COMMIT=unspecified

HEALTHCHECK NONE

RUN dpkg --add-architecture i386 &&`
    apt-get update && apt-get install -y `
        ca-certificates lib32gcc-s1 libtinfo5:i386 libstdc++6 libstdc++6:i386 locales locales-all tmux &&`
    apt-get clean &&`
    echo "LC_ALL=en_US.UTF-8" >> /etc/environment &&`
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*;

ENV LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8

LABEL com.lacledeslan.build-node=$BUILDNODE `
      org.label-schema.schema-version="1.0" `
      org.label-schema.url="https://github.com/LacledesLAN/README.1ST" `
      org.label-schema.vcs-ref=$SOURCE_COMMIT `
      org.label-schema.vendor="Laclede's LAN" `
      org.label-schema.description="Satisfactory Dedicated Server" `
      org.label-schema.vcs-url="https://github.com/LacledesLAN/gamesvr-SATISFACT"

# Set up Enviornment
RUN useradd --home /app --gid root --system SATISFACT &&`
    chown SATISFACT:root -R /app;
    #mkdir -p /app/ll-tests &&`

COPY --chown=SATISFACT:root --from=SATISFACT-builder /output /app

#COPY --chown=SATISFACT:root ./dist/ll-tests /app/ll-tests

RUN chmod +x /app/ll-tests/*.sh;

USER SATISFACT

RUN echo $'\n\nLinking steamclient.so to prevent srcds_run errors' &&`
        mkdir --parents /app/.steam/sdk32 &&`
        ln -s /app/bin/steamclient.so /app/.steam/sdk32/steamclient.so

WORKDIR /app

CMD ["/bin/bash"]

ONBUILD USER root
