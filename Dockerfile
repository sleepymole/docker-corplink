ARG BASE_TAG="develop"
ARG BASE_IMAGE="core-ubuntu-focal"
FROM kasmweb/$BASE_IMAGE:$BASE_TAG
USER root

ENV HOME /home/kasm-default-profile
ENV STARTUPDIR /dockerstartup
ENV INST_SCRIPTS $STARTUPDIR/install
WORKDIR $HOME

######### Customize Container Here ###########

# Install Google Chrome
COPY ./src/ubuntu/install/chrome $INST_SCRIPTS/chrome/
RUN bash $INST_SCRIPTS/chrome/install_chrome.sh  && rm -rf $INST_SCRIPTS/chrome/

# Install socks5
COPY --from=serjs/go-socks5-proxy /socks5 /usr/local/bin/socks5

# Install Corplink
COPY ./src/ubuntu/install/corplink $INST_SCRIPTS/corplink/
RUN bash $INST_SCRIPTS/corplink/install_corplink.sh  && rm -rf $INST_SCRIPTS/corplink/

COPY ./src/ubuntu/install/corplink/custom_startup.sh $STARTUPDIR/custom_startup.sh
RUN chmod +x $STARTUPDIR/custom_startup.sh
RUN chmod 755 $STARTUPDIR/custom_startup.sh

######### End Customizations ###########

RUN chown 1000:0 $HOME

ENV HOME /home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER root
