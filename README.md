## OwnNFT Contract

A contract that allows anyone to upload and manage their own NFT
across marketplaces.


## Development

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

Steps to deploy to sepolia.

Populate the .env file with the following variables:

- `SEPOLIA_RPC_URL`
- `ETHERSCAN_API_KEY`
- `ACCOUNT` (name of the imported foundry account)

Next, run:

```shell
$ make deploy ARGS="--network sepolia"
```

After the deployment, find the contract address in:

`broadcast/DeployOwnft.s.sol/<network-id>/run-latest.json`

and the ABI:

`out/Ownft.sol/Ownft.json`

Update Makefile to deploy to any other network.

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
