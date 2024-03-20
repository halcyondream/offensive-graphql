#
# Fetch repositories.
#
FROM alpine:3.19.1 AS git
WORKDIR /git 
RUN apk update && apk add git wget && \
    git clone https://github.com/dolevf/graphw00f && \
    git clone https://github.com/assetnote/batchql && \
    git clone https://gitlab.com/dee-see/graphql-path-enum && \
    git clone https://github.com/dolevf/graphql-cop && \
    git clone https://github.com/nicholasaleks/CrackQL && \
    git clone https://github.com/dolevf/nmap-graphql-introspection-nse
    

#
# Build GraphQL Path Enum.
#
FROM rust:1.76.0-slim-bookworm AS graphql-path-enum
WORKDIR /output
COPY --from=git /git/graphql-path-enum ./
RUN cargo build --release


#
# Set up the interactive system.
#
FROM kalilinux/kali-rolling:arm64

WORKDIR /setup 
USER root
COPY --from=graphql-path-enum /output/target/release /opt/graphql-path-enum
COPY --from=git /git/ /opt
RUN apt-get update && \
    apt-get -y install --no-install-recommends \
        python3 sudo python3-pip nmap curl bind9-dnsutils nano && \
    useradd --create-home kali && \
    echo "kali:kali" | chpasswd && \
    usermod -aG sudo kali && \
    cp /opt/nmap-graphql-introspection-nse/graphql-introspection.nse \
        /usr/share/nmap/scripts && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /home/kali
USER kali
COPY gethost.py /home/kali/
RUN pip3 install --no-cache-dir clairvoyance && \
    pip3 install --no-cache-dir inql && \
    pip3 install --no-cache-dir -r /opt/graphql-cop/requirements.txt && \
    mkdir tools && \
    ln -s /opt/graphql-path-enum/graphql-path-enum ./tools/graphql-path-enum && \
    ln -s /opt/graphql-cop/graphql-cop.py ./tools/graphql-cop.py && \
    ln -s /opt/CrackQL/CrackQL.py ./tools/crackql.py && \
    ln -s /opt/graphw00f/main.py ./tools/graphw00f.py && \
    ln -s /opt/batchql/batch.py ./tools/batchql.py && \
    chown kali:kali /home/kali/gethost.py

ENTRYPOINT ["/bin/bash"]
