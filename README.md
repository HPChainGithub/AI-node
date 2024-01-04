# ![image](https://github.com/HPChainGithub/node/assets/90428559/e990b2ac-0458-45f2-bbe4-2ffb0e2b9bbe) 
# HPCHAIN - Decentralized physical infrastructure network (DePIN) 
------------------------------------------------------------------
Welcome to HPCHAIN's official GitHub repo !

HPCHAIN is a secure, suistainable and decentralized cloud computing marketplace (https://www.hpchain.ai/) aimed to provide learners and developers with high quality and comprehensive computing resources.  

For a high-level overview of the HPchain protocol and tokenomics, check out the whitepaper on this github repo and the website.

The current branch contains limited features and is under active development; the mainnet/main branch will be realised soon.

To Run your own HPCHAIN AI node, run with Docker

### Requirements

- Install [Docker](https://docs.docker.com/get-docker/)
- Install [Postgres](https://www.postgresql.org/)
- Create an [Infura](https://infura.io/) account
  - Click the `Projects` section and create a new project.
  - In the `KEYS` section you will see a list of different credentials. Under `ENDPOINTS` tab change the select to `Ropsten`.
  - Underneath this you will have two links. Notice the `wss://ropsten.infura.io/ws/v3/...` link. You will need this in a second

### How to use

1. Optional: Customize the Docker Image

- `requirements.txt` (PIP packages list to install)
- `requirements_system.txt` (APT packages list to install)

2. Build the Image

```
docker build -t docker-hpchain.ai .

```

3. launch a Docker container:

```
docker run --runtime=nvidia --rm -it -p 8888:8888 -p 6006:6006 -v <HOST_PERSISTENT_STORAGE_PATH>:/home/docker-ai/projects -u docker-hpchain.ai docker-hpchain.ai
```
- (optional) 
- `hpchain login & choose your account
- `docker -- push {image_name}`

# Apply Docker image on vm instance without Kubenetes (k8s)

- ssh with external IP
- `docker images`
- `docker run --name docker-hpchain.ai --rm -d -p 80:80 docker-hpchain.ai


# Running the Node

    Run cd run-node

    Open the .env file and where ETH_URL=INFURA_ROPSTEN_LINK_HERE is paste your infura link.

    Create $PATH_TO_DIR/polygon-volume directory

    Create $PATH_TO_DIR/polygon-volume/password.txt - Password used within Polygon node for access Add the following:

secret

    Create $PATH_TO_DIR/polygon-volume/apicredentials.txt - Credientials to login into the Polygon UI Add the following:

test@test.tech
chainlinkPassword

    Add shared paths to Docker
        Docker -> Preferences -> Resources -> File Sharing
        Add $PATH_TO_DIR/chainlink-volume
        Add $PATH_TO_POSTGRES_DATA
    Run docker-compose up - This will run our docker-compose.yml and spin up a Postgres/Polygon node instance.
    This will run our Postgres instance but fail when starting the Polygon node because there is no chainlink postgres database created. We can solve this by entering the CLI of our Postgres(pg_chainlink) instance inside Docker.
    Open the Docker dashboard and click on chainlink-ropsten then open the CLI for chainlink-ropsten_database_1.
    Enter the Postgres console by typing: psql -U postgres -h localhost
    Now create the database: CREATE DATABASE chainlink;
    Run docker-compose up once again and your Polygon node should be running as expected.
    Goto: http://localhost:6688 and you will be greeted with a login page.
    Type in the credentials specified in your apicredentials.txt file and boom! You are logged into your locally running Chainlink node.
    You can locate your account address by clicking on the Configuration tab in the top right corner and locating the ACCOUNT_ADDRESS key variable.
    From here you should fund your address LINK and ETH. You can do that by copying your account address and going to the LINK ropsten faucet and ETH ropsten faucet.

# Roadmap 

HPCHAIN blockchain is currently based on Polygon 2.0 but with introducing improvements.

HPCHAIN aims to introduce an innovative proof-of-holding (PoH) system. Users with HPCHAIN coins get various bonuses for sharing computational resources on the HPCHAIN platform.
A neural network will be launched to set up MFP for new servers automatically.

# Contributing

If you have a reasonable understanding of blockchain technology you can of course contribute. 

We expect every contributor to be respectful and constructive so that everyone has a positive experience, you can find out more in our code of conduct.

# Join the community

https://t.me/hpchain

# License

HPCHAIN is licenced under MIT



