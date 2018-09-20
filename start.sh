#ONIXd -testnet -addnode=107.170.213.97 -datadir=/datanode -rpcpassword=onixcoin -rpcuser=onixcoin -bind=127.0.0.1:141016 -rpcbind=127.0.0.1:141019 -daemon
ONIXd -testnet -addnode=107.170.213.97 -datadir=/datanode -rpcpassword=onixcoin -rpcuser=onixcoin -rpcallowip='127.0.0.1' -daemon
sleep 40
node insight.js
