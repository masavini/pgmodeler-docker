FROM debian:stretch-slim

# pgModeler version to use
ENV PG_VERSION 0.9.4-alpha
ENV DEBIAN_FRONTEND noninteractive

# Install dependencies
RUN set -ex; \
    BUILD_PKGS="make g++ qt5-qmake libxml2-dev qttools5-dev libpq-dev pkg-config libqt5svg5-dev libboost-dev git unzip wget"; \
    RUNTIME_PKGS="qt5-default libqt5svg5 postgresql-server-dev-9.6"; \
    apt-get update; \
    apt-get -y install ${BUILD_PKGS} ${RUNTIME_PKGS}; \
    cd /usr/local/src/; \
    wget -q https://codeload.github.com/pgmodeler/pgmodeler/tar.gz/v"${PG_VERSION}"; \
    wget -q http://paal.mimuw.edu.pl/paal.zip; \
    tar xvzf v"${PG_VERSION}"; \
    rm v"${PG_VERSION}"; \
    cd pgmodeler-"${PG_VERSION}"; \
    git clone https://www.github.com/pgmodeler/plugins; \
    cd plugins/graphicalquerybuilder; \
    git checkout master; \
    unzip /usr/local/src/paal.zip; \
    rm /usr/local/src/paal.zip; \
    mv home/paal/sources/paal .; \
    rm -r home; \
    cp paal.pro paal/; \
    cp dreyfus_wagner.hpp paal/include/paal/steiner_tree/; \
    sed -i -r 's/(GQB_JOIN_SOLVER|BOOST_INSTALLED)="n"/\1="y"/g' graphicalquerybuilder.conf; \
    cd /usr/local/src/pgmodeler-"${PG_VERSION}"; \
    mkdir -p /usr/local/lib/pgmodeler/plugins; \
    qmake -r CONFIG+=INTERACTIVE_QMAKE CONFIG+=release pgmodeler.pro; \
    make; \
    make install; \
    chmod 777 /usr/local/lib/pgmodeler/plugins; \
    apt-get remove --purge -y ${BUILD_PKGS}; \
    rm -rf /var/lib/apt/lists/*; \
    rm -r /usr/local/src/pgmodeler-"${PG_VERSION}"

# Run pgModeler
ENTRYPOINT ["/usr/local/bin/pgmodeler"]