FROM mhart/alpine-node:0.10.48

RUN apk --no-cache add autoconf automake git alpine-sdk python boost-dev openssl-dev db-dev

ENV BERKELEYDB_VERSION=db-4.8.30.NC
ENV BERKELEYDB_PREFIX=/opt/${BERKELEYDB_VERSION}

RUN wget https://download.oracle.com/berkeley-db/${BERKELEYDB_VERSION}.tar.gz
RUN tar -xzf *.tar.gz
RUN sed s/__atomic_compare_exchange/__atomic_compare_exchange_db/g -i ${BERKELEYDB_VERSION}/dbinc/atomic.h
RUN mkdir -p ${BERKELEYDB_PREFIX}

WORKDIR /${BERKELEYDB_VERSION}/build_unix

RUN ../dist/configure --enable-cxx --disable-shared --with-pic --prefix=${BERKELEYDB_PREFIX}
RUN make -j4
RUN make install
RUN rm -rf ${BERKELEYDB_PREFIX}/docs


WORKDIR /app
VOLUME /datanode


RUN git clone https://github.com/onix-project/insight-onix-api.git
RUN git clone https://github.com/onix-project/insight-onix-ui.git

RUN ln -s /app/insight-onix-ui/public/ /app/insight-onix-api/public
RUN git clone https://github.com/onix-project/onixcoin -b testnet && cd onixcoin/src && make -f makefile.unix USE_UPNP=- STATIC=1  BOOST_LIB_SUFFIX=-mt BDB_INCLUDE_PATH=/opt/db-4.8.30.NC/include BDB_LIB_PATH=/opt/db-4.8.30.NC/lib
RUN mv /app/onixcoin/src/ONIXd /bin/


WORKDIR /app/insight-onix-api
RUN npm install

ENV BITCOIND_USER="onixcoin"
ENV BITCOIND_PASS="onixcoin"
ENV BITCOIND_HOST="127.0.0.1"
ENV NODE_ENV="production"
ENV INSIGHT_NETWORK="testnet"
ENV INSIGHT_PUBLIC_PATH="public"
ENV INSIGHT_FORCE_RPC_SYNC="1"

CMD ["ONIXd", "-testnet", "-addnode=107.170.213.97", "-datadir=/datanode", "-rpcpassword=onixcoin", "-rpcuser=onixcoin", "-bind=127.0.0.1:141016", "-rpcbind=127.0.0.1:141019" , "-daemon", "&&", "sleep 40", "node", "insight.js"]
