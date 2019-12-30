FROM debian:sid

LABEL maintainer="zimzamfam@gmail.com"
LABEL description="Forked from https://hub.docker.com/r/hackersploit/bugbountytoolkit"

# Environment Variables
ENV HOME /root
ENV DEBIAN_FRONTEND=noninteractive
ENV TIMEZONE=Etc/UTC

# Working Directory
WORKDIR /root
RUN mkdir ${HOME}/toolkit && \
    mkdir ${HOME}/wordlists

# Enable Non-Free Debian sid repos
RUN sed -i 's/main/main contrib non-free/g' /etc/apt/sources.list && \
    apt-get update

# Install apt-utils
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    apt-utils
# Install Essentials
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    gcc \
    git \
    vim \
    wget \
    awscli \
    tzdata \
    curl \
    make \
    whois \
    python \
    python-pip \
    python3 \
    python3-pip \
    perl \
    dnsutils \
    net-tools \
    ssh \
    locate \
    flex \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Install Tool Dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    # dnsenum
    cpanminus \
    # wfuzz
    python-pycurl \
    # knock
    python-dnspython \
    # massdns
    libldns-dev \
    # wpcscan
    libcurl4-openssl-dev \
    libxml2 \
    libxml2-dev \
    libxslt1-dev \
    ruby-dev \
    libgmp-dev \
    zlib1g-dev \
    # masscan
    libpcap-dev \
    # theharvester
    python3.7 \
    # joomscan
    libwww-perl \
    # metasploit-framework
    gnupg \
    && rm -rf /var/lib/apt/lists/*

# Set Timezone
RUN ln -fs /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive tzdata

# configure python(s)
RUN python -m pip install --upgrade setuptools && python3 -m pip install --upgrade setuptools && python3.7 -m pip install --upgrade setuptools
RUN python -m pip install wheel && python3 -m pip install wheel && python3.7 -m pip install wheel && pip3 install wheel

#####################
### Install Tools ###
#####################

# Install Tools from apt repos
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    sqlmap \
    dirb \
    hydra \
    dnsrecon \
    nmap \
    nikto \
    netcat \
    tcpdump \
    tshark \
    john \
    nbtscan \
    dsniff \
    p7zip-full \
    openvpn \
    traceroute \
    lft \
    medusa \
    bzip2 \
    unrar \
    rar \
    unzip \
    tcpreplay \
    tcpick \
    socat \
    stunnel4 \
    yersinia \
    binwalk \
    && rm -rf /var/lib/apt/lists/*

# dnsenum
RUN cd ${HOME}/toolkit && \
    git clone https://github.com/fwaeytens/dnsenum.git && \
    cd dnsenum/ && \
    chmod +x dnsenum.pl && \
    ln -s ${HOME}/toolkit/dnsenum/dnsenum.pl /usr/bin/dnsenum && \
    cpanm String::Random && \
    cpanm Net::IP && \
    cpanm Net::DNS && \
    cpanm Net::Netmask && \
    cpanm XML::Writer

# Sublist3r
RUN cd ${HOME}/toolkit && \
    git clone https://github.com/aboul3la/Sublist3r.git && \
    cd Sublist3r/ && \
    pip install -r requirements.txt && \
    ln -s ${HOME}/toolkit/Sublist3r/sublist3r.py /usr/local/bin/sublist3r

# wfuzz
RUN pip install wfuzz

# knock
RUN cd ${HOME}/toolkit && \
    git clone https://github.com/guelfoweb/knock.git && \
    cd knock && \
    chmod +x setup.py && \
    python setup.py install

# massdns
RUN cd ${HOME}/toolkit && \
    git clone https://github.com/blechschmidt/massdns.git && \
    cd massdns/ && \
    make && \
    ln -sf ${HOME}/toolkit/massdns/bin/massdns /usr/local/bin/massdns

# wafw00f
RUN cd ${HOME}/toolkit && \
    git clone https://github.com/enablesecurity/wafw00f.git && \
    cd wafw00f && \
    chmod +x setup.py && \
    python setup.py install

# wpscan
RUN cd ${HOME}/toolkit && \
    git clone https://github.com/wpscanteam/wpscan.git && \
    cd wpscan/ && \
    gem install bundler && \
    bundle config set without 'test' && \
    bundle install && \
    gem install wpscan

# commix
RUN cd ${HOME}/toolkit && \
    git clone https://github.com/commixproject/commix.git && \
    cd commix && \
    chmod +x commix.py && \
    ln -sf ${HOME}/toolkit/commix/commix.py /usr/local/bin/commix

# masscan
RUN cd ${HOME}/toolkit && \
    git clone https://github.com/robertdavidgraham/masscan.git && \
    cd masscan && \
    make && \
    ln -sf ${HOME}/toolkit/masscan/bin/masscan /usr/local/bin/masscan

# altdns
RUN cd ${HOME}/toolkit && \
    git clone https://github.com/infosec-au/altdns.git && \
    cd altdns && \
    pip install -r requirements.txt && \
    chmod +x setup.py && \
    python setup.py install

# teh_s3_bucketeers
RUN cd ${HOME}/toolkit && \
    git clone https://github.com/tomdev/teh_s3_bucketeers.git && \
    cd teh_s3_bucketeers && \
    chmod +x bucketeer.sh && \
    ln -sf ${HOME}/toolkit/teh_s3_bucketeers/bucketeer.sh /usr/local/bin/bucketeer

# Recon-ng
RUN cd ${HOME}/toolkit && \
    git clone https://github.com/lanmaster53/recon-ng.git && \
    cd recon-ng && \
    pip3 install -r REQUIREMENTS && \
    chmod +x recon-ng && \
    ln -sf ${HOME}/toolkit/recon-ng/recon-ng /usr/local/bin/recon-ng

# XSStrike
RUN cd ${HOME}/toolkit && \
    git clone https://github.com/s0md3v/XSStrike.git && \
    cd XSStrike && \
    pip3 install -r requirements.txt && \
    chmod +x xsstrike.py && \
    ln -sf ${HOME}/toolkit/XSStrike/xsstrike.py /usr/local/bin/xsstrike

# theHarvester
RUN cd ${HOME}/toolkit && \
    git clone https://github.com/AlexisAhmed/theHarvester.git && \
    cd theHarvester && \
    python3.7 -m pip install -r requirements.txt && \
    chmod +x theHarvester.py && \
    ln -sf ${HOME}/toolkit/theHarvester/theHarvester.py /usr/local/bin/theharvester

# joomscan
RUN cd ${HOME}/toolkit && \
    git clone https://github.com/rezasp/joomscan.git && \
    cd joomscan/ && \
    chmod +x joomscan.pl
COPY joomscan.sh /opt
RUN chmod +x /opt/joomscan.sh && \
    ln -sf /opt/joomscan.sh /usr/local/bin/joomscan

# go
RUN cd /opt && \
    wget https://dl.google.com/go/go1.13.3.linux-amd64.tar.gz && \
    tar -xvf go1.13.3.linux-amd64.tar.gz && \
    rm -rf /opt/go1.13.3.linux-amd64.tar.gz && \
    mv go /usr/local
ENV GOROOT /usr/local/go
ENV GOPATH /root/go
ENV PATH ${GOPATH}/bin:${GOROOT}/bin:${PATH}

# gobuster
RUN cd ${HOME}/toolkit && \
    git clone https://github.com/OJ/gobuster.git && \
    cd gobuster && \
    go get && go install

# virtual-host-discovery
RUN cd ${HOME}/toolkit && \
    git clone https://github.com/AlexisAhmed/virtual-host-discovery.git && \
    cd virtual-host-discovery && \
    chmod +x scan.rb && \
    ln -sf ${HOME}/toolkit/virtual-host-discovery/scan.rb /usr/local/bin/virtual-host-discovery

# bucket_finder
RUN cd ${HOME}/toolkit && \
    git clone https://github.com/AlexisAhmed/bucket_finder.git && \
    cd bucket_finder && \
    chmod +x bucket_finder.rb && \
    ln -sf ${HOME}/toolkit/bucket_finder/bucket_finder.rb /usr/local/bin/bucket_finder

# dirsearch
RUN cd ${HOME}/toolkit && \
    git clone https://github.com/AlexisAhmed/dirsearch.git && \
    cd dirsearch && \
    chmod +x dirsearch.py && \
    ln -sf ${HOME}/toolkit/dirsearch/dirsearch.py /usr/local/bin/dirsearch

# s3recon
RUN pip3 install --upgrade setuptools && \
    pip3 install pyyaml pymongo requests s3recon

# metasploit-framework
RUN cd ${HOME} && \
    curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && \
    chmod 755 msfinstall && \
    ./msfinstall && \
    rm -f ${HOME}/msfinstall

# unicornscan
RUN cd ${HOME} && \
    wget http://http.kali.org/pool/main/u/unicornscan/unicornscan_0.4.7-1kali2_amd64.deb && \
    dpkg -i ./unicornscan_0.4.7-1kali2_amd64.deb && \
    rm -f ${HOME}/unicornscan_0.4.7-1kali2_amd64.deb

############################################
### Pentration Testers Framework Toolset ###
#### Credit to TrustedSec for building  ####
################ the basis #################

#################
### AV Bypass ###
#################
ENV AVBYPASS ${HOME}/toolkit/av-bypass
RUN mkdir -p ${AVBYPASS}

# backdoor factory
RUN cd ${AVBYPASS} && \
    git clone https://github.com/secretsquirrel/the-backdoor-factory.git && \
    cd ${AVBYPASS}/the-backdoor-factory && \
    chmod +x install.sh && \
    ./install.sh

# pyobfuscate
RUN cd ${AVBYPASS} && \
    git clone https://github.com/astrand/pyobfuscate.git && \
    cd ${AVBYPASS}/pyobfuscate && \
    python setup.py install

# shellter
# RUN cd ${AVBYPASS} && \
#     wget https://www.shellterproject.com/Downloads/Shellter/Latest/shellter.zip && \
#     unzip -j -o shellter.zip && \
#     rm shellter.zip && \
#     echo '#/bin/sh > shellter && \
#     echo pushd ${AVBYPASS}/shellter && \
#     echo 'wine shellter.exe' >> shellter && \
#     echo popd >> shellter && \
#     chmod +x shellter

# unlock
RUN cd ${AVBYPASS} && \
    git clone https://github.com/freshness79/unlock.git
    
##################
### Code Audit ###
##################
ENV CODEAUDIT ${HOME}/toolkit/code-audit
RUN mkdir -p ${CODEAUDIT}

# flawfinder
RUN cd ${CODEAUDIT} && \
    apt-get install -y flawfinder

# rough-auditing-tool-for-security
RUN cd ${CODEAUDIT} && \
    wget https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/rough-auditing-tool-for-security/rats-2.4.tgz && \
    tar xzf rats-2.4.tgz && \
    cd ${CODEAUDIT}/rats && \
    ./configure && \
    make -j4 && \
    make install

# splint
RUN cd ${CODEAUDIT} && \
    git clone https://github.com/splintchecker/splint.git && \
    cd ${CODEAUDIT}/splint && \
    ./configure && \
    make -j4 && \
    make install

####################
### Exploitation ###
####################
ENV EXPLOITATION ${HOME}/toolkit/exploitation
RUN mkdir -p ${EXPLOITATION}


##########################
### Install Word Lists ###
##########################

# word lists
#RUN cd ${HOME}/wordlists && \
#    git clone --depth 1 https://github.com/danielmiessler/SecLists.git
